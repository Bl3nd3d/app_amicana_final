import 'package:equatable/equatable.dart';

class UserStatsModel extends Equatable {
  final int globalScore;
  final Map<String, int> categoryScores;
  final List<String> completedActivities;

  const UserStatsModel({
    this.globalScore = 0,
    this.categoryScores = const {},
    this.completedActivities = const [],
  });

  factory UserStatsModel.fromFirestore(Map<String, dynamic> doc) {
    return UserStatsModel(
      globalScore: doc['globalScore'] as int? ?? 0,
      categoryScores: Map<String, int>.from(doc['categoryScores'] ?? {}),
      completedActivities: List<String>.from(doc['completedActivities'] ?? []),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'globalScore': globalScore,
      'categoryScores': categoryScores,
      'completedActivities': completedActivities,
    };
  }

  @override
  List<Object?> get props => [globalScore, categoryScores, completedActivities];
}
