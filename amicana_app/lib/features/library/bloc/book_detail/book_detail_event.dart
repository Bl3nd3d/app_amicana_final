part of 'book_detail_bloc.dart';

@immutable
abstract class BookDetailEvent {}

// Evento para solicitar los detalles de un libro específico usando su ID
class FetchBookDetails extends BookDetailEvent {
  final String bookId;
  FetchBookDetails({required this.bookId});
}

// Evento para marcar/desmarcar un capítulo
class ToggleChapterStatus extends BookDetailEvent {
  final String chapterId;
  ToggleChapterStatus({required this.chapterId});
}
