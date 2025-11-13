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
  bool _obscureText = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

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
    // Definimos un estilo para los campos de texto
    final inputDecorationTheme = InputDecorationTheme(
      // Estilo del texto de ayuda (hint)
      hintStyle: TextStyle(color: Colors.grey[400]),
      // Color de los iconos
      prefixIconColor: Colors.grey[400],
      // Línea inferior del campo de texto
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.grey[400]!),
      ),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.white),
      ),
    );

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Campo de Nombre
          TextFormField(
            controller: _nameController,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Your name',
              prefixIcon: const Icon(Icons.person_outline),
              border: inputDecorationTheme.enabledBorder,
              focusedBorder: inputDecorationTheme.focusedBorder,
              hintStyle: inputDecorationTheme.hintStyle,
              prefixIconColor: inputDecorationTheme.prefixIconColor,
            ),
            validator: (v) => v!.isEmpty ? 'El nombre es requerido' : null,
          ),
          const SizedBox(height: 20),
          // Campo de Email
          TextFormField(
            controller: _emailController,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Your email',
              prefixIcon: const Icon(Icons.mail_outline),
              border: inputDecorationTheme.enabledBorder,
              focusedBorder: inputDecorationTheme.focusedBorder,
              hintStyle: inputDecorationTheme.hintStyle,
              prefixIconColor: inputDecorationTheme.prefixIconColor,
            ),
            keyboardType: TextInputType.emailAddress,
            validator: (v) {
              if (v == null || v.isEmpty) return 'El correo es requerido';
              final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
              return !emailRegex.hasMatch(v) ? 'Correo inválido' : null;
            },
          ),
          const SizedBox(height: 20),
          // Campo de Contraseña
          TextFormField(
            controller: _passwordController,
            obscureText: _obscureText,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Min. 8 characters',
              prefixIcon: const Icon(Icons.lock_outline),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureText
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: Colors.grey[400],
                ),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              ),
              border: inputDecorationTheme.enabledBorder,
              focusedBorder: inputDecorationTheme.focusedBorder,
              hintStyle: inputDecorationTheme.hintStyle,
              prefixIconColor: inputDecorationTheme.prefixIconColor,
            ),
            validator: (v) => v!.length < 6
                ? 'La contraseña debe tener al menos 6 caracteres'
                : null,
          ),
          const SizedBox(height: 40),
          // Botón de Registro
          BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              if (state is AuthLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              return ElevatedButton(
                onPressed: _onRegisterPressed,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.blue[400],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'Sign Up',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
