import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:amicana_app/features/quizzes/bloc/quizzes_bloc.dart';
import 'package:amicana_app/features/quizzes/models/quiz_model.dart';

class QuizzesListScreen extends StatelessWidget {
  const QuizzesListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => QuizzesBloc()..add(FetchQuizzes()),
      child: Scaffold(
        backgroundColor: const Color(0xFF0A183C),
        appBar: AppBar(
          title: const Text('Trivias Académicas'),
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.go('/library'), // Botón para volver a Home
          ),
        ),
        body: Stack(
          children: [
            Positioned.fill(
              child: Opacity(
                opacity: 0.3,
                child: Image.asset('assets/images/fondo_app.png',
                    fit: BoxFit.cover),
              ),
            ),
            BlocBuilder<QuizzesBloc, QuizzesState>(
              builder: (context, state) {
                if (state is QuizzesLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is QuizzesLoaded) {
                  return ListView.builder(
                    padding: const EdgeInsets.all(8.0),
                    itemCount: state.quizzes.length,
                    itemBuilder: (context, index) {
                      final quiz = state.quizzes[index];
                      return _QuizListItem(quiz: quiz);
                    },
                  );
                }
                if (state is QuizzesError) {
                  return Center(
                      child: Text(state.message,
                          style: const TextStyle(color: Colors.white)));
                }
                return const Center(
                    child: Text('Cargando trivias...',
                        style: TextStyle(color: Colors.white)));
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _QuizListItem extends StatelessWidget {
  final Quiz quiz;
  const _QuizListItem({required this.quiz});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final bool isActive =
        now.isAfter(quiz.startDate) && now.isBefore(quiz.endDate);
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

    return Card(
      color: Colors.white.withOpacity(0.1),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: ListTile(
        title: Text(quiz.title,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold)),
        subtitle: Text(quiz.description,
            style: const TextStyle(color: Colors.white70)),
        leading: Icon(Icons.quiz, color: Theme.of(context).primaryColor),
        trailing: Chip(
          label: Text(statusText),
          backgroundColor: statusColor.withOpacity(0.2),
          labelStyle: TextStyle(
              color: statusColor, fontWeight: FontWeight.bold, fontSize: 12),
        ),
        onTap: isActive
            ? () => context.go('/quizzes/quiz/${quiz.id}', extra: quiz)
            : null,
        enabled: isActive,
      ),
    );
  }
}
