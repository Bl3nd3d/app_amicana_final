import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:amicana_app/features/profile/bloc/progress_bloc.dart';
import 'package:amicana_app/features/profile/bloc/progress_state.dart';
import 'package:amicana_app/core/models/progress_model.dart';
import 'package:amicana_app/core/services/progress_service.dart';
import 'package:amicana_app/core/models/quiz_resolution_model.dart';
import 'package:amicana_app/features/library/models/book_model.dart';
import 'package:amicana_app/core/models/chapter_model.dart';
import 'package:amicana_app/features/library/services/library_service.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A183C),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.go('/library'),
        ),
        title: const Text('Your Progress',
            style:
                TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
              if (state is ProgressLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is ProgressError) {
                return Center(
                    child: Text('Error: ${state.message}',
                        style: const TextStyle(color: Colors.red)));
              }
              if (state is ProgressLoaded) {
                final p = state.progress;
                final hasAnyProgress = p.totalCompletedChapters > 0 ||
                    p.totalCompletedQuizzes > 0 ||
                    p.categoryStats.isNotEmpty;

                if (!hasAnyProgress) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(24.0),
                      child: Text(
                        'Todavía no tenés progreso. ¡Completá un capítulo o una trivia para ver tus estadísticas!',
                        style: TextStyle(color: Colors.white70, fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }
                return _buildProgressContent(context, state);
              }
              return const Center(
                  child: Text('Something went wrong.',
                      style: TextStyle(color: Colors.white)));
            },
          ),
        ],
      ),
    );
  }

  Widget _buildProgressContent(BuildContext context, ProgressLoaded state) {
    final sortedStats = state.sortedCategoryStats;
    final top3 = sortedStats.take(3).toList();
    final rest =
        sortedStats.length > 3 ? sortedStats.skip(3).toList() : <MapEntry<String, int>>[];

    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        _buildSummaryRow(state.progress),
        const SizedBox(height: 32),
        if (top3.isNotEmpty) ...[
          _buildSectionTitle('Top Skills'),
          const SizedBox(height: 16),
          _buildPodium(top3),
          const SizedBox(height: 32),
        ],
        if (rest.isNotEmpty) ...[
          _buildSectionTitle('All Skills'),
          const SizedBox(height: 16),
          _buildRankedList(rest),
          const SizedBox(height: 32),
        ],
        _buildSectionTitle('Resultados recientes de trivias'),
        const SizedBox(height: 16),
        _RecentQuizResults(),
        const SizedBox(height: 32),
        _buildSectionTitle('Capítulos completados (${state.progress.totalCompletedChapters})'),
        const SizedBox(height: 16),
        _CompletedChapters(completedChapterIds: state.progress.completedChapterIds),
      ],
    );
  }

  Widget _buildSummaryRow(Progress progress) {
    return Row(
      children: [
        Expanded(
          child: _SummaryCard(
            icon: Icons.menu_book_outlined,
            value: '${progress.totalCompletedChapters}',
            label: 'Capítulos',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _SummaryCard(
            icon: Icons.quiz_outlined,
            value: '${progress.totalCompletedQuizzes}',
            label: 'Trivias',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _SummaryCard(
            icon: Icons.emoji_events_outlined,
            value: '${progress.globalScore}',
            label: 'Puntaje',
          ),
        ),
      ],
    );
  }

  Widget _buildPodium(List<MapEntry<String, int>> top3) {
    // El podio se muestra en proporción al mejor puntaje entre las 3
    // categorías top, no contra un tope fijo (así funciona con cualquier
    // escala de puntaje, sean 3 puntos o 3000).
    final maxValue = top3.first.value == 0 ? 1 : top3.first.value;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (top3.length > 1) _PodiumItem(entry: top3[1], place: 2, maxValue: maxValue),
        if (top3.isNotEmpty) _PodiumItem(entry: top3[0], place: 1, maxValue: maxValue),
        if (top3.length > 2) _PodiumItem(entry: top3[2], place: 3, maxValue: maxValue),
      ],
    );
  }

  Widget _buildRankedList(List<MapEntry<String, int>> rest) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: rest.length,
        itemBuilder: (context, index) {
          final entry = rest[index];
          return ListTile(
            leading: Text(
              '#${index + 4}', // Starts from #4
              style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 16),
            ),
            title: Text(entry.key, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            trailing: Text('${entry.value} pts', style: const TextStyle(color: Colors.blueAccent, fontSize: 16)),
          );
        },
        separatorBuilder: (context, index) => Divider(height: 1, color: Colors.white.withValues(alpha: 0.15)),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _SummaryCard({required this.icon, required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.lightBlueAccent),
          const SizedBox(height: 8),
          Text(value,
              style: const TextStyle(
                  color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
          Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
        ],
      ),
    );
  }
}

