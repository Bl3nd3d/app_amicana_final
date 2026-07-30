import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:amicana_app/features/search/bloc/search_cubit.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SearchCubit()..loadContent(),
      child: const _SearchView(),
    );
  }
}

class _SearchView extends StatefulWidget {
  const _SearchView();

  @override
  State<_SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<_SearchView> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A183C),
      appBar: AppBar(
        title: const Text('Search'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/library'),
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.3,
              child: Image.asset('assets/images/fondo_app.webp', fit: BoxFit.cover),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    controller: _controller,
                    autofocus: true,
                    style: const TextStyle(color: Colors.white),
                    onChanged: (value) => context.read<SearchCubit>().search(value),
                    decoration: InputDecoration(
                      hintText: 'Buscar libros, capítulos o trivias...',
                      hintStyle: const TextStyle(color: Colors.white38),
                      prefixIcon: const Icon(Icons.search, color: Colors.white70),
                      suffixIcon: ValueListenableBuilder(
                        valueListenable: _controller,
                        builder: (context, value, _) => value.text.isEmpty
                            ? const SizedBox.shrink()
                            : IconButton(
                                icon: const Icon(Icons.clear, color: Colors.white70),
                                onPressed: () {
                                  _controller.clear();
                                  context.read<SearchCubit>().search('');
                                },
                              ),
                      ),
                      filled: true,
                      fillColor: Colors.white.withValues(alpha: 0.08),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: BlocBuilder<SearchCubit, SearchState>(
                    builder: (context, state) {
                      if (state.loading) {
                        return const Center(
                            child: CircularProgressIndicator(color: Colors.white));
                      }
                      if (state.error != null) {
                        return Center(
                            child: Text(state.error!,
                                style: const TextStyle(color: Colors.white70)));
                      }
                      if (!state.hasQuery) {
                        return Center(
                          child: Text('Escribí algo para empezar a buscar',
                              style: TextStyle(color: Colors.white.withValues(alpha: 0.5))),
                        );
                      }

                      final books = state.matchingBooks;
                      final chapters = state.matchingChapters;
                      final quizzes = state.matchingQuizzes;

                      if (books.isEmpty && chapters.isEmpty && quizzes.isEmpty) {
                        return Center(
                          child: Text('No encontramos resultados para "${state.query}"',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white.withValues(alpha: 0.6))),
                        );
                      }

                      return ListView(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        children: [
                          if (books.isNotEmpty)
                            _ResultSection(
                              title: 'Libros',
                              children: books.map((book) {
                                return _ResultTile(
                                  icon: Icons.book,
                                  title: book.title,
                                  subtitle: book.author,
                                  onTap: () => context.push('/books/${book.id}'),
                                );
                              }).toList(),
                            ),
                          if (chapters.isNotEmpty)
                            _ResultSection(
                              title: 'Capítulos',
                              children: chapters.map((r) {
                                return _ResultTile(
                                  icon: Icons.menu_book_outlined,
                                  title: r.chapter.title,
                                  subtitle: r.book.title,
                                  onTap: () => context.push(
                                    '/books/${r.book.id}/chapter/${r.chapter.id}',
                                    extra: {'book': r.book, 'chapter': r.chapter},
                                  ),
                                );
                              }).toList(),
                            ),
                          if (quizzes.isNotEmpty)
                            _ResultSection(
                              title: 'Trivias',
                              children: quizzes.map((quiz) {
                                final now = DateTime.now();
                                final isActive = now.isAfter(quiz.startDate) &&
                                    now.isBefore(quiz.endDate);
                                return _ResultTile(
                                  icon: Icons.quiz,
                                  title: quiz.title,
                                  subtitle: isActive ? quiz.category : '${quiz.category} · no disponible',
                                  onTap: isActive
                                      ? () => context.go('/quizzes/quiz/${quiz.id}',
                                          extra: quiz)
                                      : () {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(
                                                content: Text(
                                                    'Esta trivia no está activa ahora mismo.')),
                                          );
                                        },
                                );
                              }).toList(),
                            ),
                          const SizedBox(height: 24),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ResultSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _ResultSection({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Text(title, style: const TextStyle(color: Colors.white54, fontSize: 12)),
        const SizedBox(height: 8),
        ...children,
      ],
    );
  }
}

class _ResultTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ResultTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.white70),
        title: Text(title,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
        subtitle: Text(subtitle, style: const TextStyle(color: Colors.white54)),
        onTap: onTap,
      ),
    );
  }
}
