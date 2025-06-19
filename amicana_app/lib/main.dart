import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:amicana_app/firebase_options.dart';

import 'package:amicana_app/app/routes/app_router.dart';
import 'package:amicana_app/app/theme/app_theme.dart';
import 'package:amicana_app/features/auth/bloc/auth_bloc.dart';

void main() async {
  // Asegura que los bindings de Flutter estén listos
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    // --- AQUÍ ESTÁ LA SOLUCIÓN ---
    // Envolvemos toda la aplicación en el BlocProvider para que AuthBloc
    // esté disponible en todas las pantallas.
    BlocProvider(
      create: (context) => AuthBloc(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'A.M.I.C.A.N.A. App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: AppRouter.router,
    );
  }
}
