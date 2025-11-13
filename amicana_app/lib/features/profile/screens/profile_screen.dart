import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (mounted) setState(() {});
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

    // Datos simulados para las estadísticas
    const String coursesEnrolled = '12';
    const String averageScore = '50%';
    const String daysInLearning = '98';
    const String totalOfRings = '5';

    return Scaffold(
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
          ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            children: [
              Center(
                  child: _buildProfileHeader(
                      userName, userEmail, currentUser?.photoURL)),
              const SizedBox(height: 24),
              _buildStatsGrid(
                  coursesEnrolled, averageScore, daysInLearning, totalOfRings),
              const SizedBox(height: 24),
              _buildTabs(),
              _buildTabContent(),
              const SizedBox(height: 24),
            ],
          ),
        ],
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

  Widget _buildStatsGrid(
      String courses, String score, String days, String rings) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
                child: _StatCard(
                    icon: Icons.play_arrow,
                    value: courses,
                    label: 'Course Enrolled',
                    color: Colors.blue)),
            const SizedBox(width: 16),
            Expanded(
                child: _StatCard(
                    icon: Icons.flash_on,
                    value: score,
                    label: 'Average Score',
                    color: Colors.orange)),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
                child: _StatCard(
                    icon: Icons.calendar_today,
                    value: days,
                    label: 'Days in Learning',
                    color: Colors.green)),
            const SizedBox(width: 16),
            Expanded(
                child: _StatCard(
                    icon: Icons.star,
                    value: rings,
                    label: 'Total of Rings',
                    color: Colors.yellow)),
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
        color: Colors.white.withAlpha(50), // Uso de withAlpha
      ),
      tabs: const [
        Tab(text: 'In progress'),
        Tab(text: 'Upcoming'),
        Tab(text: 'Completed'),
      ],
    );
  }

  Widget _buildTabContent() {
    return SizedBox(
      height: 300,
      child: TabBarView(
        controller: _tabController,
        children: [
          _buildProgressList(),
          const Center(
              child: Text('No upcoming courses',
                  style: TextStyle(color: Colors.white70))),
          const Center(
              child: Text('No completed courses',
                  style: TextStyle(color: Colors.white70))),
        ],
      ),
    );
  }

  Widget _buildProgressList() {
    return ListView(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      children: const [
        _ProgressListItem(
            icon: Icons.school_outlined,
            title: 'STUDENT PROGRESS',
            date: 'August 5, 2023',
            progress: 34 / 120,
            progressText: '34/120',
            color: Colors.blue),
        _ProgressListItem(
            icon: Icons.edit_outlined,
            title: 'WRITING',
            date: 'August 3, 2023',
            progress: 45 / 99,
            progressText: '45/99',
            color: Colors.pink),
      ],
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
        color: Colors.white.withAlpha(25), // Uso de withAlpha
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor:
                color.withValues(alpha: 0.3),
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
  final String date;
  final double progress;
  final String progressText;
  final Color color;
  const _ProgressListItem(
      {required this.icon,
      required this.title,
      required this.date,
      required this.progress,
      required this.progressText,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(top: 16),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(25), // Uso de withAlpha
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                  Text(date,
                      style:
                          const TextStyle(color: Colors.white54, fontSize: 12)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(children: [
            Expanded(
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.white.withAlpha(50), // Uso de withAlpha
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
