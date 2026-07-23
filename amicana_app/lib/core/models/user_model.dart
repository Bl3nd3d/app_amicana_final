import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String id;
  final String name;
  final String email;
  final List<String> roles;
  final List<String> completedChapterIds;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.roles,
    this.completedChapterIds = const [],
  });

  factory User.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return User(
      id: doc.id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      roles: List<String>.from(data['roles'] ?? []),
      completedChapterIds: List<String>.from(data['completedChapterIds'] ?? []),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'email': email,
      'roles': roles,
      'completedChapterIds': completedChapterIds,
    };
  }

  User copyWith({
    String? id,
    String? name,
    String? email,
    List<String>? roles,
    List<String>? completedChapterIds,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      roles: roles ?? this.roles,
      completedChapterIds: completedChapterIds ?? this.completedChapterIds,
    );
  }
}
