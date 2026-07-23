import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:amicana_app/core/models/progress_model.dart';
import 'package:amicana_app/features/library/services/progress_service.dart';

part 'progress_event.dart';
part 'progress_state.dart';

class ProgressBloc extends Bloc<ProgressEvent, ProgressState> {
  final ProgressService _progressService;

  ProgressBloc({required ProgressService progressService})
      : _progressService = progressService,
        super(ProgressInitial()) {
    on<LoadProgress>(_onLoadProgress);
  }

  void _onLoadProgress(LoadProgress event, Emitter<ProgressState> emit) async {
    emit(ProgressLoading());
    try {
      final progress = await _progressService.getProgress();
      emit(ProgressLoaded(progress));
    } catch (e) {
      emit(ProgressError(e.toString()));
    }
  }
}
