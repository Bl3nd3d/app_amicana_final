import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A183C),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: const Text('Progress',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.3,
              child:
                  Image.asset('assets/images/fondo_app.png', fit: BoxFit.cover),
            ),
          ),
          ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            children: [
              _buildTabs(),
              const SizedBox(height: 24),
              _buildCircularStats(),
              const SizedBox(height: 24),
              _buildPodium(),
              const SizedBox(height: 24),
              _buildRankedList(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return Center(
      child: Container(
        width: 250,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: TabBar(
          controller: _tabController,
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

  Widget _buildCircularStats() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _CircularStat(
            icon: Icons.menu_book,
            label: 'Readings',
            percentage: 0.40,
            color: Colors.blue),
        _CircularStat(
            icon: Icons.mic,
            label: 'Speaker',
            percentage: 0.45,
            color: Colors.yellow),
        _CircularStat(
            icon: Icons.edit,
            label: 'Writing',
            percentage: 0.15,
            color: Colors.red),
      ],
    );
  }

  Widget _buildPodium() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _PodiumStep(rank: '2', height: 60, color: Color(0xFFC0C0C0)), // Plata
        SizedBox(width: 4),
        _PodiumStep(rank: '1', height: 90, color: Color(0xFFFFD700)), // Oro
        SizedBox(width: 4),
        _PodiumStep(rank: '3', height: 40, color: Color(0xFFCD7F32)), // Bronce
      ],
    );
  }

  Widget _buildRankedList() {
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: const [
        _RankedListItem(
            rank: 4, icon: Icons.image_outlined, title: 'Copywriting'),
        // --- ÍCONO CORREGIDO ---
        _RankedListItem(
            rank: 5, icon: Icons.Youtube_outlined, title: 'Questions'),
        _RankedListItem(
            rank: 5, icon: Icons.groups_outlined, title: 'Community Post'),
        _RankedListItem(
            rank: 6, icon: Icons.campaign_outlined, title: 'Public Speaking'),
      ],
    );
  }
}

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
                backgroundColor: Colors.white.withOpacity(0.2),
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
          color: Colors.white.withOpacity(0.1),
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
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Text('$rank',
              style: const TextStyle(color: Colors.white70, fontSize: 16)),
          const SizedBox(width: 16),
          CircleAvatar(
            backgroundColor: Colors.white.withOpacity(0.1),
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
