enum ReadingStatus { notStarted, inProgress, completed }

class ReadingProgress {
  final String userId;
  final String bookId;
  final Set<String> completedChapterIds;

  ReadingProgress({
    required this.userId,
    required this.bookId,
    required this.completedChapterIds,
  });

  // Método para calcular el estado y el porcentaje dinámicamente
  ReadingStatus get status {
    if (completedChapterIds.isEmpty) {
      return ReadingStatus.notStarted;
    }
    // Asumimos que si hay capítulos completados pero no todos, está en progreso.
    return ReadingStatus.inProgress;
  }
}
