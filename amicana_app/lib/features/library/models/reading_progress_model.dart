enum ReadingStatus { notStarted, inProgress, completed }

class ReadingProgress {
  final String userId;
  final String bookId;
  final int totalChapters;
  final Set<String> completedChapterIds;

  ReadingProgress({
    required this.userId,
    required this.bookId,
    this.totalChapters =
        0, // Es importante saber el total para calcular el progreso.
    required this.completedChapterIds,
  });

  // Método para calcular el estado y el porcentaje dinámicamente
  ReadingStatus get status {
    if (completedChapterIds.isEmpty) {
      return ReadingStatus.notStarted;
    } else if (totalChapters > 0 &&
        completedChapterIds.length >= totalChapters) {
      return ReadingStatus.completed;
    }
    // Asumimos que si hay capítulos completados pero no todos, está en progreso.
    return ReadingStatus.inProgress;
  }
}
