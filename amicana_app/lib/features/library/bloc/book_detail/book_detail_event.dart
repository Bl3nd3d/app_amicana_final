part of 'book_detail_bloc.dart';

@immutable
abstract class BookDetailEvent {}

class ToggleChapterStatus extends BookDetailEvent {
  final String chapterId;
  ToggleChapterStatus({required this.chapterId});
}
