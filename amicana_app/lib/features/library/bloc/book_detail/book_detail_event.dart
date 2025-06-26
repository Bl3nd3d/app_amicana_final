part of 'book_detail_bloc.dart';

@immutable
abstract class BookDetailEvent {}

class FetchBookDetails extends BookDetailEvent {
  final String bookId;
  FetchBookDetails({required this.bookId});
}

class ToggleChapterStatus extends BookDetailEvent {
  final String chapterId;
  ToggleChapterStatus({required this.chapterId});
}
