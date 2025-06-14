import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// --- SECCIÓN ÚNICA Y ORGANIZADA DE IMPORTACIONES ---

// Modelos (los datos que usa la app)
import 'package:amicana_app/core/models/user_model.dart';
import 'package:amicana_app/features/library/models/book_model.dart';
import 'package:amicana_app/features/quizzes/models/quiz_model.dart';

// Pantallas (las vistas que el usuario ve)
import 'package:amicana_app/features/auth/screens/login_screen.dart';
import 'package:amicana_app/features/auth/screens/register_screen.dart';
import 'package:amicana_app/features/auth/screens/role_selection_screen.dart';
import 'package:amicana_app/features/library/screens/library_home_screen.dart';
import 'package:amicana_app/features/library/screens/book_detail_screen.dart';
import 'package:amicana_app/features/quizzes/screens/quizzes_list_screen.dart';
import 'package:amicana_app/features/quizzes/screens/quiz_player_screen.dart';
// ----------------------------------------------------

class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: '/login',
    routes: [
      // --- Rutas de Autenticación ---
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/select-role',
        name: 'selectRole',
        builder: (context, state) {
          final user = state.extra as User;
          return RoleSelectionScreen(user: user);
        },
      ),

      // --- Rutas de Biblioteca ---
      GoRoute(
        path: '/library',
        name: 'library',
        builder: (context, state) => const LibraryHomeScreen(),
        routes: [
          GoRoute(
            path: 'book/:bookId',
            name: 'bookDetail',
            builder: (context, state) {
              final book = state.extra as Book;
              return BookDetailScreen(book: book);
            },
          ),
        ],
      ),

      // --- Rutas de Trivias ---
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

    // --- Pantalla para Rutas No Encontradas (Error 404) ---
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
