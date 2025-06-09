import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:amicana_app/features/auth/bloc/auth_bloc.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _onRegisterPressed() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(RegisterButtonPressed(
            name: _nameController.text,
            email: _emailController.text,
            password: _passwordController.text,
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(
                labelText: 'Nombre Completo', border: OutlineInputBorder()),
            validator: (v) => v!.isEmpty ? 'El nombre es requerido' : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(
                labelText: 'Correo Electrónico', border: OutlineInputBorder()),
            keyboardType: TextInputType.emailAddress,
            validator: (v) =>
                v!.isEmpty || !v.contains('@') ? 'Correo inválido' : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _passwordController,
            decoration: const InputDecoration(
                labelText: 'Contraseña', border: OutlineInputBorder()),
            obscureText: true,
            validator: (v) => v!.length < 6
                ? 'La contraseña debe tener al menos 6 caracteres'
                : null,
          ),
          const SizedBox(height: 24),
          BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              if (state is AuthLoading) {
                return const CircularProgressIndicator();
              }
              return ElevatedButton(
                onPressed: _onRegisterPressed,
                child: const Text('Registrarme'),
              );
            },
          ),
        ],
      ),
    );
  }
}
