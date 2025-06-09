import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:amicana_app/features/quizzes/models/quiz_model.dart';
import 'package:amicana_app/features/quizzes/screens/quizzes_list_screen.dart';
import 'package:amicana_app/features/quizzes/screens/quiz_player_screen.dart';
// --- SECCIÓN DE IMPORTACIONES USANDO RUTAS DE PAQUETE ---
// Modelos
import 'package:amicana_app/core/models/user_model.dart';
import 'package:amicana_app/features/library/models/book_model.dart';

// Pantallas de Autenticación
import 'package:amicana_app/features/auth/screens/login_screen.dart';
import 'package:amicana_app/features/auth/screens/role_selection_screen.dart';

// Pantallas de Biblioteca
import 'package:amicana_app/features/library/screens/library_home_screen.dart';
import 'package:amicana_app/features/library/screens/book_detail_screen.dart';
// -----------------------------------------------------------

class AppRouter {
  AppRouter._();

  // Definición completa del enrutador de la aplicación.
  static final GoRouter router = GoRouter(
    // La primera pantalla que se mostrará al abrir la app.
    initialLocation: '/login',

    // Lista de todas las rutas de la aplicación.
    routes: [
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/select-role',
        name: 'selectRole',
        builder: (context, state) {
          final user = state.extra as User;
          return RoleSelectionScreen(user: user);
        },
      ),
      GoRoute(
        path: '/library',
        name: 'library',
        builder: (context, state) => const LibraryHomeScreen(),
        routes: [
          // Ruta anidada para los detalles de un libro específico.
          GoRoute(
            path: 'book/:bookId',
            name: 'bookDetail',
            builder: (context, state) {
              // Recibimos el objeto 'Book' completo que pasamos como 'extra'.
              final book = state.extra as Book;
              return BookDetailScreen(book: book);
            },
          ),
        ],
      ),
      GoRoute(
          path: '/quizzes',
          name: 'quizzes',
          builder: (context, state) => const QuizzesListScreen(),
          routes: [
            GoRoute(
              path: 'quiz/:quizId',
              name: 'quizPlayer',
              builder: (context, state) {
                final quiz = state.extra as Quiz;
                return QuizPlayerScreen(quiz: quiz);
              },
            )
          ]),
    ],

    // Pantalla que se muestra si se navega a una ruta no existente (Error 404).
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: const Text('Página no encontrada')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Error 404: La página que buscas no existe.'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go('/library'),
              child: const Text('Volver a la Biblioteca'),
            ),
          ],
        ),
      ),
    ),
  );
}
