import 'package:equatable/equatable.dart';

class ActivityModel extends Equatable {
  final String id;
  final String title;
  final String category;
  final int totalPoints;
  final int requiredPassingScore; // As a percentage (e.g., 80 for 80%)

  const ActivityModel({
    required this.id,
    required this.title,
    required this.category,
    required this.totalPoints,
    required this.requiredPassingScore,
  });

  factory ActivityModel.fromFirestore(Map<String, dynamic> doc) {
    return ActivityModel(
      id: doc['id'] as String,
      title: doc['title'] as String,
      category: doc['category'] as String,
      totalPoints: doc['totalPoints'] as int,
      requiredPassingScore: doc['requiredPassingScore'] as int,
    );
  }

   Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'title': title,
      'category': category,
      'totalPoints': totalPoints,
      'requiredPassingScore': requiredPassingScore,
    };
  }

  @override
  List<Object?> get props => [id, title, category, totalPoints, requiredPassingScore];
}
