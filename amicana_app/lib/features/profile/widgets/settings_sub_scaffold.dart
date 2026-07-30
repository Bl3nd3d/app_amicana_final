import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Scaffold reutilizable para las subpantallas de Settings
/// (Personal Details, Preference Video, Referral Code, etc).
///
/// Mantiene el mismo estilo visual que SettingsScreen y agrega:
/// - Botón "atrás" (pop) en el AppBar, para volver a la pantalla anterior.
/// - Botón explícito de "Inicio" para volver directo a la pantalla Home (/library).
class SettingsSubScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final List<Widget>? extraActions;

  const SettingsSubScaffold({
    super.key,
    required this.title,
    required this.body,
    this.extraActions,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A183C),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          tooltip: 'Volver',
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: Text(
          title,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          ...?extraActions,
          IconButton(
            tooltip: 'Volver al inicio',
            icon: const Icon(Icons.home_outlined, color: Colors.white),
            onPressed: () => context.go('/library'),
          ),
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.3,
              child: Image.asset('assets/images/fondo_app.webp', fit: BoxFit.cover),
            ),
          ),
          SafeArea(child: body),
        ],
      ),
    );
  }
}
