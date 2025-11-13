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
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) async {
          if (state is AuthSuccess) {
            final user = state.user;
            final authService = AuthService();
            if (user.roles.length == 1) {
              final singleRole = user.roles.first;
              await authService.saveSelectedRole(singleRole);
              if (context.mounted) {
                context.go('/library');
              }
            } else {
              if (context.mounted) {
                context.go('/select-role', extra: user);
              }
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
            Image.asset('assets/images/fondo_app.webp', fit: BoxFit.cover),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withValues(alpha: 0.4),
                    Colors.black.withValues(alpha: 0.7)
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/images/logo_app.jpg', height: 150),
                      const SizedBox(height: 8),
                      Text(
                        'Inicio de Sesión',
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      const SizedBox(height: 24),
                      Card(
                        elevation: 8,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        color: Colors.white.withValues(alpha: 0.95),
                        child: const LoginForm(),
                      ),
                      const SizedBox(height: 24),
                      const Text('O inicia sesión con',
                          style: TextStyle(color: Colors.white70)),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        icon: Image.asset('assets/images/google_logo.webp',
                            height: 24),
                        label: const Text('Sign in with Google'),
                        onPressed: () {
                          // Este context.read ahora funciona porque el Provider está en main.dart
                          context
                              .read<AuthBloc>()
                              .add(GoogleSignInButtonPressed());
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          minimumSize: const Size(220, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
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
    );
  }
}
