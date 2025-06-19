import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:amicana_app/core/models/user_model.dart'; // <-- IMPORT AQUÍ
import 'package:amicana_app/core/services/auth_service.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService _authService = AuthService(); // <-- Instancia del servicio

  AuthBloc() : super(AuthInitial()) {
    // --- MANEJADOR DE LOGIN (ACTUALIZADO) ---
    on<LoginButtonPressed>((event, emit) async {
      emit(AuthLoading());
      try {
        final user = await _authService.login(
            email: event.email, password: event.password);
        emit(AuthSuccess(user: user));
      } catch (e) {
        emit(AuthFailure(error: e.toString().replaceFirst('Exception: ', '')));
      }
    });

    // --- MANEJADOR DE REGISTRO (NUEVO) ---
    on<RegisterButtonPressed>((event, emit) async {
      emit(AuthLoading());
      try {
        await _authService.register(
            name: event.name, email: event.email, password: event.password);
        emit(RegistrationSuccess());
      } catch (e) {
        emit(AuthFailure(error: e.toString().replaceFirst('Exception: ', '')));
      }
    });

    on<GoogleSignInButtonPressed>((event, emit) async {
      emit(AuthLoading());
      try {
        final user = await _authService.signInWithGoogle();
        emit(AuthSuccess(user: user));
      } catch (e) {
        emit(AuthFailure(error: e.toString().replaceFirst('Exception: ', '')));
      }
    });

    on<LogoutButtonPressed>((event, emit) async {
      try {
        await _authService.logout();
        // Emitimos el estado inicial para indicar que ya no hay un usuario logueado.
        emit(AuthInitial());
      } catch (e) {
        // Opcional: manejar cualquier error que pudiera ocurrir al desloguear
        print('Error al cerrar sesión: $e');
      }
    });
  }
}
