import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

// --- IMPORTACIONES MOVIDAS AQUÍ ---
// Ahora el BLoC se encarga de importar los modelos que sus 'partes' necesitan.
import 'package:amicana_app/features/library//models/book_model.dart';
import 'package:amicana_app/features/library/models/reading_progress_model.dart';
// ------------------------------------

part 'book_detail_event.dart';
part 'book_detail_state.dart';

class BookDetailBloc extends Bloc<BookDetailEvent, BookDetailState> {
  final Book book;

  BookDetailBloc({required this.book}) : super(BookDetailInitial()) {
    // El resto de la lógica no necesita cambios.
    final initialProgress = ReadingProgress(
      userId: 'current_user_id',
      bookId: book.id,
      completedChapterIds: {},
    );

    emit(BookDetailLoaded(book: book, progress: initialProgress));

    on<ToggleChapterStatus>((event, emit) {
      final currentState = state;
      if (currentState is BookDetailLoaded) {
        final currentProgress = currentState.progress;
        final newCompletedChapterIds =
            Set<String>.from(currentProgress.completedChapterIds);

        if (newCompletedChapterIds.contains(event.chapterId)) {
          newCompletedChapterIds.remove(event.chapterId);
        } else {
          newCompletedChapterIds.add(event.chapterId);
        }

        final newProgress = ReadingProgress(
          userId: currentProgress.userId,
          bookId: currentProgress.bookId,
          completedChapterIds: newCompletedChapterIds,
        );

        emit(currentState.copyWith(progress: newProgress));
        print('Progreso actualizado: ${newProgress.completedChapterIds}');
      }
    });
  }
}
