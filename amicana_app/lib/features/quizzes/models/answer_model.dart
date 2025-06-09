class AnswerSubmission {
  final String userId;
  final String quizId;
  final DateTime submittedAt;
  final int score;
  // Mapa para guardar las respuestas: 'ID de la pregunta' -> 'índice de la opción seleccionada'
  final Map<String, int> responses;

  AnswerSubmission({
    required this.userId,
    required this.quizId,
    required this.submittedAt,
    required this.score,
    required this.responses,
  });
}
