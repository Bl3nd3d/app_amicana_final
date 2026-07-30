import 'package:cloud_firestore/cloud_firestore.dart';

class Progress {
  final int totalCompletedChapters;
  final Map<String, int> categoryStats;
  final int globalScore;
  final int completedQuizzesCount;
  final DateTime? creationDate;

  Progress({
    this.totalCompletedChapters = 0,
    this.categoryStats = const {},
    this.globalScore = 0,
    this.completedQuizzesCount = 0,
    this.creationDate,
  });

  factory Progress.fromFirestore(Map<String, dynamic> data) {
    final completedChapters = data['completedChapterIds'] as List<dynamic>? ?? [];
    final completedQuizzes = data['completedQuizzes'] as List<dynamic>? ?? [];
    final statsData = data['stats'] as Map<String, dynamic>? ?? {};
    final categoryStats = statsData.map((key, value) => MapEntry(key, value as int));
    
    DateTime? creation;
    if (data['createdAt'] is Timestamp) {
      creation = (data['createdAt'] as Timestamp).toDate();
    }

    return Progress(
      totalCompletedChapters: completedChapters.length,
      categoryStats: categoryStats,
      globalScore: data['globalScore'] as int? ?? 0,
      completedQuizzesCount: completedQuizzes.length,
      creationDate: creation,
    );
  }
}
