import 'package:flutter/material.dart';
import 'app/routes/app_router.dart'; // Importa el enrutador
import 'app/theme/app_theme.dart'; // Importa el tema

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Usamos MaterialApp.router para que la navegación la controle GoRouter
    return MaterialApp.router(
      title: 'A.M.I.C.A.N.A. App',
      debugShowCheckedModeBanner: false, // Oculta la cinta de "Debug"

      // Asignamos el tema y el enrutador que creamos
      theme: AppTheme.lightTheme,
      routerConfig: AppRouter.router,
    );
  }
}
