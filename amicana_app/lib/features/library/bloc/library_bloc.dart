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
            description:
                'La novela narra la historia de la familia Buendía a lo largo de siete generaciones en el pueblo ficticio de Macondo.',
            chapters: [
              Chapter(
                id: 'c1-1',
                title: 'Capítulo 1: El Descubrimiento del Hielo',
                pageCount: 20,
                synopsis:
                    'Una descripción detallada del primer capítulo, donde la familia Buendía se encuentra por primera vez con la maravilla del hielo, llevada por los gitanos liderados por Melquíades.',
                audioUrl: 'https://www.ejemplo.com/audio/libro1_cap1.mp3',
                pdfUrl: 'https://www.ejemplo.com/pdf/libro1_cap1.pdf',
              ),
              Chapter(
                id: 'c1-2',
                title: 'Capítulo 2: Los Pergaminos de Melquíades',
                pageCount: 25,
                synopsis:
                    'José Arcadio Buendía se obsesiona con descifrar los pergaminos del gitano Melquíades, emprendiendo una búsqueda del conocimiento que lo aísla del mundo.',
                audioUrl: 'https://www.ejemplo.com/audio/libro1_cap2.mp3',
                pdfUrl: null, // Ejemplo de un capítulo sin PDF
              ),
            ],
          ),
          Book(
            id: '2',
            title: 'Don Quijote de la Mancha',
            author: 'Miguel de Cervantes',
            coverUrl: 'https://pictures.abebooks.com/isbn/9788466226969-es.jpg',
            description:
                'Considerada la obra más destacada de la literatura española y una de las principales de la literatura universal.',
            chapters: [
              Chapter(
                id: 'c2-1',
                title:
                    'Capítulo 1: Que trata de la condición y ejercicio del famoso hidalgo',
                pageCount: 30,
                synopsis:
                    'Se presenta a Alonso Quijano, un hidalgo de la Mancha que, de tanto leer libros de caballerías, pierde el juicio y decide hacerse caballero andante.',
                audioUrl: null, // Ejemplo de un capítulo sin audio
                pdfUrl: 'https://www.ejemplo.com/pdf/libro2_cap1.pdf',
              ),
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
