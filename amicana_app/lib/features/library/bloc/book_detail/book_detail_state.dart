part of 'book_detail_bloc.dart';

@immutable
abstract class BookDetailState {}

class BookDetailInitial extends BookDetailState {}

class BookDetailLoading extends BookDetailState {}

class BookDetailLoaded extends BookDetailState {
  final Book book;
  final ReadingProgress progress;

  BookDetailLoaded({required this.book, required this.progress});

  BookDetailLoaded copyWith({
    Book? book,
    ReadingProgress? progress,
  }) {
    return BookDetailLoaded(
      book: book ?? this.book,
      progress: progress ?? this.progress,
    );
  }
}

class BookDetailError extends BookDetailState {
  final String message;
  BookDetailError({required this.message});
}
