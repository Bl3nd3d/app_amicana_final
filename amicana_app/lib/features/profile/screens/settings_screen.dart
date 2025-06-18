import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
          onPressed: () => context
              .pop(), // 'pop' para volver a la pantalla anterior (Perfil)
        ),
        title: const Text('Profile',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
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
              _buildSettingsGroup([
                _buildSettingsTile(context,
                    icon: Icons.school_outlined,
                    title: 'Investor Academy',
                    onTap: () {}),
                _buildSettingsTile(context,
                    icon: Icons.quiz_outlined, title: 'FAQs', onTap: () {}),
                _buildSettingsTile(context,
                    icon: Icons.help_outline,
                    title: 'Help Center',
                    onTap: () {}),
              ]),
              const SizedBox(height: 20),
              _buildSettingsGroup([
                _buildSettingsTile(context,
                    icon: Icons.language_outlined,
                    title: 'Language',
                    onTap: () {}),
                _buildSettingsTile(context,
                    icon: Icons.privacy_tip_outlined,
                    title: 'Privacy',
                    onTap: () {}),
              ]),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsGroup(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) => children[index],
        separatorBuilder: (context, index) => Divider(
          height: 1,
          color: Colors.white.withOpacity(0.15),
          indent: 56,
        ),
        itemCount: children.length,
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
