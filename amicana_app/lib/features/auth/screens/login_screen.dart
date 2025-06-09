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
      appBar: AppBar(
        title: const Text('Bienvenido a A.M.I.C.A.N.A.'),
      ),
      body: BlocProvider(
        create: (context) => AuthBloc(),
        child: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) async {
            // <-- Marcamos el listener como 'async'
            if (state is AuthSuccess) {
              final user = state.user;
              final authService = AuthService(); // Instanciamos el servicio

              // --- AQUÍ ESTÁ LA NUEVA LÓGICA ---
              if (user.roles.length == 1) {
                // Si el usuario solo tiene un rol, lo guardamos y vamos a la biblioteca.
                final singleRole = user.roles.first;
                await authService.saveSelectedRole(singleRole);
                context.go('/library');
              } else {
                // Si tiene más de un rol, vamos a la pantalla de selección.
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
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.school, size: 80, color: Color(0xFF0D47A1)),
                  const SizedBox(height: 8),
                  Text(
                    'Inicio de Sesión',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 24),
                  const LoginForm(),
                  const SizedBox(height: 24),
                  TextButton(
                    onPressed: () {
                      // Usa push para poner la pantalla de registro encima de la de login
                      context.push('/register');
                    },
                    child: const Text('¿No tienes una cuenta? Regístrate'),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
