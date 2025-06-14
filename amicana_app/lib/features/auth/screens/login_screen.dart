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
    // Usamos un Scaffold sin appBar para un look de pantalla completa
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
          // Usamos un Stack para poner la imagen de fondo y el contenido encima
          child: Stack(
            fit: StackFit.expand,
            children: [
              // --- DETALLE 1: IMAGEN DE FONDO ---
              Image.asset(
                'assets/images/welcome_background.png', // Reutilizamos la misma imagen de fondo
                fit: BoxFit.cover,
              ),
              // --- DETALLE 2: CAPA OSCURA PARA LEGIBILIDAD ---
              // Un degradado oscuro hace que el texto blanco resalte más
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
              // Capa con el contenido principal
              SafeArea(
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // --- DETALLE 3: ICONO Y TEXTOS ADAPTADOS ---
                        const Icon(Icons.school, size: 80, color: Colors.white),
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

                        // --- DETALLE 4: TARJETA PARA EL FORMULARIO ---
                        // Envolvemos el LoginForm en una Card para darle un fondo
                        // y que los campos de texto sean fáciles de leer.
                        Card(
                          margin: const EdgeInsets.symmetric(horizontal: 24),
                          elevation: 8,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          // Hacemos la tarjeta un poco transparente
                          color: Colors.white.withOpacity(0.9),
                          child: const LoginForm(),
                        ),
                        const SizedBox(height: 24),

                        // --- DETALLE 5: BOTÓN DE TEXTO ADAPTADO ---
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
