import 'dart:async';

import 'package:bloc/bloc.dart';

import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timerg/screens/main_screen.dart';

import '../../Models/project_model.dart';
import '../../Models/time_entry_model.dart';
import '../../constants/constants.dart';
import '../../helpers/db_helper.dart';
import '../../helpers/geo_controller.dart';
import '../../screens/choose_project_screen.dart';
import '../../utilities/snack_bar.dart';
import '../../widgets/status_widget.dart';
import '../../widgets/timePicker.dart';
import '../data/data_cubit.dart';
import '../settings/settings_cubit.dart';

part 'timer_state.dart';

class TimerCubit extends Cubit<TimerState> {
  TimerCubit() : super(TimerState.initial());

  void setCurrentProject(Project project) {
    emit(state.copyWith(currentProject: project));
  }

  void onNoteChange(String value) {
    emit(state.copyWith(note: value));
  }

  void switchAutoMode() async {
    emit(state.copyWith(autoMode: !state.autoMode));
    if (state.autoMode) {
      startTracking();
    }
    if (!state.autoMode) {
      stopTimer();
    }
  }

  void addTime() {
    const addSeconds = 1;
    if (state.duration.inHours >= kMaxHours) stopTimer();
    final seconds = state.duration.inSeconds + addSeconds;
    emit(state.copyWith(duration: Duration(seconds: seconds)));
    timeFromDuration(state.duration);
    if (state.duration.inSeconds % 600 == 0) {
      startTracking();
    }
  }

  // region TimerActions
  void startTimer() {
    if (state.isRunning) return;
    emit(state.copyWith(endTime: null));
    emit(state.copyWith(startTime: DateTime.now()));
    state.timer = Timer.periodic(const Duration(seconds: 1), (_) => addTime());
    emit(state.copyWith(isRunning: true));
  }

  void stopTimer() {
    emit(state.copyWith(endTime: DateTime.now()));

    if (state.isRunning && state.duration != Duration.zero) {
      state.timer?.cancel();
      emit(state.copyWith(isRunning: false));
    }
  }

  void resetTimer() {
    emit(TimerState.initial());
  }
  // endregion

  // region Date And Time Actions
  void chooseDate(BuildContext context) {
    if (state.isRunning) return;
    showDatePicker(
      context: context,
      initialDate: state.currentDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      initialDatePickerMode: DatePickerMode.day,
    ).then((selectedDate) => {
          if (selectedDate != null)
            emit(state.copyWith(currentDate: selectedDate))
        });
  }

  void chooseTime(BuildContext context, DateTime? initialTime) {
    if (state.isRunning) return;

    showGeneralDialog(
        barrierDismissible:
            true, // Set to true to dismiss the dialog on tap outside
        barrierLabel: 'Dismiss',
        context: context,
        pageBuilder: (_, __, ___) {
          return TimePickerW(
            initialTime: initialTime,
            onTimeSelected: (DateTime selectedTime) {
              state.endTime = selectedTime;
              print(state.endTime);
              emit(state.copyWith(
                startTime:
                    state.currentDate.copyWith(hour: 0, minute: 0, second: 0),
                endTime: state.currentDate.copyWith(
                    hour: selectedTime.hour,
                    minute: selectedTime.minute,
                    second: 0),
                // duration: state.endTime!.difference(state.startTime),
                hours: state.endTime?.hour.toString(),
              ));
              emit(state.copyWith(
                  duration: state.endTime!.difference(state.startTime!),
                  timeAddedManually: true));
              timeFromDuration(state.duration);
            },
          );
        });
  }
  // endregion

  // region Tracking function

  Future<void> startTracking() async {
    emit(state.copyWith(isLoading: true));
    List<Project> projects = await DBHelper.instance.queryAllProjects();
    Project? foundProject = await GeoController.instance
        .checkDistanceOfProjectsToPosition(projects);

    if (foundProject != null) {
      startTimer();
      print('you are inside');
      emit(state.copyWith(currentProject: foundProject));
      emit(state.copyWith(isLoading: false));
      startTimer();
    } else if (foundProject == null &&
        state.isRunning &&
        state.duration != Duration.zero) {
      await saveTimeEntry();
      emit(state.copyWith(isLoading: false));
    }
  }
  // endregion

  void timeFromDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final String hours = twoDigits(duration.inHours.remainder(60));
    final String minutes = twoDigits(duration.inMinutes.remainder(60));
    final String seconds = twoDigits(duration.inSeconds.remainder(60));
    emit(state.copyWith(hours: hours, minutes: minutes, seconds: seconds));
  }

  Future<void> saveTimeEntry() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {}
    TimeEntry timeEntry = TimeEntry(
        userId: user?.uid ?? '',
        duration: state.duration.toString(),
        projectId: state.currentProject!.id!,
        timeFrom: state.startTime,
        timeTo: state.endTime,
        note: state.note,
        autoAdding: state.autoMode);

    await DBHelper.instance.addTime(timeEntry);
    emit(state.copyWith(isLoading: false));
    print('send');
    stopTimer();
    resetTimer();
  }
}
