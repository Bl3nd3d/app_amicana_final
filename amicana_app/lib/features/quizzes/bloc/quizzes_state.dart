part of 'quizzes_bloc.dart';

@immutable
abstract class QuizzesState {}

class QuizzesInitial extends QuizzesState {}

class QuizzesLoading extends QuizzesState {}

class QuizzesLoaded extends QuizzesState {
  final List<Quiz> quizzes;
  QuizzesLoaded({required this.quizzes});
}

class QuizzesError extends QuizzesState {
  final String message;
  QuizzesError({required this.message});
}
