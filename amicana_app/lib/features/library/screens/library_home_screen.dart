import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:amicana_app/features/library/bloc/library_bloc.dart';
import 'package:amicana_app/features/library/widgets/book_card.dart';

class LibraryHomeScreen extends StatelessWidget {
  const LibraryHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LibraryBloc()..add(FetchBooks()),
      child: Scaffold(
        backgroundColor: const Color(0xFF0A183C),
        body: Stack(
          children: [
            Positioned.fill(
              child: Opacity(
                opacity: 0.3,
                child: Image.asset(
                  'assets/images/fondo_app.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            _buildMainContent(context),
          ],
        ),
        bottomNavigationBar: _buildBottomNavBar(context),
      ),
    );
  }

  Widget _buildMainContent(BuildContext context) {
    return CustomScrollView(
      slivers: [
        _buildSliverAppBar(context),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle(context, 'Explore topics'),
                const SizedBox(height: 16),
                _buildTopicsGrid(context),
                const SizedBox(height: 32),
                _buildSectionTitle(context, 'Suggestion for you'),
              ],
            ),
          ),
        ),
        _buildSuggestionList(),
      ],
    );
  }

  SliverAppBar _buildSliverAppBar(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    String userName = 'Guest';

    if (currentUser?.email != null && currentUser!.email!.isNotEmpty) {
      userName = currentUser.email!.split('@').first;
      userName = userName.substring(0, 1).toUpperCase() + userName.substring(1);
    } else if (currentUser?.displayName != null &&
        currentUser!.displayName!.isNotEmpty) {
      userName = currentUser.displayName!;
    }

    return SliverAppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      pinned: true,
      automaticallyImplyLeading: false,
      title: Text(
        'Welcome, $userName 👋',
        style:
            const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: CircleAvatar(
            backgroundImage: NetworkImage(
                currentUser?.photoURL ?? 'https://i.pravatar.cc/150'),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          'See more',
          style: TextStyle(color: Colors.blue[300], fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildTopicsGrid(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 2.5,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      children: [
        _TopicButton(
            title: 'Quiz',
            color: Colors.blue[200]!,
            icon: Icons.quiz,
            onTap: () => context.go('/quizzes')),
        _TopicButton(
            title: 'Books',
            color: Colors.blue[200]!,
            icon: Icons.book,
            onTap: () =>
                context.go('/books')), // Corregido para ir a la lista de libros
        _TopicButton(
            title: 'Grammar',
            color: Colors.green[200]!,
            icon: Icons.spellcheck),
        _TopicButton(
            title: 'Progress',
            color: Colors.purple[200]!,
            icon: Icons.show_chart,
            onTap: () => context.go('/progress')),
      ],
    );
  }

  Widget _buildSuggestionList() {
    return BlocBuilder<LibraryBloc, LibraryState>(
      builder: (context, state) {
        if (state is LibraryLoaded) {
          return SliverToBoxAdapter(
            child: SizedBox(
              height: 280,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: state.books.length,
                itemBuilder: (context, index) {
                  final book = state.books[index];
                  return Container(
                    width: 180,
                    margin: const EdgeInsets.only(right: 16),
                    child: BookCard(book: book),
                  );
                },
              ),
            ),
          );
        }
        return const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.all(32.0),
            child: Center(child: CircularProgressIndicator()),
          ),
        );
      },
    );
  }

  Widget _buildBottomNavBar(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: const Color(0xFF13274F),
      selectedItemColor: Colors.blue[300],
      unselectedItemColor: Colors.white54,
      currentIndex: 0,
      onTap: (index) {
        switch (index) {
          case 0: // Home
            context.go('/library');
            break;
          case 2: // Library (Podría ser la pantalla de lista de libros)
            context.go('/books');
            break;
          case 4: // Profile
            context.go('/profile');
            break;
        }
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
        BottomNavigationBarItem(
            icon: Icon(Icons.book_outlined), label: 'Library'),
        BottomNavigationBarItem(
            icon: Icon(Icons.bookmark_border), label: 'Saved'),
        BottomNavigationBarItem(
            icon: Icon(Icons.person_outline), label: 'Profile'),
      ],
    );
  }
}

class _TopicButton extends StatelessWidget {
  final String title;
  final Color color;
  final IconData icon;
  final VoidCallback? onTap;

  const _TopicButton(
      {super.key,
      required this.title,
      required this.color,
      required this.icon,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Colors.black54),
            ),
            const SizedBox(width: 12),
            Text(title,
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
