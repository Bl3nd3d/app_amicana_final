import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:amicana_app/core/models/user_model.dart';
import 'package:amicana_app/features/library/models/book_model.dart';
import 'package:amicana_app/core/models/chapter_model.dart';
import 'package:amicana_app/features/quizzes/models/quiz_model.dart';
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
    redirect: (BuildContext context, GoRouterState state) {
      final bool loggedIn = firebase.FirebaseAuth.instance.currentUser != null;
      final bool isPublicRoute = state.matchedLocation == '/login' ||
          state.matchedLocation == '/register';
      if (!loggedIn && !isPublicRoute) return '/login';
      if (loggedIn && isPublicRoute) return '/library';
      return null;
    },
    routes: [
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
              RoleSelectionScreen(user: state.extra as User)),
      GoRoute(
          path: '/library',
          name: 'library',
          builder: (context, state) => const LibraryHomeScreen()),
      GoRoute(
          path: '/books',
          name: 'books',
          builder: (context, state) => const BookListScreen(),
          routes: [
            GoRoute(
                path: ':bookId', // ej: /books/id-del-libro
                name: 'bookDetail',
                builder: (context, state) =>
                    BookDetailScreen(bookId: state.pathParameters['bookId']!),
                routes: [
                  // --- ESTA ES LA RUTA ANIDADA CLAVE ---
                  GoRoute(
                    path:
                        'chapter/:chapterId', // ej: /books/id-del-libro/chapter/id-del-capitulo
                    name: 'chapterDetail',
                    builder: (context, state) {
                      final extraData = state.extra as Map<String, dynamic>;
                      return ChapterDetailScreen(
                        book: extraData['book'] as Book,
                        chapter: extraData['chapter'] as Chapter,
                      );
                    },
                  )
                ]),
          ]),
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
