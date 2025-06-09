part of 'library_bloc.dart';

@immutable
abstract class LibraryState {}

class LibraryInitial extends LibraryState {}

class LibraryLoading extends LibraryState {}

class LibraryLoaded extends LibraryState {
  final List<Book> books;
  LibraryLoaded({required this.books});
}

class LibraryError extends LibraryState {
  final String message;
  LibraryError({required this.message});
}
