import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:amicana_app/features/auth/bloc/auth_bloc.dart';
import 'package:amicana_app/features/profile/widgets/settings_sub_scaffold.dart';

/// Muestra los datos del usuario logueado (solo lectura por ahora).
/// Los datos salen del AuthBloc, que ya tiene el User cargado desde Firestore.
class PersonalDetailsScreen extends StatelessWidget {
  const PersonalDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthBloc>().state;
    final user = authState is AuthSuccess ? authState.user : null;

    return SettingsSubScaffold(
      title: 'Personal Details',
      body: user == null
          ? const Center(
              child: Text(
                'No se pudo cargar la información del usuario.',
                style: TextStyle(color: Colors.white70),
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                _InfoTile(
                    icon: Icons.person_outline,
                    label: 'Nombre',
                    value: user.name.isEmpty ? '—' : user.name),
                _InfoTile(
                    icon: Icons.email_outlined, label: 'Email', value: user.email),
                _InfoTile(
                    icon: Icons.badge_outlined,
                    label: 'Rol',
                    value: user.roles.isEmpty ? '—' : user.roles.join(', ')),
                _InfoTile(
                    icon: Icons.emoji_events_outlined,
                    label: 'Puntaje global',
                    value: '${user.globalScore}'),
                _InfoTile(
                    icon: Icons.menu_book_outlined,
                    label: 'Capítulos completados',
                    value: '${user.completedChapterIds.length}'),
                _InfoTile(
                    icon: Icons.quiz_outlined,
                    label: 'Trivias completadas',
                    value: '${user.completedQuizzes.length}'),
              ],
            ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoTile({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white70),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(color: Colors.white54, fontSize: 12)),
                const SizedBox(height: 2),
                Text(value,
                    style:
                        const TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
