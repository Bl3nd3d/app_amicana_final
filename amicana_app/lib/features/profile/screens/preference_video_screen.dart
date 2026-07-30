import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:amicana_app/features/profile/widgets/settings_sub_scaffold.dart';

class PreferenceVideoScreen extends StatefulWidget {
  const PreferenceVideoScreen({super.key});

  @override
  State<PreferenceVideoScreen> createState() => _PreferenceVideoScreenState();
}

class _PreferenceVideoScreenState extends State<PreferenceVideoScreen> {
  static const _keyAutoplay = 'pref_video_autoplay';
  static const _keyWifiOnly = 'pref_video_wifi_only';
  static const _keyQuality = 'pref_video_quality';
  static const _qualities = ['Auto', 'Alta', 'Media', 'Baja'];

  bool _autoplay = true;
  bool _wifiOnly = true;
  String _quality = 'Auto';
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadPrefs();
  }

  Future<void> _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      _autoplay = prefs.getBool(_keyAutoplay) ?? true;
      _wifiOnly = prefs.getBool(_keyWifiOnly) ?? true;
      _quality = prefs.getString(_keyQuality) ?? 'Auto';
      _loading = false;
    });
  }

  Future<void> _saveBool(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  Future<void> _saveQuality(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyQuality, value);
  }

  @override
  Widget build(BuildContext context) {
    return SettingsSubScaffold(
      title: 'Preference Video',
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: Colors.white))
          : ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                _SwitchTile(
                  icon: Icons.play_circle_outline,
                  title: 'Reproducción automática',
                  value: _autoplay,
                  onChanged: (v) {
                    setState(() => _autoplay = v);
                    _saveBool(_keyAutoplay, v);
                  },
                ),
                _SwitchTile(
                  icon: Icons.wifi,
                  title: 'Descargar solo con Wi-Fi',
                  value: _wifiOnly,
                  onChanged: (v) {
                    setState(() => _wifiOnly = v);
                    _saveBool(_keyWifiOnly, v);
                  },
                ),
                const SizedBox(height: 16),
                const Text('Calidad de video',
                    style: TextStyle(color: Colors.white54, fontSize: 12)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _qualities.map((q) {
                    final selected = _quality == q;
                    return ChoiceChip(
                      label: Text(q),
                      selected: selected,
                      onSelected: (_) {
                        setState(() => _quality = q);
                        _saveQuality(q);
                      },
                      selectedColor: Colors.blue,
                      backgroundColor: Colors.white.withValues(alpha: 0.08),
                      labelStyle:
                          TextStyle(color: selected ? Colors.white : Colors.white70),
                    );
                  }).toList(),
                ),
              ],
            ),
    );
  }
}

class _SwitchTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SwitchTile({
    required this.icon,
    required this.title,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
      ),
      child: SwitchListTile(
        secondary: Icon(icon, color: Colors.white70),
        title: Text(title, style: const TextStyle(color: Colors.white)),
        value: value,
        activeThumbColor: Colors.blue,
        onChanged: onChanged,
      ),
    );
  }
}
