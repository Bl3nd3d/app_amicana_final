import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:amicana_app/features/library/models/book_model.dart';
import 'package:amicana_app/core/models/chapter_model.dart';

part 'library_event.dart';
part 'library_state.dart';

class LibraryBloc extends Bloc<LibraryEvent, LibraryState> {
  LibraryBloc() : super(LibraryInitial()) {
    on<FetchBooks>((event, emit) async {
      emit(LibraryLoading());
      try {
        await Future.delayed(const Duration(milliseconds: 1500));

        final mockBooks = [
          Book(
            id: '1',
            title: 'Cien Años de Soledad',
            author: 'Gabriel García Márquez',
            coverUrl:
                'https://images.penguinrandomhouse.com/cover/9780525562443',
            description: 'La novela narra la historia de la familia Buendía...',
            chapters: [
              Chapter(
                  id: 'c1-1',
                  title: 'Capítulo 1: El Descubrimiento del Hielo',
                  pageCount: 20),
              Chapter(
                  id: 'c1-2',
                  title: 'Capítulo 2: Los Pergaminos de Melquíades',
                  pageCount: 25),
              Chapter(
                  id: 'c1-3',
                  title: 'Capítulo 3: La Peste del Insomnio',
                  pageCount: 22),
            ],
          ),
          Book(
            id: '2',
            title: 'Don Quijote de la Mancha',
            author: 'Miguel de Cervantes',
            coverUrl: 'https://pictures.abebooks.com/isbn/9788466226969-es.jpg',
            description:
                'Considerada la obra más destacada de la literatura española...',
            chapters: [
              Chapter(
                  id: 'c2-1',
                  title: 'Capítulo 1: Que trata de la condición...',
                  pageCount: 30),
              Chapter(
                  id: 'c2-2',
                  title: 'Capítulo 2: De la primera salida que hizo...',
                  pageCount: 15),
            ],
          ),
        ];

        emit(LibraryLoaded(books: mockBooks));
      } catch (e) {
        emit(LibraryError(message: 'No se pudieron cargar los libros.'));
      }
    });
  }
}
