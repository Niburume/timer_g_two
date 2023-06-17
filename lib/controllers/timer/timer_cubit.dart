import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../Models/project_model.dart';

part 'timer_state.dart';

class TimerCubit extends Cubit<TimerState> {
  TimerCubit() : super(TimerState.initial());

  void switchAutoMode() {
    emit(state.copyWith(autoMode: !state.autoMode));
  }

  void setCurrentProject(Project project) {
    emit(state.copyWith(currentProject: project));
  }

  void onNoteChange(String value) {
    emit(state.copyWith(note: value));
  }
}
