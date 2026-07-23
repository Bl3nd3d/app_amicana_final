import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:amicana_app/core/models/progress_model.dart';
import 'package:amicana_app/core/services/progress_service.dart';
import 'package:amicana_app/features/profile/bloc/progress_event.dart';
import 'package:amicana_app/features/profile/bloc/progress_state.dart';

class ProgressBloc extends Bloc<ProgressEvent, ProgressState> {
  final ProgressService _progressService;
  
  ProgressBloc({required ProgressService progressService})
      : _progressService = progressService,
        super(ProgressLoading()) {
    on<LoadProgress>(_onLoadProgress);
  }

  Future<void> _onLoadProgress(
    LoadProgress event,
    Emitter<ProgressState> emit,
  ) async {
    emit(ProgressLoading());
    await emit.forEach<Progress>(
      _progressService.watchUserProgress(),
      onData: (progress) => ProgressLoaded(progress),
      onError: (error, stackTrace) => ProgressError('Failed to load progress: $error'),
    );
  }
}
