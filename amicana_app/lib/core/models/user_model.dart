// Este es el hogar definitivo y central para el modelo User.
class User {
  final String id;
  final String name;
  final String email;
  final List<String> roles;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.roles,
  });
}
