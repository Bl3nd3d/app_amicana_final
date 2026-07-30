import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:amicana_app/features/library/models/book_model.dart';
import 'package:amicana_app/core/models/chapter_model.dart';
import 'package:amicana_app/features/library/services/library_service.dart';
import 'package:amicana_app/features/quizzes/models/quiz_model.dart';
import 'package:amicana_app/core/services/quiz_service.dart';

/// Resultado de búsqueda para un capítulo: necesita el libro al que
/// pertenece para poder navegar al detalle correspondiente.
class ChapterSearchResult {
  final Book book;
  final Chapter chapter;
  const ChapterSearchResult({required this.book, required this.chapter});
}

@immutable
class SearchState {
  final bool loading;
  final String? error;
  final String query;
  final List<Book> allBooks;
  final List<Quiz> allQuizzes;

  const SearchState({
    this.loading = true,
    this.error,
    this.query = '',
    this.allBooks = const [],
    this.allQuizzes = const [],
  });

  SearchState copyWith({
    bool? loading,
    String? error,
    String? query,
    List<Book>? allBooks,
    List<Quiz>? allQuizzes,
  }) {
    return SearchState(
      loading: loading ?? this.loading,
      error: error,
      query: query ?? this.query,
      allBooks: allBooks ?? this.allBooks,
      allQuizzes: allQuizzes ?? this.allQuizzes,
    );
  }

  bool get hasQuery => query.trim().isNotEmpty;

  List<Book> get matchingBooks {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return const [];
    return allBooks
        .where((b) =>
            b.title.toLowerCase().contains(q) || b.author.toLowerCase().contains(q))
        .toList();
  }

  List<ChapterSearchResult> get matchingChapters {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return const [];
    final results = <ChapterSearchResult>[];
    for (final book in allBooks) {
      for (final chapter in book.chapters) {
        if (chapter.title.toLowerCase().contains(q) ||
            chapter.synopsis.toLowerCase().contains(q)) {
          results.add(ChapterSearchResult(book: book, chapter: chapter));
        }
      }
    }
    return results;
  }

  List<Quiz> get matchingQuizzes {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return const [];
    return allQuizzes
        .where((quiz) =>
            quiz.title.toLowerCase().contains(q) ||
            quiz.description.toLowerCase().contains(q) ||
            quiz.category.toLowerCase().contains(q))
        .toList();
  }
}

class SearchCubit extends Cubit<SearchState> {
  final LibraryService _libraryService;
  final QuizService _quizService;

  SearchCubit({LibraryService? libraryService, QuizService? quizService})
      : _libraryService = libraryService ?? LibraryService(),
        _quizService = quizService ?? QuizService(),
        super(const SearchState());

  Future<void> loadContent() async {
    emit(state.copyWith(loading: true, error: null));
    try {
      final books = await _libraryService.getBooks();

      final quizzesBase = await _quizService.getQuizzes();
      final quizzesWithQuestions = <Quiz>[];
      for (final quiz in quizzesBase) {
        final questions = await _quizService.getQuestionsForQuiz(quiz.id);
        quizzesWithQuestions.add(quiz.copyWith(questions: questions));
      }

      emit(state.copyWith(
        loading: false,
        allBooks: books,
        allQuizzes: quizzesWithQuestions,
      ));
    } catch (e) {
      emit(state.copyWith(
        loading: false,
        error: 'No se pudo cargar el contenido para buscar.',
      ));
    }
  }

  void search(String query) {
    emit(state.copyWith(query: query));
  }
}
