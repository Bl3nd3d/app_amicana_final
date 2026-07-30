import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:amicana_app/features/profile/widgets/settings_sub_scaffold.dart';

class LearningReminderScreen extends StatefulWidget {
  const LearningReminderScreen({super.key});

  @override
  State<LearningReminderScreen> createState() => _LearningReminderScreenState();
}

class _LearningReminderScreenState extends State<LearningReminderScreen> {
  static const _keyEnabled = 'reminder_enabled';
  static const _keyHour = 'reminder_hour';
  static const _keyMinute = 'reminder_minute';

  bool _enabled = false;
  TimeOfDay _time = const TimeOfDay(hour: 19, minute: 0);
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
      _enabled = prefs.getBool(_keyEnabled) ?? false;
      _time = TimeOfDay(
        hour: prefs.getInt(_keyHour) ?? 19,
        minute: prefs.getInt(_keyMinute) ?? 0,
      );
      _loading = false;
    });
  }

  Future<void> _toggleEnabled(bool value) async {
    setState(() => _enabled = value);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyEnabled, value);
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(context: context, initialTime: _time);
    if (picked == null) return;
    setState(() => _time = picked);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyHour, picked.hour);
    await prefs.setInt(_keyMinute, picked.minute);
  }

  @override
  Widget build(BuildContext context) {
    return SettingsSubScaffold(
      title: 'Learning Reminder',
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: Colors.white))
          : ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: SwitchListTile(
                    secondary:
                        const Icon(Icons.notifications_active_outlined, color: Colors.white70),
                    title:
                        const Text('Recordatorio diario', style: TextStyle(color: Colors.white)),
                    subtitle: const Text('Te avisamos para que no pierdas la racha',
                        style: TextStyle(color: Colors.white54)),
                    value: _enabled,
                    activeThumbColor: Colors.blue,
                    onChanged: _toggleEnabled,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.access_time, color: Colors.white70),
                    title: const Text('Hora del recordatorio',
                        style: TextStyle(color: Colors.white)),
                    trailing: Text(_time.format(context),
                        style:
                            const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                    enabled: _enabled,
                    onTap: _enabled ? _pickTime : null,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Nota: esto guarda tu preferencia localmente, pero todavía falta '
                  'conectar una notificación push real (requiere agregar el paquete '
                  'flutter_local_notifications).',
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 12),
                ),
              ],
            ),
    );
  }
}
