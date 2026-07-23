class Progress {
  final int totalCompletedChapters;
  final Map<String, int> categoryStats;

  Progress({
    this.totalCompletedChapters = 0,
    this.categoryStats = const {},
  });

  factory Progress.fromFirestore(Map<String, dynamic> data) {
    // Safely extract completedChapters and calculate the total
    final completedChapters = data['completedChapters'] as List<dynamic>? ?? [];
    
    // Safely extract stats, ensuring values are integers
    final statsData = data['stats'] as Map<String, dynamic>? ?? {};
    final categoryStats = statsData.map((key, value) => MapEntry(key, value as int));

    return Progress(
      totalCompletedChapters: completedChapters.length,
      categoryStats: categoryStats,
    );
  }
}
