import 'package:amicana_app/core/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:amicana_app/core/models/user_model.dart';

class RoleSelectionScreen extends StatelessWidget {
  final User user;
  const RoleSelectionScreen({super.key, required this.user});

  // Marcamos el método como 'async'
  void _onRoleSelected(BuildContext context, String role) async {
    // Instanciamos nuestro servicio
    final authService = AuthService();
    // Guardamos el rol seleccionado
    await authService.saveSelectedRole(role);

    // Navegamos a la pantalla principal de la biblioteca
    if (context.mounted) {
      context.go('/library');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hola, ${user.name}'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.person, size: 60),
              const SizedBox(height: 16),
              Text(
                'Selecciona tu rol para esta sesión',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ...user.roles.map(
                (role) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => _onRoleSelected(context, role),
                      child: Text(
                        role.substring(0, 1).toUpperCase() + role.substring(1),
                      ),
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
