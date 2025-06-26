import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:amicana_app/features/library/models/book_model.dart';
import 'package:amicana_app/core/models/chapter_model.dart';
import 'package:url_launcher/url_launcher.dart';

// --- CAMBIO: Convertido a StatefulWidget para manejar el 'context' de forma segura ---
class ChapterDetailScreen extends StatefulWidget {
  final Book book;
  final Chapter chapter;

  const ChapterDetailScreen({
    super.key,
    required this.book,
    required this.chapter,
  });

  @override
  State<ChapterDetailScreen> createState() => _ChapterDetailScreenState();
}

class _ChapterDetailScreenState extends State<ChapterDetailScreen> {
  // Función para abrir enlaces externos de forma segura
  Future<void> _launchURL(String? urlString) async {
    // Verificamos si la URL es nula o está vacía
    if (urlString == null || urlString.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No hay un archivo disponible.')),
      );
      return;
    }

    try {
      final Uri url = Uri.parse(urlString);
      // CORRECCIÓN: Se verifica si el widget sigue montado después del 'await'
      if (!mounted) return;

      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
        throw Exception('No se pudo lanzar la URL');
      }
    } catch (e) {
      // CORRECCIÓN: Se verifica de nuevo antes de mostrar el SnackBar
      if (!mounted) return;
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
        title: Text(widget.chapter.title), // Se accede con 'widget.chapter'
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
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
                Text(widget.book.title, // Se accede con 'widget.book'
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Colors.white, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text('Capítulo: ${widget.chapter.title}',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(color: Colors.white70)),
                const Divider(height: 32, color: Colors.white24),
                _ContentButton(
                  icon: Icons.headset,
                  label: 'Escuchar Audio',
                  onTap: () => _launchURL(widget.chapter.audioUrl),
                ),
                const SizedBox(height: 16),
                _ContentButton(
                  icon: Icons.picture_as_pdf,
                  label: 'Leer PDF',
                  onTap: () => _launchURL(widget.chapter.pdfUrl),
                ),
                const Divider(height: 32, color: Colors.white24),
                Text('Sinopsis del Capítulo',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(color: Colors.white)),
                const SizedBox(height: 8),
                Text(
                  widget.chapter.synopsis,
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

// Widget de ayuda (sin cambios)
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
        backgroundColor: onTap != null
            ? Theme.of(context).colorScheme.primary
            : Colors.grey[800],
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
