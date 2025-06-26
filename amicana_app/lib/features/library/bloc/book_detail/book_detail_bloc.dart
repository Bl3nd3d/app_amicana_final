import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:amicana_app/features/library/models/book_model.dart';
import 'package:amicana_app/features/library/models/reading_progress_model.dart';
import 'package:amicana_app/features/library/services/library_service.dart';

part 'book_detail_event.dart';
part 'book_detail_state.dart';

class BookDetailBloc extends Bloc<BookDetailEvent, BookDetailState> {
  final LibraryService _libraryService = LibraryService();

  BookDetailBloc() : super(BookDetailInitial()) {
    on<FetchBookDetails>((event, emit) async {
      emit(BookDetailLoading());
      try {
        final book = await _libraryService.getBookById(event.bookId);
        final progress = ReadingProgress(
            userId: 'current_user_id',
            bookId: book.id,
            completedChapterIds: {});
        emit(BookDetailLoaded(book: book, progress: progress));
      } catch (e) {
        emit(BookDetailError(message: e.toString()));
      }
    });

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
      }
    });
  }
}
