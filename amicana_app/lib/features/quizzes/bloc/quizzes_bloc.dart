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
          // --- NUEVO QUIZ AÑADIDO ---
          Quiz(
            id: 'q4-scarlet-letter',
            title: 'The Scarlet Letter: Chapter 1',
            description: 'Test your knowledge of the first chapter.',
            startDate: now
                .subtract(const Duration(days: 1)), // Hacemos que esté activo
            endDate: now.add(const Duration(days: 30)),
            questions: [
              Question(
                id: 'q4a',
                text:
                    'Which of the following best describes why prisons are referred to as the "black flower of civilized society" in the novel?',
                options: [
                  'Prisons represent the potential for beauty even in darkness',
                  'Prisons are a source of comfort for the Puritan community',
                  'Prisons punish sin yet also feed on sin in order to grow', // Correcta (índice 2)
                  'Prisons symbolize the strength and power of the human spirit'
                ],
                correctAnswerIndex: 2,
              ),
              Question(
                id: 'q4b',
                text:
                    'What does the speaker imagine is the significance of the wild rose bush growing next to the prison door?',
                options: [
                  'It offers the prisoners comfort and forgiveness from nature', // Correcta (índice 0)
                  'It indicates the hidden beauty of the prison that few can see',
                  'It symbolizes the resilience of the prisoners in the face of injustice',
                  'It shows that nature is reclaiming the area from the Puritans'
                ],
                correctAnswerIndex: 0,
              ),
              Question(
                id: 'q4c',
                text:
                    'What does the narrator say the rose blossom symbolizes for the story he plans to tell?',
                options: [
                  'The moral of the story', // Correcta (índice 0)
                  'Puritan wisdom and justice',
                  "The story's mysterious origins",
                  'The perfect beauty of nature'
                ],
                correctAnswerIndex: 0,
              ),
            ],
          ),
          // --- FIN DEL NUEVO QUIZ ---

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
        ];

        emit(QuizzesLoaded(quizzes: mockQuizzes));
      } catch (e) {
        emit(QuizzesError(message: 'No se pudieron cargar las trivias.'));
      }
    });
  }
}
