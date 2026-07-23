part of 'progress_bloc.dart';

abstract class ProgressEvent extends Equatable {
  const ProgressEvent();

  @override
  List<Object> get props => [];
}

class LoadProgress extends ProgressEvent {}
