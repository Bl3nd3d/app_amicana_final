import 'package:equatable/equatable.dart';
import 'package:amicana_app/core/models/progress_model.dart';

abstract class ProgressState extends Equatable {
  const ProgressState();

  @override
  List<Object> get props => [];
}

class ProgressLoading extends ProgressState {}

class ProgressLoaded extends ProgressState {
  final Progress progress;

  const ProgressLoaded(this.progress);

  // Getter to get all category scores sorted from highest to lowest
  List<MapEntry<String, int>> get sortedCategoryStats {
    final entries = progress.categoryStats.entries.toList();
    // Sorts in descending order based on the score (the value)
    entries.sort((a, b) => b.value.compareTo(a.value));
    return entries;
  }

  @override
  List<Object> get props => [progress];
}

class ProgressError extends ProgressState {
  final String message;

  const ProgressError(this.message);

  @override
  List<Object> get props => [message];
}
