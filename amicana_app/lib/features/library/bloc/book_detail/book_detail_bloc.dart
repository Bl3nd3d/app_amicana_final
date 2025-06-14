import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

// --- IMPORTACIONES CENTRALIZADAS AQUÍ ---
// El BLoC importa los modelos para que sus 'partes' (state y event) puedan usarlos.
import 'package:amicana_app/features/library/models/book_model.dart';
import 'package:amicana_app/features/library/models/reading_progress_model.dart';
// ----------------------------------------

part 'book_detail_event.dart';
part 'book_detail_state.dart';

class BookDetailBloc extends Bloc<BookDetailEvent, BookDetailState> {
  final Book book;

  BookDetailBloc({required this.book}) : super(BookDetailInitial()) {
    // Simulación del progreso inicial al cargar el BLoC
    final initialProgress = ReadingProgress(
      userId: 'current_user_id', // Simulado
      bookId: book.id,
      completedChapterIds: {}, // Inicialmente ningún capítulo está completado
    );

    // Emitir inmediatamente el estado cargado con los datos iniciales
    emit(BookDetailLoaded(book: book, progress: initialProgress));

    on<ToggleChapterStatus>((event, emit) {
      final currentState = state;
      if (currentState is BookDetailLoaded) {
        final currentProgress = currentState.progress;
        final newCompletedChapterIds =
            Set<String>.from(currentProgress.completedChapterIds);

        // Lógica para añadir o quitar el capítulo del Set de completados
        if (newCompletedChapterIds.contains(event.chapterId)) {
          newCompletedChapterIds.remove(event.chapterId);
        } else {
          newCompletedChapterIds.add(event.chapterId);
        }

        // Crea un nuevo objeto de progreso con los datos actualizados
        final newProgress = ReadingProgress(
          userId: currentProgress.userId,
          bookId: currentProgress.bookId,
          completedChapterIds: newCompletedChapterIds,
        );

        // Emite un nuevo estado con el progreso actualizado
        emit(currentState.copyWith(progress: newProgress));
        print('Progreso actualizado: ${newProgress.completedChapterIds}');
      }
    });
  }
}
