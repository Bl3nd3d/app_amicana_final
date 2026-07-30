import 'package:flutter/material.dart';

class YourDownloadScreen extends StatelessWidget {
  const YourDownloadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Download'),
        backgroundColor: const Color(0xFF0A183C),
      ),
      body: const Center(
        child: Text(
          'Your Download Screen',
          style: TextStyle(color: Colors.white),
        ),
      ),
      backgroundColor: const Color(0xFF0A183C),
    );
  }
}
