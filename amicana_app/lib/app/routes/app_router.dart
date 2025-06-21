import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;

// Modelos
import 'package:amicana_app/core/models/user_model.dart';
import 'package:amicana_app/features/library/models/book_model.dart';
import 'package:amicana_app/core/models/chapter_model.dart';
import 'package:amicana_app/features/quizzes/models/quiz_model.dart';

// Pantallas
import 'package:amicana_app/features/auth/screens/login_screen.dart';
import 'package:amicana_app/features/auth/screens/register_screen.dart';
import 'package:amicana_app/features/auth/screens/role_selection_screen.dart';
import 'package:amicana_app/features/library/screens/library_home_screen.dart';
import 'package:amicana_app/features/library/screens/book_list_screen.dart';
import 'package:amicana_app/features/library/screens/book_detail_screen.dart';
import 'package:amicana_app/features/library/screens/chapter_detail_screen.dart';
import 'package:amicana_app/features/quizzes/screens/quizzes_list_screen.dart';
import 'package:amicana_app/features/quizzes/screens/quiz_player_screen.dart';
import 'package:amicana_app/features/profile/screens/profile_screen.dart';
import 'package:amicana_app/features/profile/screens/settings_screen.dart';
import 'package:amicana_app/features/profile/screens/progress_screen.dart';

class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: '/login',

    // Guardián de rutas para proteger la app
    redirect: (BuildContext context, GoRouterState state) {
      final bool loggedIn = firebase.FirebaseAuth.instance.currentUser != null;
      final bool isPublicRoute = state.matchedLocation == '/login' ||
          state.matchedLocation == '/register';

      if (!loggedIn && !isPublicRoute) {
        return '/login';
      }
      if (loggedIn && isPublicRoute) {
        return '/library';
      }
      return null;
    },

    routes: [
      // Rutas de Autenticación
      GoRoute(
          path: '/login',
          name: 'login',
          builder: (context, state) => const LoginScreen()),
      GoRoute(
          path: '/register',
          name: 'register',
          builder: (context, state) => const RegisterScreen()),
      GoRoute(
        path: '/select-role',
        name: 'selectRole',
        builder: (context, state) =>
            RoleSelectionScreen(user: state.extra as User),
      ),

      // Ruta Principal (Home)
      GoRoute(
          path: '/library',
          name: 'library',
          builder: (context, state) => const LibraryHomeScreen()),

      // --- ESTRUCTURA DE RUTAS DE LIBROS ANIDADA Y CORREGIDA ---
      GoRoute(
        path: '/books',
        name: 'books',
        builder: (context, state) => const BookListScreen(),
        routes: [
          GoRoute(
            path: ':bookId', // La ruta es relativa a /books (ej: /books/un-id)
            name: 'bookDetail',
            builder: (context, state) {
              final bookId = state.pathParameters['bookId']!;
              return BookDetailScreen(bookId: bookId);
            },
            routes: [
              GoRoute(
                path: 'chapter/:chapterId',
                name: 'chapterDetail',
                builder: (context, state) {
                  final extraData = state.extra as Map<String, dynamic>;
                  return ChapterDetailScreen(
                    book: extraData['book'] as Book,
                    chapter: extraData['chapter'] as Chapter,
                  );
                },
              )
            ],
          ),
        ],
      ),

      // Rutas de Trivias
      GoRoute(
          path: '/quizzes',
          name: 'quizzes',
          builder: (context, state) => const QuizzesListScreen(),
          routes: [
            GoRoute(
                path: 'quiz/:quizId',
                name: 'quizPlayer',
                builder: (context, state) =>
                    QuizPlayerScreen(quiz: state.extra as Quiz)),
          ]),

      // Rutas de Perfil
      GoRoute(
          path: '/profile',
          name: 'profile',
          builder: (context, state) => const ProfileScreen()),
      GoRoute(
          path: '/settings',
          name: 'settings',
          builder: (context, state) => const SettingsScreen()),
      GoRoute(
          path: '/progress',
          name: 'progress',
          builder: (context, state) => const ProgressScreen()),
    ],

    // Pantalla de Error 404
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
              child: const Text('Volver al Inicio'),
            ),
          ],
        ),
      ),
    ),
  );
}
