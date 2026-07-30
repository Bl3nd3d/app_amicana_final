import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:amicana_app/features/profile/bloc/progress_bloc.dart';
import 'package:amicana_app/features/profile/bloc/progress_event.dart';
import 'package:amicana_app/features/profile/bloc/progress_state.dart';
import 'package:amicana_app/core/models/progress_model.dart';
import 'package:amicana_app/core/services/progress_service.dart';
import 'package:amicana_app/core/models/quiz_resolution_model.dart';
import 'package:amicana_app/features/library/models/book_model.dart';
import 'package:amicana_app/features/library/services/library_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _libraryService = LibraryService();
  List<Book>? _books;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (mounted) setState(() {});
    });
    _libraryService.getBooks().then((books) {
      if (mounted) setState(() => _books = books);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    String userName = 'Guest';
    String userEmail = 'No Email';

    if (currentUser?.email != null && currentUser!.email!.isNotEmpty) {
      userName = currentUser.email!.split('@').first;
      userName = userName.substring(0, 1).toUpperCase() + userName.substring(1);
      userEmail = currentUser.email!;
    } else if (currentUser?.displayName != null &&
        currentUser!.displayName!.isNotEmpty) {
      userName = currentUser.displayName!;
    }

    return BlocProvider(
      create: (context) =>
          ProgressBloc(progressService: ProgressService())..add(LoadProgress()),
      child: Scaffold(
        backgroundColor: const Color(0xFF0A183C),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => context.go('/library'),
          ),
          title: const Text('Profile',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.settings, color: Colors.white),
              onPressed: () => context.push('/settings'),
            ),
          ],
        ),
        body: Stack(
          children: [
            Positioned.fill(
              child: Opacity(
                opacity: 0.3,
                child: Image.asset('assets/images/fondo_app.webp',
                    fit: BoxFit.cover),
              ),
            ),
            BlocBuilder<ProgressBloc, ProgressState>(
              builder: (context, state) {
                final progress = state is ProgressLoaded ? state.progress : Progress();
                return ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  children: [
                    Center(
                        child: _buildProfileHeader(
                            userName, userEmail, currentUser?.photoURL)),
                    const SizedBox(height: 24),
                    _buildStatsGrid(progress),
                    const SizedBox(height: 24),
                    _buildTabs(),
                    _buildTabContent(progress),
                    const SizedBox(height: 24),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(String name, String email, String? photoUrl) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundImage: photoUrl != null ? NetworkImage(photoUrl) : null,
          child: photoUrl == null ? const Icon(Icons.person, size: 40) : null,
        ),
        const SizedBox(height: 12),
        Text(name,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(email,
            style: const TextStyle(color: Colors.white70, fontSize: 14)),
      ],
    );
  }

  Widget _buildStatsGrid(Progress progress) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
                child: _StatCard(
                    icon: Icons.menu_book_outlined,
                    value: '${progress.totalCompletedChapters}',
                    label: 'Capítulos Completados',
                    color: Colors.blue)),
            const SizedBox(width: 16),
            Expanded(
                child: _StatCard(
                    icon: Icons.quiz_outlined,
                    value: '${progress.totalCompletedQuizzes}',
                    label: 'Trivias Resueltas',
                    color: Colors.orange)),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
                child: _StatCard(
                    icon: Icons.emoji_events_outlined,
                    value: '${progress.globalScore}',
                    label: 'Puntaje Global',
                    color: Colors.green)),
            const SizedBox(width: 16),
            Expanded(child: _AverageAccuracyCard()),
          ],
        ),
      ],
    );
  }

  Widget _buildTabs() {
    return TabBar(
      controller: _tabController,
      labelColor: Colors.white,
      unselectedLabelColor: Colors.white54,
      indicator: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white.withAlpha(50),
      ),
      tabs: const [
        Tab(text: 'In progress'),
        Tab(text: 'Upcoming'),
        Tab(text: 'Completed'),
      ],
    );
  }

  Widget _buildTabContent(Progress progress) {
    if (_books == null) {
      return const SizedBox(
        height: 120,
        child: Center(child: CircularProgressIndicator(color: Colors.white)),
      );
    }

    final completedIds = progress.completedChapterIds;
    final inProgress = <(Book, int, int)>[];
    final upcoming = <(Book, int, int)>[];
    final completed = <(Book, int, int)>[];

    for (final book in _books!) {
      final total = book.chapters.length;
      if (total == 0) continue;
      final done = book.chapters.where((c) => completedIds.contains(c.id)).length;
      if (done == 0) {
        upcoming.add((book, done, total));
      } else if (done == total) {
        completed.add((book, done, total));
      } else {
        inProgress.add((book, done, total));
      }
    }

    return SizedBox(
      height: 300,
      child: TabBarView(
        controller: _tabController,
        children: [
          _buildBookList(inProgress, 'No tenés libros en progreso.'),
          _buildBookList(upcoming, 'No tenés libros por empezar.'),
          _buildBookList(completed, 'Todavía no completaste ningún libro.'),
        ],
      ),
    );
  }

  Widget _buildBookList(List<(Book, int, int)> entries, String emptyMessage) {
    if (entries.isEmpty) {
      return Center(
          child: Text(emptyMessage,
              style: const TextStyle(color: Colors.white70)));
    }
    return ListView(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      children: entries.map((entry) {
        final (book, done, total) = entry;
        return _ProgressListItem(
          icon: Icons.menu_book_outlined,
          title: book.title,
          subtitle: book.author,
          progress: total > 0 ? done / total : 0,
          progressText: '$done/$total',
          color: Colors.blue,
        );
      }).toList(),
    );
  }
}

/// Card que calcula la precisión promedio (aciertos / preguntas) de todo
/// el historial de trivias resueltas.
class _AverageAccuracyCard extends StatelessWidget {
  final _service = ProgressService();

  _AverageAccuracyCard();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<QuizResolution>>(
      stream: _service.watchQuizResolutions(),
      builder: (context, snapshot) {
        final results = snapshot.data ?? const <QuizResolution>[];
        String value = '—';
        if (results.isNotEmpty) {
          final avg = results.map((r) => r.accuracy).reduce((a, b) => a + b) /
              results.length;
          value = '${(avg * 100).toStringAsFixed(0)}%';
        }
        return _StatCard(
          icon: Icons.track_changes_outlined,
          value: value,
          label: 'Precisión Promedio',
          color: Colors.purpleAccent,
        );
      },
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;
  const _StatCard(
      {required this.icon,
      required this.value,
      required this.label,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(25),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: color.withValues(alpha: 0.3),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 12),
          Text(value,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 2),
          Text(label,
              style: const TextStyle(color: Colors.white70, fontSize: 12)),
        ],
      ),
    );
  }
}

class _ProgressListItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final double progress;
  final String progressText;
  final Color color;
  const _ProgressListItem(
      {required this.icon,
      required this.title,
      required this.subtitle,
      required this.progress,
      required this.progressText,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(top: 16),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(25),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                  backgroundColor: color.withValues(alpha: 0.2),
                  child: Icon(icon, color: color)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                    Text(subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Colors.white54, fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(children: [
            Expanded(
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.white.withAlpha(50),
                valueColor: AlwaysStoppedAnimation<Color>(color),
                minHeight: 6,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            const SizedBox(width: 16),
            Text(progressText,
                style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                    fontWeight: FontWeight.bold)),
          ])
        ],
      ),
    );
  }
}
