import 'package:amicana_app/core/models/progress_model.dart';
import 'package:amicana_app/features/library/services/progress_service.dart';
import 'package:amicana_app/features/profile/bloc/progress_bloc/progress_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProgressBloc(
        progressService: RepositoryProvider.of<ProgressService>(context),
      )..add(LoadProgress()),
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: const Color(0xFF0A183C),
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: () => context.go('/library'),
            ),
            title: const Text('Progress',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            centerTitle: true,
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
                  if (state is ProgressLoading || state is ProgressInitial) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is ProgressError) {
                    return Center(
                        child: Text('Error: ${state.message}',
                            style: const TextStyle(color: Colors.white)));
                  } else if (state is ProgressLoaded) {
                    final progress = state.progress;
                    return ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      children: [
                        Center(
                          child: Text(
                            '¡Vamos, ${progress.userName}!',
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: 24),
                        _buildTabs(),
                        const SizedBox(height: 24),
                        _buildCircularStats(progress),
                        const SizedBox(height: 24),
                        _buildPodium(),
                        const SizedBox(height: 24),
                        _buildTabContent(progress),
                        const SizedBox(height: 20),
                      ],
                    );
                  } else {
                    return const Center(
                        child: Text('No progress data available.',
                            style: TextStyle(color: Colors.white)));
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabs() {
    return Center(
      child: Container(
        width: 250,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.white.withAlpha(25),
          borderRadius: BorderRadius.circular(20),
        ),
        child: TabBar(
          labelColor: Colors.black,
          unselectedLabelColor: Colors.white,
          indicator: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.white,
          ),
          tabs: const [
            Tab(text: 'All Time'),
            Tab(text: 'Weekly'),
          ],
        ),
      ),
    );
  }

  Widget _buildTabContent(Progress progress) {
    return SizedBox(
      height: 350,
      child: TabBarView(
        children: [
          _buildRankedList(progress),
          const Center(
              child: Text('Weekly progress is not available yet.',
                  style: TextStyle(color: Colors.white70))),
        ],
      ),
    );
  }

  Widget _buildCircularStats(Progress progress) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _CircularStat(
            icon: Icons.menu_book,
            label: 'Readings',
            percentage: progress.readingPercentage,
            color: Colors.blue),
        _CircularStat(
            icon: Icons.mic,
            label: 'Speaker',
            percentage: progress.speakerPercentage,
            color: Colors.yellow),
        _CircularStat(
            icon: Icons.edit,
            label: 'Writing',
            percentage: progress.writingPercentage,
            color: Colors.red),
      ],
    );
  }

  Widget _buildPodium() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _PodiumStep(rank: '2', height: 60, color: Color(0xFFC0C0C0)),
        SizedBox(width: 4),
        _PodiumStep(rank: '1', height: 90, color: Color(0xFFFFD700)),
        SizedBox(width: 4),
        _PodiumStep(rank: '3', height: 40, color: Color(0xFFCD7F32)),
      ],
    );
  }

  Widget _buildRankedList(Progress progress) {
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: progress.rankedList.map((item) {
        return _RankedListItem(
          rank: item['rank'],
          icon: _iconFromString(item['icon']),
          title: item['title'],
        );
      }).toList(),
    );
  }

  IconData _iconFromString(String iconName) {
    switch (iconName) {
      case 'image_outlined':
        return Icons.image_outlined;
      case 'youtube_searched_for_outlined':
        return Icons.youtube_searched_for_outlined;
      case 'groups_outlined':
        return Icons.groups_outlined;
      case 'campaign_outlined':
        return Icons.campaign_outlined;
      case 'history_edu_outlined':
        return Icons.history_edu_outlined;
      default:
        return Icons.help_outline;
    }
  }
}

// --- WIDGETS DE AYUDA ---

class _CircularStat extends StatelessWidget {
  final IconData icon;
  final String label;
  final double percentage;
  final Color color;
  const _CircularStat(
      {required this.icon,
      required this.label,
      required this.percentage,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: 70,
          height: 70,
          child: Stack(
            fit: StackFit.expand,
            children: [
              CircularProgressIndicator(
                value: percentage,
                strokeWidth: 6,
                backgroundColor: Colors.white.withAlpha(50),
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
              Center(child: Icon(icon, color: Colors.white, size: 30)),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(label,
            style: const TextStyle(color: Colors.white70, fontSize: 12)),
        Text('${(percentage * 100).toInt()}%',
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ],
    );
  }
}

class _PodiumStep extends StatelessWidget {
  final String rank;
  final double height;
  final Color color;
  const _PodiumStep(
      {required this.rank, required this.height, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: height,
      decoration: BoxDecoration(
          color: Colors.white.withAlpha(25),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
          ),
          border: Border.all(color: Colors.white24)),
      child: Center(
        child: Text(
          rank,
          style: TextStyle(
              color: color, fontSize: 40, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class _RankedListItem extends StatelessWidget {
  final int rank;
  final IconData icon;
  final String title;
  const _RankedListItem(
      {required this.rank, required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      margin: const EdgeInsets.only(top: 12),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(25),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Text('$rank',
              style: const TextStyle(color: Colors.white70, fontSize: 16)),
          const SizedBox(width: 16),
          CircleAvatar(
            backgroundColor: Colors.white.withAlpha(25),
            child: Icon(icon, color: Colors.white70, size: 20),
          ),
          const SizedBox(width: 16),
          Text(title,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
