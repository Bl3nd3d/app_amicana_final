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
      body: BlocProvider(
        create: (context) => AuthBloc(),
        child: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is RegistrationSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content:
                        Text('¡Registro exitoso! Por favor, inicia sesión.'),
                    backgroundColor: Colors.green),
              );
              context.go('/login');
            } else if (state is AuthFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text(state.error), backgroundColor: Colors.red),
              );
            }
          },
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset('assets/images/fondo_app.webp', fit: BoxFit.cover),
              Container(color: Colors.black.withOpacity(0.5)),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: IconButton(
                          icon: const Icon(Icons.close,
                              color: Colors.white, size: 30),
                          onPressed: () => context.pop(),
                        ),
                      ),
                      const SizedBox(height: 20),
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

                      // --- CAMBIO PRINCIPAL AQUÍ ---
                      // Usamos Expanded para que el formulario ocupe el espacio central
                      // y empuje el enlace de "Sign In" hacia abajo.
                      // También usamos SingleChildScrollView para evitar que el teclado
                      // cause un desbordamiento de píxeles.
                      Expanded(
                        child: SingleChildScrollView(
                          child: const RegisterForm(),
                        ),
                      ),
                      // El Spacer() que causaba el crash ha sido eliminado.
                      // --- FIN DEL CAMBIO ---

                      // Enlace para Iniciar Sesión
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        child: Row(
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
                      ),
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
