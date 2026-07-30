import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:amicana_app/features/auth/bloc/auth_bloc.dart';
import 'package:amicana_app/core/services/bookmark_service.dart';
import 'package:amicana_app/features/library/models/book_model.dart';
import 'package:amicana_app/core/models/chapter_model.dart';
import 'package:amicana_app/features/library/services/library_service.dart';
import 'package:amicana_app/features/quizzes/models/quiz_model.dart';
import 'package:amicana_app/core/services/quiz_service.dart';

class SavedScreen extends StatefulWidget {
  const SavedScreen({super.key});

  @override
  State<SavedScreen> createState() => _SavedScreenState();
}

class _SavedScreenState extends State<SavedScreen> {
  final _libraryService = LibraryService();
  final _quizService = QuizService();
  final _bookmarkService = BookmarkService();
  List<Book>? _allBooks;
  List<Quiz>? _allQuizzes;
  String? _loadError;
  bool _openingQuiz = false;

  @override
  void initState() {
    super.initState();
    _loadContent();
  }

  Future<void> _loadContent() async {
    try {
      final results = await Future.wait([
        _libraryService.getBooks(),
        _quizService.getQuizzes(),
      ]);
      if (mounted) {
        setState(() {
          _allBooks = results[0] as List<Book>;
          _allQuizzes = results[1] as List<Quiz>;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _loadError = 'No se pudo cargar tu contenido guardado.');
      }
    }
  }

  Future<void> _openQuiz(Quiz quiz) async {
    setState(() => _openingQuiz = true);
    try {
      final questions = await _quizService.getQuestionsForQuiz(quiz.id);
      if (!mounted) return;
      context.go('/quizzes/quiz/${quiz.id}', extra: quiz.copyWith(questions: questions));
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No se pudo abrir la trivia: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _openingQuiz = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthBloc>().state;
    final userId = authState is AuthSuccess ? authState.user.id : null;

    return Scaffold(
      backgroundColor: const Color(0xFF0A183C),
      appBar: AppBar(
        title: const Text('Saved'),
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
          if (userId == null)
            const Center(
              child: Text('Iniciá sesión para ver tu contenido guardado.',
                  style: TextStyle(color: Colors.white70)),
            )
          else if (_loadError != null)
            Center(child: Text(_loadError!, style: const TextStyle(color: Colors.white70)))
          else if (_allBooks == null || _allQuizzes == null)
            const Center(child: CircularProgressIndicator(color: Colors.white))
          else
            StreamBuilder<Map<String, dynamic>?>(
              stream: _bookmarkService.watchUser(userId).map((doc) => doc.data()),
              builder: (context, snapshot) {
                final data = snapshot.data;
                final savedBookIds = List<String>.from(data?['savedBookIds'] ?? []);
                final savedChapterIds = List<String>.from(data?['savedChapterIds'] ?? []);
                final savedQuizIds = List<String>.from(data?['savedQuizIds'] ?? []);

                final savedBooks =
                    _allBooks!.where((b) => savedBookIds.contains(b.id)).toList();
                final savedQuizzes =
                    _allQuizzes!.where((q) => savedQuizIds.contains(q.id)).toList();

                final savedChapters = <(Book, Chapter)>[];
                for (final book in _allBooks!) {
                  for (final chapter in book.chapters) {
                    if (savedChapterIds.contains(
                        BookmarkService.chapterCompositeId(book.id, chapter.id))) {
                      savedChapters.add((book, chapter));
                    }
                  }
                }

                if (savedBooks.isEmpty && savedChapters.isEmpty && savedQuizzes.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.bookmark_border,
                              size: 64, color: Colors.white.withValues(alpha: 0.4)),
                          const SizedBox(height: 16),
                          const Text('Todavía no guardaste nada',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600)),
                          const SizedBox(height: 8),
                          Text(
                            'Tocá el ícono de guardado en un libro, capítulo o trivia para tenerlo acá.',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white.withValues(alpha: 0.6)),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return Stack(
                  children: [
                    ListView(
                      padding: const EdgeInsets.all(16.0),
                      children: [
                        if (savedBooks.isNotEmpty) ...[
                          const Text('Libros guardados',
                              style: TextStyle(color: Colors.white54, fontSize: 12)),
                          const SizedBox(height: 8),
                          ...savedBooks.map((book) => _SavedTile(
                                icon: Icons.book,
                                title: book.title,
                                subtitle: book.author,
                                onTap: () => context.push('/books/${book.id}'),
                                onUnsave: () =>
                                    _bookmarkService.setBookSaved(userId, book.id, false),
                              )),
                          const SizedBox(height: 20),
                        ],
                        if (savedChapters.isNotEmpty) ...[
                          const Text('Capítulos guardados',
                              style: TextStyle(color: Colors.white54, fontSize: 12)),
                          const SizedBox(height: 8),
                          ...savedChapters.map((entry) {
                            final (book, chapter) = entry;
                            return _SavedTile(
                              icon: Icons.menu_book_outlined,
                              title: chapter.title,
                              subtitle: book.title,
                              onTap: () => context.push(
                                '/books/${book.id}/chapter/${chapter.id}',
                                extra: {'book': book, 'chapter': chapter},
                              ),
                              onUnsave: () => _bookmarkService.setChapterSaved(
                                  userId, book.id, chapter.id, false),
                            );
                          }),
                          const SizedBox(height: 20),
                        ],
                        if (savedQuizzes.isNotEmpty) ...[
                          const Text('Trivias guardadas',
                              style: TextStyle(color: Colors.white54, fontSize: 12)),
                          const SizedBox(height: 8),
                          ...savedQuizzes.map((quiz) => _SavedTile(
                                icon: Icons.quiz,
                                title: quiz.title,
                                subtitle: quiz.category,
                                onTap: () => _openQuiz(quiz),
                                onUnsave: () =>
                                    _bookmarkService.setQuizSaved(userId, quiz.id, false),
                              )),
                        ],
                      ],
                    ),
                    if (_openingQuiz)
                      Container(
                        color: Colors.black45,
                        child:
                            const Center(child: CircularProgressIndicator(color: Colors.white)),
                      ),
                  ],
                );
              },
            ),
        ],
      ),
    );
  }
}

class _SavedTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final VoidCallback onUnsave;

  const _SavedTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    required this.onUnsave,
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
        trailing: IconButton(
          icon: const Icon(Icons.bookmark, color: Colors.amber),
          tooltip: 'Quitar de guardados',
          onPressed: onUnsave,
        ),
        onTap: onTap,
      ),
    );
  }
}
