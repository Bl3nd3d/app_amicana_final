import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:amicana_app/features/auth/bloc/auth_bloc.dart';

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
      // El BlocListener reacciona al cambio de estado después de presionar "Cerrar Sesión"
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
                child: Image.asset('assets/images/fondo_app.png',
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
                // Grupo con el botón de Cerrar Sesión
                _buildSettingsGroup([
                  _buildSettingsTile(context,
                      icon: Icons.help_outline,
                      title: 'Help Center',
                      onTap: () {}),
                  ListTile(
                    leading: const Icon(Icons.logout, color: Colors.redAccent),
                    title: const Text('Cerrar Sesión',
                        style: TextStyle(color: Colors.redAccent)),
                    onTap: () {
                      // Este context.read ahora funciona porque el Provider está en main.dart
                      context.read<AuthBloc>().add(LogoutButtonPressed());
                    },
                  ),
                ]),
              ],
            ),
          ],
        ),
      ),
    );
  }

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
