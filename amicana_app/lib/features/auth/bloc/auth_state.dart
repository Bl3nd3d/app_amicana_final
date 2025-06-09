part of 'auth_bloc.dart';

// Importaciones necesarias para este archivo de estado.
// El resto del código no cambia y ahora debería funcionar sin errores.
@immutable
abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final User user;
  AuthSuccess({required this.user});
}

class AuthFailure extends AuthState {
  final String error;
  AuthFailure({required this.error});
}
