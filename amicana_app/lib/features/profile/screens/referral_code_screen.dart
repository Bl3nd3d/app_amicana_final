import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:amicana_app/features/auth/bloc/auth_bloc.dart';
import 'package:amicana_app/features/profile/widgets/settings_sub_scaffold.dart';

class ReferralCodeScreen extends StatelessWidget {
  const ReferralCodeScreen({super.key});

  String _codeFor(String uid) {
    if (uid.isEmpty) return 'AMICANA';
    final raw = uid.replaceAll(RegExp(r'[^A-Za-z0-9]'), '').toUpperCase();
    final slice = raw.length >= 6 ? raw.substring(0, 6) : raw;
    return 'AMI-$slice';
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthBloc>().state;
    final uid = authState is AuthSuccess ? authState.user.id : '';
    final code = _codeFor(uid);

    return SettingsSubScaffold(
      title: 'Referral Code',
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.card_giftcard_outlined, size: 56, color: Colors.blue[200]),
              const SizedBox(height: 16),
              const Text(
                'Compartí tu código y sumá beneficios',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white24),
                ),
                child: Text(
                  code,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                icon: const Icon(Icons.copy),
                label: const Text('Copiar código'),
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: code));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Código copiado al portapapeles')),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
