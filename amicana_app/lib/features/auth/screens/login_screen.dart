import 'package:amicana_app/core/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/auth_bloc.dart';
import '../widgets/login_form.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => AuthBloc(),
        child: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) async {
            if (state is AuthSuccess) {
              final user = state.user;
              final authService = AuthService();
              if (user.roles.length == 1) {
                final singleRole = user.roles.first;
                await authService.saveSelectedRole(singleRole);
                context.go('/library');
              } else {
                context.go('/select-role', extra: user);
              }
            } else if (state is AuthFailure) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: Text(state.error),
                    backgroundColor: Colors.red,
                  ),
                );
            }
          },
          child: Stack(
            fit: StackFit.expand,
            children: [
              // --- CAMBIO 1: Tu imagen de fondo ---
              Image.asset(
                'assets/images/fondo_app.webp', // Usamos el nombre de tu archivo
                fit: BoxFit.cover,
              ),

              // Capa oscura para legibilidad
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withOpacity(0.4),
                      Colors.black.withOpacity(0.7)
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),

              // Contenido principal
              SafeArea(
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // --- CAMBIO 2: Tu logo ---
                        Image.asset(
                          'assets/images/logo_app.jpg', // Usamos el nombre de tu logo
                          height: 150, // Ajusta la altura si es necesario
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Inicio de Sesión',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 24),

                        Card(
                          margin: const EdgeInsets.symmetric(horizontal: 24),
                          elevation: 8,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          color: Colors.white.withOpacity(0.9),
                          child: const LoginForm(),
                        ),
                        const SizedBox(height: 24),

                        TextButton(
                          onPressed: () {
                            context.push('/register');
                          },
                          child: const Text(
                            '¿No tienes una cuenta? Regístrate',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.underline,
                              decorationColor: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
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
