import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:amicana_app/features/profile/bloc/progress_bloc.dart';
import 'package:amicana_app/features/profile/bloc/progress_state.dart';
import 'package:amicana_app/core/models/progress_model.dart';

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
            onPressed: () => context.pop(),
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
                  // If there's no data, show a message.
                  if (state.progress.categoryStats.isEmpty) {
                    return const Center(
                      child: Text(
                        'No progress yet. Start a lesson to see your stats!',
                        style: TextStyle(color: Colors.white70, fontSize: 16),
                        textAlign: TextAlign.center,
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
    final rest = sortedStats.length > 3 ? sortedStats.skip(3).toList() : <MapEntry<String, int>>[];

    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        _buildCircularStats(context, state.progress),
        const SizedBox(height: 32),
        if (top3.isNotEmpty) ...[
          _buildSectionTitle(context, 'Top Skills'),
          const SizedBox(height: 16),
          _buildPodium(context, top3),
          const SizedBox(height: 32),
        ],
        if (rest.isNotEmpty) ...[
          _buildSectionTitle(context, 'All Skills'),
          const SizedBox(height: 16),
          _buildRankedList(context, rest),
        ]
      ],
    );
  }

  Widget _buildCircularStats(BuildContext context, Progress progress) {
    // As per prompt, assuming 1000 points total for percentage calculation
    const double maxPoints = 1000.0;
    
    final readingPoints = progress.categoryStats['Reading'] ?? 0;
    final speakerPoints = progress.categoryStats['Speaker'] ?? 0;
    final writingPoints = progress.categoryStats['Writing'] ?? 0;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _CircularStat(
            label: 'Reading',
            value: readingPoints / maxPoints,
            points: readingPoints),
        _CircularStat(
            label: 'Speaker',
            value: speakerPoints / maxPoints,
            points: speakerPoints),
        _CircularStat(
            label: 'Writing',
            value: writingPoints / maxPoints,
            points: writingPoints),
      ],
    );
  }

  Widget _buildPodium(BuildContext context, List<MapEntry<String, int>> top3) {
    // Simple Row-based podium
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (top3.length > 1) _PodiumItem(entry: top3[1], place: 2),
        if (top3.isNotEmpty) _PodiumItem(entry: top3[0], place: 1),
        if (top3.length > 2) _PodiumItem(entry: top3[2], place: 3),
      ],
    );
  }

  Widget _buildRankedList(BuildContext context, List<MapEntry<String, int>> rest) {
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

  Widget _buildSectionTitle(BuildContext context, String title) {
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

// Helper Widgets for the screen

class _CircularStat extends StatelessWidget {
  final String label;
  final double value; // 0.0 to 1.0
  final int points;

  const _CircularStat(
      {required this.label, required this.value, required this.points});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: 80,
          height: 80,
          child: Stack(
            fit: StackFit.expand,
            children: [
              CircularProgressIndicator(
                value: value,
                strokeWidth: 8,
                backgroundColor: Colors.white.withValues(alpha: 0.2),
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.lightBlueAccent),
              ),
              Center(
                  child: Text('${(value * 100).toInt()}%',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold))),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(color: Colors.white70)),
        Text('$points pts', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ],
    );
  }
}

class _PodiumItem extends StatelessWidget {
  final MapEntry<String, int> entry;
  final int place;

  const _PodiumItem({required this.entry, required this.place});

  double _getHeight() {
    switch (place) {
      case 1:
        return 120;
      case 2:
        return 90;
      case 3:
        return 70;
      default:
        return 70;
    }
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
