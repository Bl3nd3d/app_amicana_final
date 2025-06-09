import 'package:flutter/material.dart';
import '../models/quiz_model.dart';
// Aunque no lo usamos activamente para enviar datos, lo importamos por completitud.

class QuizPlayerScreen extends StatefulWidget {
  final Quiz quiz;
  const QuizPlayerScreen({super.key, required this.quiz});

  @override
  State<QuizPlayerScreen> createState() => _QuizPlayerScreenState();
}

class _QuizPlayerScreenState extends State<QuizPlayerScreen> {
  int _currentQuestionIndex = 0;
  final Map<int, int> _selectedAnswers = {};
  bool _quizFinished = false;

  void _nextQuestion() {
    if (_currentQuestionIndex < widget.quiz.questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
      });
    }
  }

  void _previousQuestion() {
    if (_currentQuestionIndex > 0) {
      setState(() {
        _currentQuestionIndex--;
      });
    }
  }

  void _finishQuiz() {
    // Aquí es donde crearías un objeto AnswerSubmission para enviarlo a tu backend.
    // final submission = AnswerSubmission(...);
    // api.submitQuiz(submission);

    setState(() {
      _quizFinished = true;
    });
  }

  int _calculateScore() {
    int score = 0;
    _selectedAnswers.forEach((questionIndex, answerIndex) {
      if (widget.quiz.questions[questionIndex].correctAnswerIndex ==
          answerIndex) {
        score++;
      }
    });
    return score;
  }

  @override
  Widget build(BuildContext context) {
    if (_quizFinished) {
      return _buildResultsScreen();
    }

    final currentQuestion = widget.quiz.questions[_currentQuestionIndex];
    final questionCount = widget.quiz.questions.length;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.quiz.title),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4.0),
          child: LinearProgressIndicator(
            value: (_currentQuestionIndex + 1) / questionCount,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Pregunta ${_currentQuestionIndex + 1} de $questionCount',
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            Text(currentQuestion.text,
                style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 24),
            ...List.generate(currentQuestion.options.length, (index) {
              return RadioListTile<int>(
                title: Text(currentQuestion.options[index]),
                value: index,
                groupValue: _selectedAnswers[_currentQuestionIndex],
                onChanged: (value) {
                  setState(() {
                    _selectedAnswers[_currentQuestionIndex] = value!;
                  });
                },
              );
            }),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (_currentQuestionIndex > 0)
                  ElevatedButton(
                      onPressed: _previousQuestion,
                      child: const Text('Anterior')),
                if (_currentQuestionIndex < questionCount - 1)
                  ElevatedButton(
                      onPressed: _nextQuestion, child: const Text('Siguiente'))
                else
                  ElevatedButton(
                    onPressed: _finishQuiz,
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    child: const Text('Finalizar'),
                  ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildResultsScreen() {
    final score = _calculateScore();
    final total = widget.quiz.questions.length;
    return Scaffold(
      appBar: AppBar(title: const Text('Resultados')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('¡Trivia Completada!',
                style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 24),
            Text('Tu Puntuación:',
                style: Theme.of(context).textTheme.titleLarge),
            Text('$score / $total',
                style: Theme.of(context)
                    .textTheme
                    .displayLarge
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Volver a la lista de trivias'),
            )
          ],
        ),
      ),
    );
  }
}
