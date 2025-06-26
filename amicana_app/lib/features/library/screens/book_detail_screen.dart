import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
// Las importaciones de 'book_model' y 'chapter_model' se han eliminado porque no son necesarias aquí.
import 'package:amicana_app/features/library/bloc/book_detail/book_detail_bloc.dart';

class BookDetailScreen extends StatelessWidget {
  final String bookId;
  const BookDetailScreen({super.key, required this.bookId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          BookDetailBloc()..add(FetchBookDetails(bookId: bookId)),
      child: Scaffold(
        backgroundColor: const Color(0xFF0A183C),
        body: BlocBuilder<BookDetailBloc, BookDetailState>(
          builder: (context, state) {
            if (state is BookDetailLoading || state is BookDetailInitial) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is BookDetailError) {
              return Center(
                  child: Text(state.message,
                      style: const TextStyle(color: Colors.white)));
            }
            if (state is BookDetailLoaded) {
              final book = state.book;
              return CustomScrollView(
                slivers: [
                  SliverAppBar(
                    expandedHeight: 300.0,
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    pinned: true,
                    leading: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => context.pop(),
                    ),
                    flexibleSpace: FlexibleSpaceBar(
                      background: Hero(
                        tag: 'book-cover-${book.id}',
                        child: Image.network(
                          book.coverUrl,
                          fit: BoxFit.cover,
                          // --- USO DE COLOR CORREGIDO ---
                          color: const Color.fromRGBO(0, 0, 0, 0.4),
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
                                      // --- USO DE OPACIDAD CORREGIDO ---
                                      color: Colors.white
                                          .withAlpha(230), // ~90% de opacidad
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
                            context.push(
                              'chapter/${chapter.id}',
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
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
