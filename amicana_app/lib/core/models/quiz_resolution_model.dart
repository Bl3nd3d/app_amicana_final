import 'package:cloud_firestore/cloud_firestore.dart';

/// Representa un intento resuelto de una trivia, guardado en
/// users/{uid}/resolutions/{id}. Guarda el título y el total de preguntas
/// desnormalizados para no tener que volver a consultar la trivia original
/// solo para mostrar el historial.
class QuizResolution {
  final String id;
  final String quizId;
  final String quizTitle;
  final String category;
  final int scoreObtained;
  final int totalQuestions;
  final DateTime? timestamp;

  QuizResolution({
    required this.id,
    required this.quizId,
    required this.quizTitle,
    required this.category,
    required this.scoreObtained,
    required this.totalQuestions,
    required this.timestamp,
  });

  double get accuracy =>
      totalQuestions > 0 ? scoreObtained / totalQuestions : 0.0;

  factory QuizResolution.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return QuizResolution(
      id: doc.id,
      quizId: data['quizId'] ?? '',
      quizTitle: data['quizTitle'] ?? 'Trivia',
      category: data['category'] ?? '',
      scoreObtained: (data['scoreObtained'] as num?)?.toInt() ?? 0,
      totalQuestions: (data['totalQuestions'] as num?)?.toInt() ?? 0,
      timestamp: (data['timestamp'] as Timestamp?)?.toDate(),
    );
  }
}
