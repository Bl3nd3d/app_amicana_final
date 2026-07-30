import 'package:amicana_app/core/services/quiz_service.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import '../models/quiz_model.dart';

part 'quizzes_event.dart';
part 'quizzes_state.dart';

class QuizzesBloc extends Bloc<QuizzesEvent, QuizzesState> {
  final QuizService _quizService = QuizService();

  QuizzesBloc() : super(QuizzesInitial()) {
    on<FetchQuizzes>((event, emit) async {
      emit(QuizzesLoading());
      try {
        final quizzesWithoutQuestions = await _quizService.getQuizzes();
        final List<Quiz> quizzesWithQuestions = [];

        for (final quiz in quizzesWithoutQuestions) {
          final questions = await _quizService.getQuestionsForQuiz(quiz.id);
          quizzesWithQuestions.add(quiz.copyWith(questions: questions));
        }

        emit(QuizzesLoaded(quizzes: quizzesWithQuestions));
      } catch (e) {
        emit(QuizzesError(message: 'No se pudieron cargar las trivias desde Firestore.'));
      }
    });
  }
}
