import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:amicana_app/features/library/models/book_model.dart';
import 'package:amicana_app/core/models/chapter_model.dart';
import 'package:amicana_app/features/library/bloc/book_detail/book_detail_bloc.dart';

class BookDetailScreen extends StatelessWidget {
  final Book book;
  const BookDetailScreen({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    // Proveemos el BLoC específico para esta pantalla
    return BlocProvider(
      create: (context) => BookDetailBloc(book: book),
      child: Scaffold(
        backgroundColor: const Color(0xFF0A183C),
        body: Stack(
          children: [
            Positioned.fill(
              child: Opacity(
                opacity: 0.3,
                child: Image.asset('assets/images/fondo_app.png',
                    fit: BoxFit.cover),
              ),
            ),
            // Usamos un CustomScrollView para tener más control sobre el scroll y el AppBar
            CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: 300.0,
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Hero(
                      tag: 'book-cover-${book.id}',
                      child: Image.network(
                        book.coverUrl,
                        fit: BoxFit.cover,
                        color: Colors.black.withOpacity(0.4),
                        colorBlendMode: BlendMode.darken,
                      ),
                    ),
                  ),
                ),
                // SliverList nos permite poner una lista dentro de un CustomScrollView
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          book.title,
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'por ${book.author}',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                                  color: Colors.white70,
                                  fontStyle: FontStyle.italic),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          book.description,
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(color: Colors.white.withOpacity(0.8)),
                          textAlign: TextAlign.justify,
                        ),
                        const Divider(
                            height: 40, thickness: 1, color: Colors.white24),
                        Text(
                          'Progreso de Lectura',
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(color: Colors.white),
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                ),
                // El BlocBuilder ahora envuelve solo a la lista de capítulos
                BlocBuilder<BookDetailBloc, BookDetailState>(
                  builder: (context, state) {
                    if (state is BookDetailLoaded) {
                      return SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final chapter = state.book.chapters[index];
                            final isCompleted = state
                                .progress.completedChapterIds
                                .contains(chapter.id);

                            // --- ESTE ES TU CÓDIGO INTEGRADO ---
                            return ListTile(
                              leading: Checkbox(
                                value: isCompleted,
                                onChanged: (bool? value) {
                                  context.read<BookDetailBloc>().add(
                                      ToggleChapterStatus(
                                          chapterId: chapter.id));
                                },
                                activeColor: Theme.of(context).primaryColor,
                                checkColor: Colors.white,
                                side: const BorderSide(color: Colors.white54),
                              ),
                              title: Text(chapter.title,
                                  style: const TextStyle(color: Colors.white)),
                              onTap: () {
                                context.go(
                                  '/library/book/${state.book.id}/chapter/${chapter.id}',
                                  extra: {
                                    'book': state.book,
                                    'chapter': chapter
                                  },
                                );
                              },
                              trailing: const Icon(Icons.arrow_forward_ios,
                                  color: Colors.white54, size: 16),
                            );
                          },
                          childCount: state.book.chapters.length,
                        ),
                      );
                    }
                    // Si no está cargado, no mostramos nada o un spinner
                    return const SliverToBoxAdapter(
                      child: Center(child: CircularProgressIndicator()),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
