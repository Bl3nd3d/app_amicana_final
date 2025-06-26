import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:amicana_app/features/library/models/book_model.dart';
import 'package:amicana_app/features/library/services/library_service.dart'; // <-- 1. Importamos el nuevo servicio

part 'library_event.dart';
part 'library_state.dart';

class LibraryBloc extends Bloc<LibraryEvent, LibraryState> {
  // 2. Creamos una instancia de nuestro servicio
  final LibraryService _libraryService = LibraryService();

  LibraryBloc() : super(LibraryInitial()) {
    on<FetchBooks>((event, emit) async {
      emit(LibraryLoading());
      try {
        // Llamamos al servicio para obtener los libros reales.
        final books = await _libraryService.getBooks();
        emit(LibraryLoaded(books: books));
      } catch (e) {
        // Si el servicio falla estado de error.
        emit(LibraryError(message: e.toString()));
      }
    });
  }
}
