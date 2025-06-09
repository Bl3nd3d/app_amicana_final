import 'package:amicana_app/core/models/user_model.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

// Estas líneas ya se encargan de conectar todo correctamente.
part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<LoginButtonPressed>((event, emit) async {
      emit(AuthLoading());
      try {
        await Future.delayed(const Duration(seconds: 2));
        if (event.email == 'admin@amicana.com' &&
            event.password == 'admin123') {
          // Esta línea ahora funciona porque el estado AuthSuccess está corregido.
          final user = User(
            id: '1',
            name: 'Admin User',
            email: 'admin@amicana.com',
            roles: ['superusuario', 'usuario_normal'],
          );
          emit(AuthSuccess(user: user));
        } else {
          emit(AuthFailure(error: 'Correo o contraseña incorrectos.'));
        }
      } catch (e) {
        emit(AuthFailure(error: 'Ocurrió un error: ${e.toString()}'));
      }
    });
  }
}