class _PodiumItem extends StatelessWidget {
  final MapEntry<String, int> entry;
  final int place;
  final int maxValue;

  const _PodiumItem({required this.entry, required this.place, required this.maxValue});

  double _getHeight() {
    // Altura proporcional al puntaje relativo al mejor de las 3 categorías,
    // con un piso de 50 para que siempre se vea algo de barra.
    final ratio = entry.value / maxValue;
    final base = switch (place) { 1 => 130.0, 2 => 100.0, _ => 80.0 };
    return 50 + (base - 50) * ratio;
  }

  Color _getColor() {
    switch (place) {
      case 1:
        return Colors.amber;
      case 2:
        return Colors.grey[400]!;
      case 3:
        return Colors.brown[400]!;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _getHeight(),
      width: 100,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: _getColor(),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
        ),
        boxShadow: [
          BoxShadow(
            color: _getColor().withValues(alpha: 0.5),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            place.toString(),
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          const SizedBox(height: 4),
          Text(
            entry.key,
            style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
            textAlign: TextAlign.center,
          ),
          Text(
            '${entry.value} pts',
            style: const TextStyle(color: Colors.black54),
          ),
        ],
      ),
    );
  }
}

/// Lista de las últimas trivias resueltas, con puntaje y fecha.
class _RecentQuizResults extends StatelessWidget {
  final _service = ProgressService();

  _RecentQuizResults();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<QuizResolution>>(
      stream: _service.watchQuizResolutions(limit: 5),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
              child: Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: CircularProgressIndicator(color: Colors.white),
          ));
        }
        final results = snapshot.data!;
        if (results.isEmpty) {
          return Text('Todavía no resolviste ninguna trivia.',
              style: TextStyle(color: Colors.white.withValues(alpha: 0.6)));
        }
        return Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(16),
          ),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: results.length,
            separatorBuilder: (context, i) =>
                Divider(height: 1, color: Colors.white.withValues(alpha: 0.15)),
            itemBuilder: (context, i) {
              final r = results[i];
              final pct = (r.accuracy * 100).toStringAsFixed(0);
              return ListTile(
                leading: const Icon(Icons.quiz, color: Colors.white70),
                title: Text(r.quizTitle,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
                subtitle: Text(
                  '${r.category}${r.timestamp != null ? ' · ${_formatDate(r.timestamp!)}' : ''}',
                  style: const TextStyle(color: Colors.white54),
                ),
                trailing: Text('${r.scoreObtained}/${r.totalQuestions} ($pct%)',
                    style: const TextStyle(color: Colors.lightBlueAccent, fontWeight: FontWeight.bold)),
              );
            },
          ),
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}

/// Lista de capítulos completados, con el nombre real del libro y capítulo
/// (cruzando los ids guardados en el usuario contra el catálogo real).
class _CompletedChapters extends StatefulWidget {
  final List<String> completedChapterIds;
  const _CompletedChapters({required this.completedChapterIds});

  @override
  State<_CompletedChapters> createState() => _CompletedChaptersState();
}

class _CompletedChaptersState extends State<_CompletedChapters> {
  final _libraryService = LibraryService();
  List<Book>? _books;

  @override
  void initState() {
    super.initState();
    _libraryService.getBooks().then((books) {
      if (mounted) setState(() => _books = books);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.completedChapterIds.isEmpty) {
      return Text('Todavía no completaste ningún capítulo.',
          style: TextStyle(color: Colors.white.withValues(alpha: 0.6)));
    }
    if (_books == null) {
      return const Center(child: CircularProgressIndicator(color: Colors.white));
    }

    final entries = <(Book, Chapter)>[];
    for (final book in _books!) {
      for (final chapter in book.chapters) {
        if (widget.completedChapterIds.contains(chapter.id)) {
          entries.add((book, chapter));
        }
      }
    }

    if (entries.isEmpty) {
      return Text('Todavía no completaste ningún capítulo.',
          style: TextStyle(color: Colors.white.withValues(alpha: 0.6)));
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: entries.length,
        separatorBuilder: (context, i) =>
            Divider(height: 1, color: Colors.white.withValues(alpha: 0.15)),
        itemBuilder: (context, i) {
          final (book, chapter) = entries[i];
          return ListTile(
            leading: const Icon(Icons.check_circle, color: Colors.greenAccent),
            title: Text(chapter.title,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
            subtitle: Text(book.title, style: const TextStyle(color: Colors.white54)),
          );
        },
      ),
    );
  }
}
