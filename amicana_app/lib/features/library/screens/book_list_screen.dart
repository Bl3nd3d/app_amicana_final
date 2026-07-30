import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:amicana_app/features/library/bloc/library_bloc.dart';
import 'package:amicana_app/features/library/widgets/book_card.dart';
import 'package:amicana_app/features/quizzes/bloc/quizzes_bloc.dart';
import 'package:amicana_app/features/quizzes/models/quiz_model.dart';
import 'package:amicana_app/features/auth/bloc/auth_bloc.dart';
import 'package:amicana_app/core/widgets/bookmark_button.dart';

class BookListScreen extends StatelessWidget {
  final String? category;
  const BookListScreen({super.key, this.category});

  @override
  Widget build(BuildContext context) {
    final hasCategory = category != null && category!.trim().isNotEmpty;

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => LibraryBloc()
            ..add(hasCategory
                ? FetchBooksByCategory(category: category!)
                : FetchBooks()),
        ),
        // Solo hace falta la lista de trivias cuando estamos filtrando por
        // categoría (ej. Grammar); en 'Biblioteca Digital' (sin categoría)
        // no se piden.
        if (hasCategory)
          BlocProvider(create: (context) => QuizzesBloc()..add(FetchQuizzes())),
      ],
      child: Scaffold(
        backgroundColor: const Color(0xFF0A183C),
        appBar: AppBar(
          title: Text(hasCategory ? category! : 'Biblioteca Digital'),
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
                child: Image.asset('assets/images/fondo_app.webp',
                    fit: BoxFit.cover),
              ),
            ),
            ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                _buildBooksSection(context, hasCategory),
                if (hasCategory) ...[
                  const SizedBox(height: 32),
                  _buildQuizzesSection(context),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBooksSection(BuildContext context, bool hasCategory) {
    return BlocBuilder<LibraryBloc, LibraryState>(
      builder: (context, state) {
        if (state is LibraryLoading || state is LibraryInitial) {
          return const Center(
              child: Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: CircularProgressIndicator(),
          ));
        }
        if (state is LibraryLoaded) {
          if (state.books.isEmpty) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Text(
                hasCategory
                    ? 'Todavía no hay libros en la categoría "$category".'
                    : 'No hay libros disponibles.',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white70),
              ),
            );
          }
          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16.0,
              mainAxisSpacing: 16.0,
              childAspectRatio: 0.65,
            ),
            itemCount: state.books.length,
            itemBuilder: (context, index) {
              final book = state.books[index];
              return BookCard(book: book);
            },
          );
        }
        if (state is LibraryError) {
          return Center(
              child: Text(state.message,
                  style: const TextStyle(color: Colors.white)));
        }
        return const Center(
            child: Text('Algo salió mal.', style: TextStyle(color: Colors.white)));
      },
    );
  }

  Widget _buildQuizzesSection(BuildContext context) {
    return BlocBuilder<QuizzesBloc, QuizzesState>(
      builder: (context, state) {
        if (state is QuizzesLoading || state is QuizzesInitial) {
          return const Center(
              child: Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: CircularProgressIndicator(),
          ));
        }
        if (state is QuizzesError) {
          return Text(state.message, style: const TextStyle(color: Colors.white70));
        }
        if (state is QuizzesLoaded) {
          final quizzes =
              state.quizzes.where((q) => q.category == category).toList();
          if (quizzes.isEmpty) return const SizedBox.shrink();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Trivias',
                  style: TextStyle(
                      color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              ...quizzes.map((quiz) => _CategoryQuizTile(quiz: quiz)),
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}

class _CategoryQuizTile extends StatelessWidget {
  final Quiz quiz;
  const _CategoryQuizTile({required this.quiz});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final bool isActive = now.isAfter(quiz.startDate) && now.isBefore(quiz.endDate);
    final bool isFinished = now.isAfter(quiz.endDate);

    String statusText;
    Color statusColor;
    if (isActive) {
      statusText = 'Activa';
      statusColor = Colors.greenAccent;
    } else if (isFinished) {
      statusText = 'Finalizada';
      statusColor = Colors.redAccent;
    } else {
      statusText = 'Próximamente';
      statusColor = Colors.orangeAccent;
    }

    final authState = context.watch<AuthBloc>().state;

    return Card(
      color: Colors.white.withValues(alpha: 0.1),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(Icons.quiz, color: Theme.of(context).primaryColor),
        title: Text(quiz.title,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        subtitle: Text(quiz.description, style: const TextStyle(color: Colors.white70)),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Chip(
              label: Text(statusText),
              backgroundColor: statusColor.withValues(alpha: 0.2),
              labelStyle: TextStyle(
                  color: statusColor, fontWeight: FontWeight.bold, fontSize: 12),
            ),
            if (authState is AuthSuccess)
              BookmarkButton.quiz(userId: authState.user.id, quizId: quiz.id),
          ],
        ),
        onTap: isActive
            ? () => context.go('/quizzes/quiz/${quiz.id}', extra: quiz)
            : null,
        enabled: isActive,
      ),
    );
  }
}
