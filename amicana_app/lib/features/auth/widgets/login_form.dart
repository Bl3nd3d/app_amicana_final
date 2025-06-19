import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:amicana_app/features/auth/bloc/auth_bloc.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Ya no necesitamos el método _onLoginPressed separado

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(24.0), // Aumentamos el padding interno
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Correo Electrónico',
                prefixIcon: Icon(Icons.email_outlined),
              ),
              keyboardType: TextInputType.emailAddress,
              validator: (v) =>
                  v!.isEmpty || !v.contains('@') ? 'Correo inválido' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Contraseña',
                prefixIcon: Icon(Icons.lock_outline),
              ),
              obscureText: true,
              validator: (v) => v!.isEmpty ? 'Ingresa tu contraseña' : null,
            ),
            const SizedBox(height: 24),
            BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                if (state is AuthLoading) {
                  return const CircularProgressIndicator();
                }
                return ElevatedButton(
                  // --- CORRECCIÓN PRINCIPAL AQUÍ ---
                  // La lógica ahora está directamente en el onPressed,
                  // usando el 'context' que nos da el BlocBuilder.
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Este 'context' SÍ puede ver el Provider.
                      context.read<AuthBloc>().add(
                            LoginButtonPressed(
                              email: _emailController.text,
                              password: _passwordController.text,
                            ),
                          );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12))),
                  child: const Text('Ingresar'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
