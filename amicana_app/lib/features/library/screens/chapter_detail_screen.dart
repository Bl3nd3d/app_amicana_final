import 'package:flutter/material.dart';
import 'package:amicana_app/features/library/models/book_model.dart';
import 'package:amicana_app/core/models/chapter_model.dart';
import 'package:url_launcher/url_launcher.dart'; // <-- 1. IMPORTACIÓN AÑADIDA

class ChapterDetailScreen extends StatelessWidget {
  final Book book;
  final Chapter chapter;

  const ChapterDetailScreen({
    super.key,
    required this.book,
    required this.chapter,
  });

  // --- 2. FUNCIÓN DE AYUDA AÑADIDA ---
  // Esta función intenta abrir la URL que le pasemos.
  Future<void> _launchURL(BuildContext context, String? urlString) async {
    // Primero, verificamos si la URL existe y no está vacía
    if (urlString == null || urlString.isEmpty) {
      // Si no hay URL, mostramos un mensaje al usuario
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('No hay un archivo disponible para este capítulo.')),
      );
      return;
    }

    // Si hay URL, intentamos abrirla
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      // Si no se puede abrir, mostramos un error
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
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.3,
              child:
                  Image.asset('assets/images/fondo_app.png', fit: BoxFit.cover),
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

                // --- 3. BOTONES CON LÓGICA REAL ---
                _ContentButton(
                  icon: Icons.headset,
                  label: 'Escuchar Audio',
                  // El botón ahora llama a nuestra función _launchURL
                  onTap: () => _launchURL(context, chapter.audioUrl),
                ),
                const SizedBox(height: 16),
                _ContentButton(
                  icon: Icons.picture_as_pdf,
                  label: 'Leer PDF',
                  onTap: () => _launchURL(context, chapter.pdfUrl),
                ),
                const Divider(height: 32, color: Colors.white24),

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

// Widget de ayuda para los botones
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
        // Si onTap es nulo (no hay URL), el botón se verá deshabilitado
        backgroundColor:
            onTap != null ? Theme.of(context).primaryColor : Colors.grey[800],
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
