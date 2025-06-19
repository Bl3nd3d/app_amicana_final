import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:amicana_app/features/quizzes/models/quiz_model.dart';

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

  void _onAnswerSelected(int? value) {
    setState(() {
      _selectedAnswers[_currentQuestionIndex] = value!;
    });
  }

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
    return Scaffold(
      backgroundColor: const Color(0xFF0A183C),
      body: _quizFinished ? _buildResultsScreen() : _buildQuizScreen(),
    );
  }

  Widget _buildQuizScreen() {
    final currentQuestion = widget.quiz.questions[_currentQuestionIndex];
    final questionCount = widget.quiz.questions.length;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text(widget.quiz.title, style: const TextStyle(fontSize: 18)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4.0),
          child: LinearProgressIndicator(
            value: (_currentQuestionIndex + 1) / questionCount,
            backgroundColor: Colors.white.withOpacity(0.2),
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.blueAccent),
          ),
        ),
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
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Pregunta ${_currentQuestionIndex + 1} de $questionCount',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(color: Colors.white)),
                const SizedBox(height: 16),
                Text(currentQuestion.text,
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(color: Colors.white)),
                const SizedBox(height: 24),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: List.generate(currentQuestion.options.length,
                          (index) {
                        return Card(
                          color:
                              _selectedAnswers[_currentQuestionIndex] == index
                                  ? Colors.blue.withOpacity(0.3)
                                  : Colors.white.withOpacity(0.1),
                          child: RadioListTile<int>(
                            title: Text(currentQuestion.options[index],
                                style: const TextStyle(color: Colors.white)),
                            value: index,
                            groupValue: _selectedAnswers[_currentQuestionIndex],
                            onChanged: _onAnswerSelected,
                            activeColor: Colors.lightBlueAccent,
                          ),
                        );
                      }),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (_currentQuestionIndex > 0)
                      TextButton.icon(
                          icon: const Icon(Icons.arrow_back),
                          onPressed: _previousQuestion,
                          label: const Text('Anterior')),
                    // Spacer para empujar el botón de siguiente a la derecha si no hay botón de anterior
                    if (_currentQuestionIndex == 0) const Spacer(),

                    if (_currentQuestionIndex < questionCount - 1)
                      ElevatedButton.icon(
                          icon: const Icon(Icons.arrow_forward),
                          onPressed: _nextQuestion,
                          label: const Text('Siguiente'))
                    else
                      ElevatedButton.icon(
                        icon: const Icon(Icons.check_circle),
                        onPressed: _finishQuiz,
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green),
                        label: const Text('Finalizar'),
                      ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- MÉTODO COMPLETO PARA LA PANTALLA DE RESULTADOS ---
  Widget _buildResultsScreen() {
    final score = _calculateScore();
    final total = widget.quiz.questions.length;
    final percentage = total > 0 ? (score / total) * 100 : 0;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Resultados'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false, // Oculta la flecha de "atrás"
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
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('¡Trivia Completada!',
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium
                        ?.copyWith(color: Colors.white)),
                const SizedBox(height: 24),
                Text('Tu Puntuación:',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(color: Colors.white70)),
                const SizedBox(height: 8),
                Text('$score / $total',
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        fontWeight: FontWeight.bold, color: Colors.white)),
                Text('(${percentage.toStringAsFixed(0)}%)',
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(color: Colors.lightBlueAccent)),
                const SizedBox(height: 48),
                ElevatedButton(
                  onPressed: () =>
                      context.go('/quizzes'), // Vuelve a la lista de trivias
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 16)),
                  child: const Text('Volver a la lista de trivias'),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
