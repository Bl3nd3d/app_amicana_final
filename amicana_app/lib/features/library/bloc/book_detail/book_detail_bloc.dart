import 'package:amicana_app/core/models/user_model.dart';
import 'package:amicana_app/core/services/progress_service.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:amicana_app/features/library/models/book_model.dart';
import 'package:amicana_app/features/library/models/reading_progress_model.dart';
import 'package:amicana_app/features/library/services/library_service.dart';

part 'book_detail_event.dart';
part 'book_detail_state.dart';

class BookDetailBloc extends Bloc<BookDetailEvent, BookDetailState> {
  final LibraryService _libraryService = LibraryService();
  final ProgressService _progressService = ProgressService();

  BookDetailBloc() : super(BookDetailInitial()) {
    on<FetchBookDetails>((event, emit) async {
      emit(BookDetailLoading());
      try {
        final book = await _libraryService.getBookById(event.bookId);
        // Usamos los datos del usuario autenticado para el progreso
        final progress = ReadingProgress(
            userId: event.user.id,
            bookId: book.id,
            completedChapterIds: Set<String>.from(event.user.completedChapterIds));
        emit(BookDetailLoaded(book: book, progress: progress));
      } catch (e) {
        emit(BookDetailError(message: e.toString()));
      }
    });

    on<ToggleChapterStatus>((event, emit) async {
      final currentState = state;
      if (currentState is BookDetailLoaded) {
        // Optimistic UI update
        final newCompletedChapterIds =
            Set<String>.from(currentState.progress.completedChapterIds);
        if (event.isCompleted) {
          newCompletedChapterIds.add(event.chapterId);
        } else {
          newCompletedChapterIds.remove(event.chapterId);
        }
        
        final newProgress = ReadingProgress(
          userId: currentState.progress.userId,
          bookId: currentState.progress.bookId,
          completedChapterIds: newCompletedChapterIds,
        );
        emit(currentState.copyWith(progress: newProgress));

        // Persist change to Firestore
        try {
          await _progressService.updateChapterProgress(event.chapterId, event.isCompleted);
        } catch (e) {
          // Si falla, revertimos el estado de la UI
          emit(currentState);
          // Opcional: mostrar un error
          // emit(BookDetailError(message: "Failed to save progress: ${e.toString()}"));
        }
      }
    });
  }
}
