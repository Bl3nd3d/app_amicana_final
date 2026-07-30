import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String id;
  final String name;
  final String email;
  final List<String> roles;
  final int globalScore;
  final Map<String, int> categoryStats;
  final List<String> completedQuizzes;
  final List<String> completedChapterIds;
  final List<String> savedBookIds;
  final List<String> savedChapterIds;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.roles,
    this.globalScore = 0,
    this.categoryStats = const {},
    this.completedQuizzes = const [],
    this.completedChapterIds = const [],
    this.savedBookIds = const [],
    this.savedChapterIds = const [],
  });

  factory User.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return User(
      id: doc.id,
      name: data['displayName'] ?? data['name'] ?? '',
      email: data['email'] ?? '',
      roles: List<String>.from(data['roles'] ?? ['usuario']),
      globalScore: data['globalScore'] ?? 0,
      categoryStats: Map<String, int>.from(data['categoryStats'] ?? {}),
      completedQuizzes: List<String>.from(data['completedQuizzes'] ?? []),
      completedChapterIds: List<String>.from(data['completedChapterIds'] ?? []),
      savedBookIds: List<String>.from(data['savedBookIds'] ?? []),
      savedChapterIds: List<String>.from(data['savedChapterIds'] ?? []),
    );
  }

  User copyWith({
    String? id,
    String? name,
    String? email,
    List<String>? roles,
    int? globalScore,
    Map<String, int>? categoryStats,
    List<String>? completedQuizzes,
    List<String>? completedChapterIds,
    List<String>? savedBookIds,
    List<String>? savedChapterIds,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      roles: roles ?? this.roles,
      globalScore: globalScore ?? this.globalScore,
      categoryStats: categoryStats ?? this.categoryStats,
      completedQuizzes: completedQuizzes ?? this.completedQuizzes,
      completedChapterIds: completedChapterIds ?? this.completedChapterIds,
      savedBookIds: savedBookIds ?? this.savedBookIds,
      savedChapterIds: savedChapterIds ?? this.savedChapterIds,
    );
  }
}
