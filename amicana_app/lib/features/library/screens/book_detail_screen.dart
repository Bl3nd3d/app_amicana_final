import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:amicana_app/features/library/models/book_model.dart';
import 'package:amicana_app/core/models/chapter_model.dart';
import 'package:amicana_app/features/library/bloc/book_detail/book_detail_bloc.dart';

class BookDetailScreen extends StatelessWidget {
  // Ahora recibe el ID, no el objeto completo
  final String bookId;
  const BookDetailScreen({super.key, required this.bookId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      // Creamos el BLoC y le decimos que cargue los datos con el ID recibido
      create: (context) =>
          BookDetailBloc()..add(FetchBookDetails(bookId: bookId)),
      child: Scaffold(
        backgroundColor: const Color(0xFF0A183C),
        // El BlocBuilder escucha los estados y redibuja la UI
        body: BlocBuilder<BookDetailBloc, BookDetailState>(
          builder: (context, state) {
            // Mientras carga, mostramos un spinner
            if (state is BookDetailLoading || state is BookDetailInitial) {
              return const Center(child: CircularProgressIndicator());
            }
            // Si hay un error, lo mostramos
            if (state is BookDetailError) {
              return Center(
                  child: Text(state.message,
                      style: const TextStyle(color: Colors.white)));
            }
            // Si los datos se cargaron, construimos la pantalla
            if (state is BookDetailLoaded) {
              final book = state.book;
              return CustomScrollView(
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
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(book.title,
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          Text('por ${book.author}',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                      color: Colors.white70,
                                      fontStyle: FontStyle.italic)),
                          const SizedBox(height: 16),
                          Text(book.description,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                      color: Colors.white.withOpacity(0.9),
                                      height: 1.5)),
                          const Divider(
                              height: 40, thickness: 1, color: Colors.white24),
                          Text('Progreso de Lectura',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(color: Colors.white)),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final chapter = state.book.chapters[index];
                        final isCompleted = state.progress.completedChapterIds
                            .contains(chapter.id);
                        return ListTile(
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 16.0),
                          leading: Checkbox(
                            value: isCompleted,
                            onChanged: (bool? value) {
                              context.read<BookDetailBloc>().add(
                                  ToggleChapterStatus(chapterId: chapter.id));
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
                              extra: {'book': state.book, 'chapter': chapter},
                            );
                          },
                          trailing: const Icon(Icons.arrow_forward_ios,
                              color: Colors.white54, size: 16),
                        );
                      },
                      childCount: state.book.chapters.length,
                    ),
                  ),
                ],
              );
            }
            // En caso de un estado inesperado, no mostramos nada
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
