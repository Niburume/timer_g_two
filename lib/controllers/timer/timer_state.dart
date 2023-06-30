part of 'timer_cubit.dart';

class TimerState extends Equatable {
  bool autoMode;
  bool isRunning;
  bool isAddButtonVisible;
  bool timeChangedManually;
  String hours;
  String minutes;
  String seconds;
  Project? currentProject;
  Duration duration;
  Timer? timer;
  DateTime currentDate;
  DateTime? startTime;
  DateTime? endTime;
  String? note;

  TimerState(
      {required this.autoMode,
      required this.isRunning,
      required this.isAddButtonVisible,
      required this.timeChangedManually,
      required this.hours,
      required this.minutes,
      required this.seconds,
      this.currentProject,
      required this.duration,
      this.timer,
      required this.currentDate,
      this.startTime,
      this.endTime,
      required this.note});

  factory TimerState.initial() => TimerState(
      autoMode: false,
      isRunning: false,
      isAddButtonVisible: false,
      timeChangedManually: false,
      hours: '00',
      minutes: '00',
      seconds: '00',
      duration: const Duration(),
      currentDate: DateTime.now(),
      startTime: null,
      endTime: null,
      note: null);

  @override
  List<Object?> get props => [
        autoMode,
        isRunning,
        isAddButtonVisible,
        timeChangedManually,
        hours,
        minutes,
        seconds,
        currentProject,
        duration,
        timer,
        currentDate,
        startTime,
        endTime,
        note
      ];

  TimerState copyWith({
    bool? autoMode,
    bool? isRunning,
    bool? isAddButtonVisible,
    bool? timeAddedManually,
    String? hours,
    String? minutes,
    String? seconds,
    Project? currentProject,
    Duration? duration,
    Timer? timer,
    DateTime? currentDate,
    DateTime? startTime,
    DateTime? endTime,
    String? note,
  }) {
    return TimerState(
      autoMode: autoMode ?? this.autoMode,
      isRunning: isRunning ?? this.isRunning,
      isAddButtonVisible: isAddButtonVisible ?? this.isAddButtonVisible,
      timeChangedManually: timeAddedManually ?? this.timeChangedManually,
      hours: hours ?? this.hours,
      minutes: minutes ?? this.minutes,
      seconds: seconds ?? this.seconds,
      currentProject: currentProject ?? this.currentProject,
      duration: duration ?? this.duration,
      timer: timer ?? this.timer,
      currentDate: currentDate ?? this.currentDate,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      note: note ?? this.note,
    );
  }
}
