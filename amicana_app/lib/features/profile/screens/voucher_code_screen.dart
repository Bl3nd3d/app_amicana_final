import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:amicana_app/features/profile/widgets/settings_sub_scaffold.dart';

/// No existe (todavía) un backend de vouchers, así que el canje se valida
/// localmente contra los códigos ya usados guardados en SharedPreferences.
/// Cuando haya un endpoint real, solo hay que reemplazar el contenido
/// de _redeem() por la llamada al servicio correspondiente.
class VoucherCodeScreen extends StatefulWidget {
  const VoucherCodeScreen({super.key});

  @override
  State<VoucherCodeScreen> createState() => _VoucherCodeScreenState();
}

class _VoucherCodeScreenState extends State<VoucherCodeScreen> {
  static const _keyRedeemed = 'redeemed_vouchers';
  final _controller = TextEditingController();
  List<String> _redeemed = [];
  bool _loading = true;
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    _loadRedeemed();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _loadRedeemed() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      _redeemed = prefs.getStringList(_keyRedeemed) ?? [];
      _loading = false;
    });
  }

  Future<void> _redeem() async {
    final code = _controller.text.trim().toUpperCase();
    if (code.isEmpty) return;

    setState(() => _submitting = true);
    await Future.delayed(const Duration(milliseconds: 400)); // simula validación
    if (!mounted) return;

    if (_redeemed.contains(code)) {
      _showMessage('Este código ya fue canjeado.', isError: true);
    } else {
      final prefs = await SharedPreferences.getInstance();
      final updated = [..._redeemed, code];
      await prefs.setStringList(_keyRedeemed, updated);
      if (!mounted) return;
      setState(() => _redeemed = updated);
      _controller.clear();
      _showMessage('¡Código canjeado con éxito!');
    }
    if (mounted) setState(() => _submitting = false);
  }

  void _showMessage(String text, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(text), backgroundColor: isError ? Colors.red : Colors.green),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SettingsSubScaffold(
      title: 'Voucher Code',
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: Colors.white))
          : ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                const Text('Ingresá tu código de voucher',
                    style: TextStyle(color: Colors.white70)),
                const SizedBox(height: 12),
                TextField(
                  controller: _controller,
                  textCapitalization: TextCapitalization.characters,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Ej: AMICANA2026',
                    hintStyle: const TextStyle(color: Colors.white38),
                    filled: true,
                    fillColor: Colors.white.withValues(alpha: 0.08),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _submitting ? null : _redeem,
                    child: _submitting
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2))
                        : const Text('Canjear'),
                  ),
                ),
                if (_redeemed.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  const Text('Códigos canjeados',
                      style: TextStyle(color: Colors.white54, fontSize: 12)),
                  const SizedBox(height: 8),
                  ..._redeemed.map(
                    (c) => Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.check_circle_outline,
                              color: Colors.greenAccent, size: 18),
                          const SizedBox(width: 12),
                          Text(c, style: const TextStyle(color: Colors.white)),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
    );
  }
}
