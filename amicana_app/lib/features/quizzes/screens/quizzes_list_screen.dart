import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/quizzes_bloc.dart';
import '../models/quiz_model.dart';

class QuizzesListScreen extends StatelessWidget {
  const QuizzesListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => QuizzesBloc()..add(FetchQuizzes()),
      child: Scaffold(
        appBar: AppBar(title: const Text('Trivias Académicas')),
        body: BlocBuilder<QuizzesBloc, QuizzesState>(
          builder: (context, state) {
            if (state is QuizzesLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is QuizzesLoaded) {
              return ListView.builder(
                itemCount: state.quizzes.length,
                itemBuilder: (context, index) {
                  final quiz = state.quizzes[index];
                  return _QuizListItem(quiz: quiz);
                },
              );
            }
            if (state is QuizzesError) {
              return Center(child: Text(state.message));
            }
            return const Center(child: Text('Cargando trivias...'));
          },
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
      statusColor = Colors.green;
    } else if (isFinished) {
      statusText = 'Finalizada';
      statusColor = Colors.red;
    } else {
      statusText = 'Próximamente';
      statusColor = Colors.orange;
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(quiz.title),
        subtitle: Text(quiz.description),
        leading: Icon(Icons.quiz, color: Theme.of(context).primaryColor),
        trailing: Chip(
          label: Text(statusText),
          backgroundColor: statusColor.withOpacity(0.2),
          labelStyle:
              TextStyle(color: statusColor, fontWeight: FontWeight.bold),
        ),
        onTap: isActive
            ? () => context.go('/quizzes/quiz/${quiz.id}', extra: quiz)
            : null,
      ),
    );
  }
}
