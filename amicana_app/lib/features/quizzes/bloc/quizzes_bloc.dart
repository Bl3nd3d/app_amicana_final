import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import '../models/quiz_model.dart';
import '../models/question_model.dart';

part 'quizzes_event.dart';
part 'quizzes_state.dart';

class QuizzesBloc extends Bloc<QuizzesEvent, QuizzesState> {
  QuizzesBloc() : super(QuizzesInitial()) {
    on<FetchQuizzes>((event, emit) async {
      emit(QuizzesLoading());
      try {
        await Future.delayed(const Duration(seconds: 1));

        final now = DateTime.now();
        final mockQuizzes = [
          Quiz(
            id: 'q1',
            title: 'Historia Universal I',
            description: 'Prueba tus conocimientos sobre la Edad Antigua.',
            startDate: now.subtract(const Duration(days: 2)),
            endDate: now.add(const Duration(days: 2)),
            questions: [
              Question(
                  id: 'q1a',
                  text: '¿Dónde se originaron los Juegos Olímpicos?',
                  options: ['Roma', 'Atenas', 'Esparta', 'Egipto'],
                  correctAnswerIndex: 1),
              Question(
                  id: 'q1b',
                  text: '¿Quién fue el primer emperador romano?',
                  options: ['Julio César', 'Nerón', 'Augusto', 'Calígula'],
                  correctAnswerIndex: 2),
            ],
          ),
          Quiz(
            id: 'q2',
            title: 'Literatura Clásica',
            description: 'Un repaso por las grandes obras de la literatura.',
            startDate: now.subtract(const Duration(days: 10)),
            endDate: now.subtract(const Duration(days: 5)),
            questions: [
              Question(
                  id: 'q2a',
                  text: '¿Quién escribió "La Odisea"?',
                  options: ['Homero', 'Virgilio', 'Sófocles'],
                  correctAnswerIndex: 0),
            ],
          ),
          Quiz(
            id: 'q3',
            title: 'Ciencias Naturales',
            description: 'Conceptos básicos de biología.',
            startDate: now.add(const Duration(days: 3)),
            endDate: now.add(const Duration(days: 7)),
            questions: [],
          ),
        ];

        emit(QuizzesLoaded(quizzes: mockQuizzes));
      } catch (e) {
        emit(QuizzesError(message: 'No se pudieron cargar las trivias.'));
      }
    });
  }
}
