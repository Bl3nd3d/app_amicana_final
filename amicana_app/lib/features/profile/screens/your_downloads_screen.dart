import 'package:flutter/material.dart';
import 'package:amicana_app/features/profile/widgets/settings_sub_scaffold.dart';

/// El proyecto todavía no tiene un mecanismo real de descarga de contenido
/// (ni modelo de datos para eso), así que esta pantalla muestra el estado
/// vacío correcto en vez de datos inventados.
class YourDownloadsScreen extends StatelessWidget {
  const YourDownloadsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingsSubScaffold(
      title: 'Your Downloads',
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.download_done_outlined,
                  size: 64, color: Colors.white.withValues(alpha: 0.4)),
              const SizedBox(height: 16),
              const Text(
                'Todavía no tenés descargas',
                style:
                    TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Text(
                'Los libros y capítulos que descargues para ver sin conexión van a aparecer acá.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white.withValues(alpha: 0.6)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
