import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:amicana_app/features/library/models/book_model.dart';
import 'package:amicana_app/features/library/bloc/book_detail/book_detail_bloc.dart';

class BookDetailScreen extends StatelessWidget {
  final Book book;
  const BookDetailScreen({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BookDetailBloc(book: book),
      child: Scaffold(
        appBar: AppBar(
          title: Text(book.title),
        ),
        body: BlocBuilder<BookDetailBloc, BookDetailState>(
          builder: (context, state) {
            if (state is BookDetailLoaded) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Hero(
                        tag: 'book-cover-${book.id}',
                        child: Image.network(book.coverUrl,
                            height: 300, fit: BoxFit.contain),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      book.title,
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Center(
                        child: Text('por ${book.author}',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(fontStyle: FontStyle.italic))),
                    const SizedBox(height: 24),
                    Text(book.description,
                        style: Theme.of(context).textTheme.bodyLarge,
                        textAlign: TextAlign.justify),
                    const Divider(height: 40, thickness: 1),
                    Text('Progreso de Lectura',
                        style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 16),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: state.book.chapters.length,
                      itemBuilder: (context, index) {
                        final chapter = state.book.chapters[index];
                        final isCompleted = state.progress.completedChapterIds
                            .contains(chapter.id);

                        return CheckboxListTile(
                          title: Text(chapter.title),
                          value: isCompleted,
                          onChanged: (bool? value) {
                            context.read<BookDetailBloc>().add(
                                ToggleChapterStatus(chapterId: chapter.id));
                          },
                          secondary: const Icon(Icons.bookmark_border),
                          activeColor: Theme.of(context).primaryColor,
                        );
                      },
                    ),
                  ],
                ),
              );
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
