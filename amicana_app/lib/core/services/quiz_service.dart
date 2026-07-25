import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:amicana_app/features/quizzes/models/quiz_model.dart';
import 'package:amicana_app/features/quizzes/models/question_model.dart';

class QuizService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Quiz>> getQuizzes() async {
    try {
      final querySnapshot = await _firestore.collection('quizzes').get();
      final quizzes = querySnapshot.docs
          .map((doc) => Quiz.fromFirestore(doc))
          .toList();
      return quizzes;
    } catch (e) {
      // TODO: Implement proper logging
      print('Error fetching quizzes: $e');
      rethrow;
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
      // TODO: Implement proper logging
      print('Error fetching questions for quiz $quizId: $e');
      rethrow;
    }
  }
}
