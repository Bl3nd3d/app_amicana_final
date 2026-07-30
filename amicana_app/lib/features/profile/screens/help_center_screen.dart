import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:amicana_app/features/profile/widgets/settings_sub_scaffold.dart';

class HelpCenterScreen extends StatelessWidget {
  const HelpCenterScreen({super.key});

  static const List<Map<String, String>> _faqs = [
    {
      'question': '¿Cómo marco un capítulo como completado?',
      'answer':
          'Entrá al libro, abrí el capítulo y activá el check de "Completado" en el detalle del capítulo.',
    },
    {
      'question': '¿Dónde veo mi progreso?',
      'answer': 'En la pestaña Profile encontrás tu progreso general y por libro.',
    },
    {
      'question': '¿Cómo cambio mi contraseña?',
      'answer':
          'Por ahora esa opción no está disponible desde la app; escribinos a soporte y te ayudamos.',
    },
  ];

  Future<void> _contactSupport(BuildContext context) async {
    final uri = Uri(
      scheme: 'mailto',
      path: 'soporte@amicana-app.com',
      query: 'subject=Ayuda con A.M.I.C.A.N.A. App',
    );
    try {
      if (!await launchUrl(uri)) {
        throw Exception('No se pudo abrir el cliente de correo');
      }
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No se pudo abrir el correo: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SettingsSubScaffold(
      title: 'Help Center',
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const Text('Preguntas frecuentes',
              style: TextStyle(color: Colors.white54, fontSize: 12)),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Theme(
              data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: Column(
                children: _faqs
                    .map(
                      (faq) => ExpansionTile(
                        iconColor: Colors.white70,
                        collapsedIconColor: Colors.white70,
                        title: Text(
                          faq['question']!,
                          style:
                              const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                        ),
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(faq['answer']!,
                                  style: const TextStyle(color: Colors.white70)),
                            ),
                          ),
                        ],
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              icon: const Icon(Icons.mail_outline),
              label: const Text('Contactar soporte'),
              onPressed: () => _contactSupport(context),
            ),
          ),
        ],
      ),
    );
  }
}
