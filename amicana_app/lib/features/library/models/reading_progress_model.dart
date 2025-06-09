enum ReadingStatus { notStarted, inProgress, completed }

class ReadingProgress {
  final String userId;
  final String bookId;
  final ReadingStatus status;
  final double percentage; // Un valor de 0.0 a 100.0

  ReadingProgress({
    required this.userId,
    required this.bookId,
    this.status = ReadingStatus.notStarted,
    this.percentage = 0.0,
  });
}
