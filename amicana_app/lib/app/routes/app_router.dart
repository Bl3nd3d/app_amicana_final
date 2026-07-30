import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:amicana_app/core/services/progress_service.dart';
import 'package:amicana_app/features/profile/bloc/progress_bloc.dart';
import 'package:amicana_app/features/profile/bloc/progress_event.dart';
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
import 'package:amicana_app/features/profile/screens/personal_details_screen.dart';
import 'package:amicana_app/features/profile/screens/preference_video_screen.dart';
import 'package:amicana_app/features/profile/screens/your_downloads_screen.dart';
import 'package:amicana_app/features/profile/screens/referral_code_screen.dart';
import 'package:amicana_app/features/profile/screens/learning_reminder_screen.dart';
import 'package:amicana_app/features/profile/screens/voucher_code_screen.dart';
import 'package:amicana_app/features/profile/screens/help_center_screen.dart';
import 'package:amicana_app/features/search/screens/search_screen.dart';
import 'package:amicana_app/features/library/screens/saved_screen.dart';

class AppRouter {
  AppRouter._();
  static final GoRouter router = GoRouter(
    initialLocation: '/login',
    redirect: (BuildContext context, GoRouterState state) {
      final bool loggedIn = firebase.FirebaseAuth.instance.currentUser != null;
      final bool isPublicRoute =
          state.matchedLocation == '/login' || state.matchedLocation == '/register';
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
          builder: (context, state) => BookListScreen(
              category: state.uri.queryParameters['category']),
          routes: [
            GoRoute(
                path: ':bookId',
                name: 'bookDetail',
                builder: (context, state) =>
                    BookDetailScreen(bookId: state.pathParameters['bookId']!),
                routes: [
                  GoRoute(
                    path: 'chapter/:chapterId',
                    name: 'chapterDetail',
                    builder: (context, state) {
                      final extraData = state.extra as Map<String, dynamic>;
                      return ChapterDetailScreen(
                          book: extraData['book'] as Book,
                          chapter: extraData['chapter'] as Chapter);
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
          path: '/search',
          name: 'search',
          builder: (context, state) => const SearchScreen()),
      GoRoute(
          path: '/saved',
          name: 'saved',
          builder: (context, state) => const SavedScreen()),
      GoRoute(
          path: '/profile',
          name: 'profile',
          builder: (context, state) => const ProfileScreen()),
      GoRoute(
          path: '/settings',
          name: 'settings',
          builder: (context, state) => const SettingsScreen(),
          routes: [
            GoRoute(
                path: 'personal-details',
                name: 'personalDetails',
                builder: (context, state) => const PersonalDetailsScreen()),
            GoRoute(
                path: 'preference-video',
                name: 'preferenceVideo',
                builder: (context, state) => const PreferenceVideoScreen()),
            GoRoute(
                path: 'downloads',
                name: 'yourDownloads',
                builder: (context, state) => const YourDownloadsScreen()),
            GoRoute(
                path: 'referral-code',
                name: 'referralCode',
                builder: (context, state) => const ReferralCodeScreen()),
            GoRoute(
                path: 'learning-reminder',
                name: 'learningReminder',
                builder: (context, state) => const LearningReminderScreen()),
            GoRoute(
                path: 'voucher-code',
                name: 'voucherCode',
                builder: (context, state) => const VoucherCodeScreen()),
            GoRoute(
                path: 'help-center',
                name: 'helpCenter',
                builder: (context, state) => const HelpCenterScreen()),
          ]),
      GoRoute(
        path: '/progress',
        name: 'progress',
        builder: (context, state) => BlocProvider(
          create: (context) =>
              ProgressBloc(progressService: ProgressService())..add(LoadProgress()),
          child: const ProgressScreen(),
        ),
      ),
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
