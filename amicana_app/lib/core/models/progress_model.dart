class Progress {
  final int totalCompletedChapters;
  final List<String> completedChapterIds;
  final int totalCompletedQuizzes;
  final List<String> completedQuizIds;
  final int globalScore;
  final Map<String, int> categoryStats;

  Progress({
    this.totalCompletedChapters = 0,
    this.completedChapterIds = const [],
    this.totalCompletedQuizzes = 0,
    this.completedQuizIds = const [],
    this.globalScore = 0,
    this.categoryStats = const {},
  });

  factory Progress.fromFirestore(Map<String, dynamic> data) {
    // OJO: los nombres de campo tienen que coincidir con lo que graba
    // ProgressService/AuthService en el documento del usuario:
    // 'completedChapterIds', 'completedQuizzes', 'categoryStats', 'globalScore'.
    final completedChapters =
        List<String>.from(data['completedChapterIds'] ?? []);
    final completedQuizzes = List<String>.from(data['completedQuizzes'] ?? []);

    final statsData = data['categoryStats'] as Map<String, dynamic>? ?? {};
    final categoryStats =
        statsData.map((key, value) => MapEntry(key, (value as num).toInt()));

    return Progress(
      totalCompletedChapters: completedChapters.length,
      completedChapterIds: completedChapters,
      totalCompletedQuizzes: completedQuizzes.length,
      completedQuizIds: completedQuizzes,
      globalScore: (data['globalScore'] as num?)?.toInt() ?? 0,
      categoryStats: categoryStats,
    );
  }
}
