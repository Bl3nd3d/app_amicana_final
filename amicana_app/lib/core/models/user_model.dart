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
