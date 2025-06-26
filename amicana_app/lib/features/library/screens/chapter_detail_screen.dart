import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:amicana_app/features/library/models/book_model.dart';
import 'package:amicana_app/core/models/chapter_model.dart';
import 'package:url_launcher/url_launcher.dart';

class ChapterDetailScreen extends StatelessWidget {
  final Book book;
  final Chapter chapter;

  const ChapterDetailScreen({
    super.key,
    required this.book,
    required this.chapter,
  });

  // Función de ayuda para abrir enlaces externos de forma segura
  Future<void> _launchURL(BuildContext context, String? urlString) async {
    // 1. Verifica si la URL es válida
    if (urlString == null || urlString.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('No hay un archivo disponible para este capítulo.')),
      );
      return;
    }

    // 2. Intenta convertir el texto a una URI y lanzarla
    try {
      final Uri url = Uri.parse(urlString);
      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
        throw Exception('No se pudo lanzar la URL');
      }
    } catch (e) {
      print('Error al lanzar URL: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No se pudo abrir el enlace: $urlString')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A183C),
      appBar: AppBar(
        title: Text(chapter.title),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () =>
              context.pop(), // Vuelve a la pantalla de detalle del libro
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.3,
              child: Image.asset('assets/images/fondo_app.webp',
                  fit: BoxFit.cover),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                Text(book.title,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Colors.white, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text('Capítulo: ${chapter.title}',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(color: Colors.white70)),
                const Divider(height: 32, color: Colors.white24),

                // Botones para el contenido
                _ContentButton(
                  icon: Icons.headset,
                  label: 'Escuchar Audio',
                  onTap: () => _launchURL(context, chapter.audioUrl),
                ),
                const SizedBox(height: 16),
                _ContentButton(
                  icon: Icons.picture_as_pdf,
                  label: 'Leer PDF',
                  onTap: () => _launchURL(context, chapter.pdfUrl),
                ),
                const Divider(height: 32, color: Colors.white24),

                // Sinopsis
                Text('Sinopsis del Capítulo',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(color: Colors.white)),
                const SizedBox(height: 8),
                Text(
                  chapter.synopsis,
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(color: Colors.white70, height: 1.5),
                  textAlign: TextAlign.justify,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Widget de ayuda reutilizable para los botones de la pantalla
class _ContentButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  const _ContentButton({required this.icon, required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: Icon(icon),
      label: Text(label),
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
