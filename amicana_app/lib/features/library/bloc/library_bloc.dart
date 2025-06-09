import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import '../models/book_model.dart';

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
            description:
                'La novela narra la historia de la familia Buendía a lo largo de siete generaciones en el pueblo ficticio de Macondo.',
          ),
          Book(
            id: '2',
            title: 'Don Quijote de la Mancha',
            author: 'Miguel de Cervantes',
            coverUrl: 'https://pictures.abebooks.com/isbn/9788466226969-es.jpg',
            description:
                'Considerada la obra más destacada de la literatura española y una de las principales de la literatura universal.',
          ),
          Book(
            id: '3',
            title: 'Ficciones',
            author: 'Jorge Luis Borges',
            coverUrl:
                'https://images.cdn2.buscalibre.com/fit-in/360x360/0d/2b/0d2b785f7318a52f462153573a0a3838.jpg',
            description:
                'Una colección de cuentos que exploran temas como el tiempo, los laberintos, la identidad y la realidad.',
          ),
          Book(
            id: '4',
            title: 'El Principito',
            author: 'Antoine de Saint-Exupéry',
            coverUrl:
                'https://www.vreditoras.com.ar/uploads/libros/1032/9789877478393.jpg',
            description:
                'Un cuento poético que viene con ilustraciones hechas con acuarelas por el mismo Saint-Exupéry.',
          ),
        ];

        emit(LibraryLoaded(books: mockBooks));
      } catch (e) {
        emit(LibraryError(message: 'No se pudieron cargar los libros.'));
      }
    });
  }
}
