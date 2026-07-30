import 'package:amicana_app/features/auth/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:amicana_app/features/library/bloc/book_detail/book_detail_bloc.dart';
import 'package:amicana_app/core/widgets/bookmark_button.dart';
import 'package:amicana_app/core/models/user_model.dart';

class BookDetailScreen extends StatefulWidget {
  final String bookId;
  const BookDetailScreen({super.key, required this.bookId});

  @override
  State<BookDetailScreen> createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends State<BookDetailScreen> {
  @override
  void initState() {
    super.initState();
    // It's safer to trigger events after the first frame.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authState = context.read<AuthBloc>().state;
      if (authState is AuthSuccess) {
        context
            .read<BookDetailBloc>()
            .add(FetchBookDetails(bookId: widget.bookId, user: authState.user));
      } else {
        // The router's redirect should prevent unauthenticated access,
        // but as a safeguard, we can show an error or pop.
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Authentication error. Please log in again.'),
                backgroundColor: Colors.red),
          );
          context.pop();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // We still need the user for the BookmarkButton, so we watch AuthBloc state.
    final authState = context.watch<AuthBloc>().state;
    final User? user = (authState is AuthSuccess) ? authState.user : null;

    return Scaffold(
      backgroundColor: const Color(0xFF0A183C),
      body: BlocBuilder<BookDetailBloc, BookDetailState>(
        builder: (context, state) {
          // 1. Handle loading state
          if (state is BookDetailLoading || state is BookDetailInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          // 2. Handle error states
          if (state is BookDetailError) {
            // Specific check for 'not found' as suggested
            if (state.message.contains('El libro no fue encontrado')) {
              return const Center(
                  child:
                      Text('Libro no encontrado', style: TextStyle(color: Colors.white)));
            }
            // Generic error
            return Center(
                child: Text('Error al cargar el libro: ${state.message}',
                    style: const TextStyle(color: Colors.white)));
          }

          // 3. Handle loaded state
          if (state is BookDetailLoaded) {
            final book = state.book;
            // The user must not be null here because the BLoC needs it to get to this state
            if (user == null) {
              return const Center(
                  child: Text('Error: Usuario no disponible.',
                      style: TextStyle(color: Colors.white)));
            }

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
                  actions: [
                    BookmarkButton(userId: user.id, bookId: book.id),
                  ],
                  flexibleSpace: FlexibleSpaceBar(
                    background: Hero(
                      tag: 'book-cover-${book.id}',
                      child: Image.network(
                        book.coverUrl,
                        fit: BoxFit.cover,
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
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: Colors.white.withAlpha(230),
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
                      final isCompleted =
                          state.progress.completedChapterIds.contains(chapter.id);
                      return ListTile(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 16.0),
                        leading: Checkbox(
                          value: isCompleted,
                          onChanged: (bool? value) {
                            if (value != null) {
                              context.read<BookDetailBloc>().add(
                                  ToggleChapterStatus(
                                      chapterId: chapter.id, isCompleted: value));
                            }
                          },
                          activeColor: Theme.of(context).primaryColor,
                          checkColor: Colors.white,
                          side: const BorderSide(color: Colors.white54),
                        ),
                        title: Text(chapter.title,
                            style: const TextStyle(color: Colors.white)),
                        onTap: () {
                          context.push(
                            '/books/${book.id}/chapter/${chapter.id}',
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

          // Fallback for any unhandled state
          return const Center(child: Text('Ocurrió un error inesperado.', style: TextStyle(color: Colors.white)));
        },
      ),
    );
  }
}
