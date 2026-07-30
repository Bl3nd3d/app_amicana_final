import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:amicana_app/features/quizzes/models/quiz_model.dart';
import 'package:amicana_app/features/quizzes/models/question_model.dart';
import 'package:amicana_app/core/data/seed_data.dart';

class QuizService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Quiz>> getQuizzes() async {
    try {
      final querySnapshot = await _firestore.collection('quizzes').get();
      final quizzes =
          querySnapshot.docs.map((doc) => Quiz.fromFirestore(doc)).toList();
      return quizzes;
    } catch (e) {
      throw Exception('No se pudieron cargar las trivias: $e');
    }
  }

  Future<List<Question>> getQuestionsForQuiz(String quizId) async {
    try {
      final querySnapshot = await _firestore
          .collection('quizzes')
          .doc(quizId)
          .collection('questions')
          .get();
      final questions = querySnapshot.docs
          .map((doc) => Question.fromFirestore(doc))
          .toList();
      return questions;
    } catch (e) {
      throw Exception('No se pudieron cargar las preguntas de la trivia: $e');
    }
  }

  /// Borra la colección 'quizzes' existente (con sus preguntas) y la vuelve
  /// a poblar con los datos de prueba de 'seed_data.dart'.
  Future<void> seedQuizzes() async {
    final quizzesRef = _firestore.collection('quizzes');
    final snapshot = await quizzesRef.get();
    for (final doc in snapshot.docs) {
      final questionsSnapshot = await doc.reference.collection('questions').get();
      for (final questionDoc in questionsSnapshot.docs) {
        await questionDoc.reference.delete();
      }
      await doc.reference.delete();
    }

    for (final quizData in seedQuizzesData) {
      final quizDataForFirestore = Map<String, dynamic>.from(quizData);
      final questionsData = quizDataForFirestore.remove('questions')
          as List<Map<String, dynamic>>;

      // Convertimos los DateTime del archivo semilla a Timestamp de Firestore.
      quizDataForFirestore['startDate'] =
          Timestamp.fromDate(quizDataForFirestore['startDate'] as DateTime);
      quizDataForFirestore['endDate'] =
          Timestamp.fromDate(quizDataForFirestore['endDate'] as DateTime);

      await quizzesRef.doc(quizDataForFirestore['id']).set(quizDataForFirestore);

      final questionsRef =
          quizzesRef.doc(quizDataForFirestore['id']).collection('questions');
      for (final questionData in questionsData) {
        final questionDataForFirestore =
            Map<String, dynamic>.from(questionData);
        await questionsRef
            .doc(questionDataForFirestore['id'])
            .set(questionDataForFirestore);
      }
    }
  }
}
