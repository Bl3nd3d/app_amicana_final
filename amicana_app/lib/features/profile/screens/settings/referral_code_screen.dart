import 'package:flutter/material.dart';

class ReferralCodeScreen extends StatelessWidget {
  const ReferralCodeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Referral Code'),
        backgroundColor: const Color(0xFF0A183C),
      ),
      body: const Center(
        child: Text(
          'Referral Code Screen',
          style: TextStyle(color: Colors.white),
        ),
      ),
      backgroundColor: const Color(0xFF0A183C),
    );
  }
}
