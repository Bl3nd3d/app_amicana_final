import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:amicana_app/features/auth/bloc/auth_bloc.dart';
import 'package:amicana_app/features/auth/widgets/register_form.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // La lógica del BLoC ahora envuelve toda la pantalla
      body: BlocProvider(
        create: (context) => AuthBloc(),
        child: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is RegistrationSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('¡Registro exitoso! Por favor, inicia sesión.'),
                  backgroundColor: Colors.green,
                ),
              );
              context.go('/login');
            } else if (state is AuthFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.error),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          // Stack para el fondo y el contenido
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Capa 1: Imagen de Fondo
              Image.asset(
                'assets/images/fondo_app.png',
                fit: BoxFit.cover,
              ),
              // Capa 2: Capa oscura para legibilidad
              Container(
                color: Colors.black.withOpacity(0.5),
              ),
              // Capa 3: Contenido principal
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Botón para cerrar (volver atrás)
                      Align(
                        alignment: Alignment.topLeft,
                        child: IconButton(
                          icon: const Icon(Icons.close,
                              color: Colors.white, size: 30),
                          onPressed: () => context.pop(),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Título
                      const Text(
                        'Sign up to A.M.I.C.A.N.A.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'serif',
                        ),
                      ),
                      const SizedBox(height: 40),
                      // Formulario de Registro
                      const RegisterForm(),
                      const Spacer(),
                      // Enlace para Iniciar Sesión
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Already have an account? ",
                            style: TextStyle(color: Colors.white70),
                          ),
                          TextButton(
                            onPressed: () => context.go('/login'),
                            child: const Text(
                              'Sign In',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                                decorationColor: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
