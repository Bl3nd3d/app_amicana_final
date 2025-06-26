import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:amicana_app/features/auth/bloc/auth_bloc.dart';
import 'package:amicana_app/features/library/services/library_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A183C),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: const Text('Settings',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthInitial) {
            // Si el estado vuelve a ser el inicial (después del logout),
            // navegamos de vuelta a la pantalla de login.
            context.go('/login');
          }
        },
        child: Stack(
          children: [
            Positioned.fill(
              child: Opacity(
                opacity: 0.3,
                child: Image.asset('assets/images/fondo_app.webp',
                    fit: BoxFit.cover),
              ),
            ),
            ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                _buildSettingsGroup([
                  _buildSettingsTile(context,
                      icon: Icons.person_outline,
                      title: 'Personal Details',
                      onTap: () {}),
                  _buildSettingsTile(context,
                      icon: Icons.videocam_outlined,
                      title: 'Preference Video',
                      onTap: () {}),
                  _buildSettingsTile(context,
                      icon: Icons.download_outlined,
                      title: 'Your Download',
                      onTap: () {}),
                  ListTile(
                    leading: const Icon(Icons.dark_mode_outlined,
                        color: Colors.white70),
                    title: const Text('Dark Mode',
                        style: TextStyle(color: Colors.white)),
                    trailing: Switch(
                      value: _isDarkMode,
                      onChanged: (newValue) {
                        setState(() {
                          _isDarkMode = newValue;
                        });
                      },
                      activeColor: Colors.blue,
                    ),
                  ),
                ]),
                const SizedBox(height: 20),
                _buildSettingsGroup([
                  _buildSettingsTile(context,
                      icon: Icons.card_giftcard_outlined,
                      title: 'Referral Code',
                      onTap: () {}),
                  _buildSettingsTile(context,
                      icon: Icons.calendar_today_outlined,
                      title: 'Learning Reminder',
                      onTap: () {}),
                  _buildSettingsTile(context,
                      icon: Icons.confirmation_number_outlined,
                      title: 'Voucher Code',
                      onTap: () {}),
                ]),
                const SizedBox(height: 20),
                _buildSettingsGroup([
                  _buildSettingsTile(context,
                      icon: Icons.help_outline,
                      title: 'Help Center',
                      onTap: () {}),
                  ListTile(
                    leading: const Icon(Icons.logout, color: Colors.redAccent),
                    title: const Text('Cerrar Sesión',
                        style: TextStyle(
                            color: Colors.redAccent,
                            fontWeight: FontWeight.w500)),
                    onTap: () {
                      context.read<AuthBloc>().add(LogoutButtonPressed());
                    },
                  ),
                ]),

                // Botón de Desarrollador (Solo visible en modo debug)
                if (kDebugMode)
                  Padding(
                    padding: const EdgeInsets.only(top: 30.0),
                    child: Column(
                      children: [
                        const Text('Opciones de Desarrollador',
                            style: TextStyle(color: Colors.yellowAccent)),
                        const SizedBox(height: 10),
                        ElevatedButton.icon(
                          icon: const Icon(Icons.biotech_outlined),
                          label:
                              const Text('Cargar Datos de Prueba a Firestore'),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange[800]),
                          onPressed: () async {
                            // Muestra un diálogo de confirmación para seguridad
                            showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: const Text('Confirmar Acción'),
                                content: const Text(
                                    'Esto borrará los libros existentes y cargará los de prueba. ¿Estás seguro?'),
                                actions: [
                                  TextButton(
                                    child: const Text('Cancelar'),
                                    onPressed: () => Navigator.of(ctx).pop(),
                                  ),
                                  FilledButton(
                                    child: const Text('Sí, Cargar Datos'),
                                    onPressed: () async {
                                      Navigator.of(ctx).pop();
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            content:
                                                Text('Iniciando carga...')),
                                      );
                                      try {
                                        await LibraryService().seedDatabase();
                                        if (mounted) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                                content: Text(
                                                    '¡Datos de prueba cargados a Firestore!'),
                                                backgroundColor: Colors.green),
                                          );
                                        }
                                      } catch (e) {
                                        if (mounted) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                                content:
                                                    Text('Error al cargar: $e'),
                                                backgroundColor: Colors.red),
                                          );
                                        }
                                      }
                                    },
                                  )
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Widget de ayuda para crear los grupos de opciones
  Widget _buildSettingsGroup(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: List.generate(children.length * 2 - 1, (index) {
          if (index.isEven) {
            return children[index ~/ 2];
          }
          return Divider(
              height: 1, color: Colors.white.withOpacity(0.15), indent: 56);
        }),
      ),
    );
  }

  // Widget de ayuda para crear cada fila de opción
  Widget _buildSettingsTile(BuildContext context,
      {required IconData icon,
      required String title,
      required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: Colors.white70),
      title: Text(title,
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.w500)),
      trailing: const Icon(Icons.chevron_right, color: Colors.white70),
      onTap: onTap,
    );
  }
}
