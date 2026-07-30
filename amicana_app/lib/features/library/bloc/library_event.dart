part of 'library_bloc.dart';

@immutable
abstract class LibraryEvent {}

class FetchBooks extends LibraryEvent {}

class FetchBooksByCategory extends LibraryEvent {
  final String category;
  FetchBooksByCategory({required this.category});
}
