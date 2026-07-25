part of 'book_detail_bloc.dart';

@immutable
abstract class BookDetailEvent {}

class FetchBookDetails extends BookDetailEvent {
  final String bookId;
  final User user;
  FetchBookDetails({required this.bookId, required this.user});
}

class ToggleChapterStatus extends BookDetailEvent {
  final String chapterId;
  final bool isCompleted;
  ToggleChapterStatus({required this.chapterId, required this.isCompleted});
}
