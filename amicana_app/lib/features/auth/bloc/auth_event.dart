part of 'auth_bloc.dart';

// Clase base para todos los eventos de autenticación
@immutable
abstract class AuthEvent {}

// Evento que se dispara cuando el usuario presiona el botón de login
class LoginButtonPressed extends AuthEvent {
  final String email;
  final String password;

  LoginButtonPressed({required this.email, required this.password});
}

class RegisterButtonPressed extends AuthEvent {
  final String name;
  final String email;
  final String password;

  RegisterButtonPressed(
      {required this.name, required this.email, required this.password});
}

class GoogleSignInButtonPressed extends AuthEvent {}

class LogoutButtonPressed extends AuthEvent {}
