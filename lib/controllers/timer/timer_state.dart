part of 'timer_cubit.dart';

class TimerState extends Equatable {
  bool autoMode;
  bool isRunning;
  bool isAddButtonVisible;
  Project? currentProject;
  Duration duration;
  Timer? timer;
  DateTime startTime;
  DateTime endTime;
  String? note;

  TimerState(
      {required this.autoMode,
      required this.isRunning,
      required this.isAddButtonVisible,
      this.currentProject,
      required this.duration,
      this.timer,
      required this.startTime,
      required this.endTime,
      required this.note});

  factory TimerState.initial() => TimerState(
      autoMode: false,
      isRunning: false,
      isAddButtonVisible: false,
      duration: const Duration(),
      startTime: DateTime.now(),
      endTime: DateTime.now(),
      note: null);

  @override
  List<Object?> get props => [
        autoMode,
        isRunning,
        isAddButtonVisible,
        currentProject,
        duration,
        timer,
        startTime,
        endTime,
        note
      ];

  TimerState copyWith({
    bool? autoMode,
    bool? isRunning,
    bool? isAddButtonVisible,
    Project? currentProject,
    Duration? duration,
    Timer? timer,
    DateTime? startTime,
    DateTime? endTime,
    String? note,
  }) {
    return TimerState(
      autoMode: autoMode ?? this.autoMode,
      isRunning: isRunning ?? this.isRunning,
      isAddButtonVisible: isAddButtonVisible ?? this.isAddButtonVisible,
      currentProject: currentProject ?? this.currentProject,
      duration: duration ?? this.duration,
      timer: timer ?? this.timer,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      note: note ?? this.note,
    );
  }
}
