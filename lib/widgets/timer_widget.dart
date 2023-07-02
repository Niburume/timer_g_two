import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timerg/Models/time_entry_model.dart';
import 'package:timerg/components/general_button.dart';
import 'package:timerg/controllers/timer/timer_cubit.dart';
import 'package:timerg/helpers/db_helper.dart';
import 'package:timerg/helpers/geo_controller.dart';
import 'package:timerg/helpers/notifications.dart';

import 'package:timerg/screens/choose_project_screen.dart';

import 'package:timerg/screens/main_screen.dart';
import 'package:timerg/screens/projects_screen.dart';

import 'package:timerg/widgets/confimation.dart';
import 'package:timerg/utilities/snack_bar.dart';
import 'package:timerg/widgets/timePicker.dart';

import '../Models/project_model.dart';
import '../constants/constants.dart';
import '../controllers/data/data_cubit.dart';
import 'package:intl/intl.dart';

enum Time { start, end, total }

class TimerW extends StatefulWidget with ChangeNotifier {
  TimerW({Key? key}) : super(key: key);

  @override
  State<TimerW> createState() => _TimerWState();
}

class _TimerWState extends State<TimerW> {
  List<Project> projects = [];

  String currentProjectName = 'Set a project';
  String currentUserId = '';
  Duration duration = const Duration();
  Timer? timer;
  bool isRunning = false;
  DateTime startTime = DateTime.now();
  DateTime endTime = DateTime.now();
  bool isButtonVisible = false;
  DateTime currentDate = DateTime.now();
  TextEditingController noteController = TextEditingController();

  String get dateString {
    String formattedDate = DateFormat('yyyy.MM.dd').format(currentDate);
    return formattedDate;
  }

  @override
  void initState() {
    // TODO: implement initState
    currentUserId = context.read<DataCubit>().state.currentUserId;

    super.initState();
    startTracking();
  }

  @override
  void didChangeDependencies() async {
    projects = context.read<DataCubit>().state.projects;

    super.didChangeDependencies();
  }

  void startTracking() async {
    if (context.read<TimerCubit>().state.autoMode) {
      Timer.periodic(tRequestFrequency, (Timer timer) async {
        if (projects.isEmpty) {
          print('empty');
        } else {
          // Get the current position
          Project? foundProject = await GeoController.instance
              .checkDistanceOfProjectsToPosition(projects);

          if (foundProject != null &&
              !isRunning &&
              context.read<TimerCubit>().state.autoMode) {
            context.read<DataCubit>().setCurrentProject(foundProject);
            setState(() {});
            startTimer();
            startTimerNotification(
                title:
                    'Time is started on ${context.read<DataCubit>().state.currentProject?.projectName}',
                body:
                    'Time is started today at ${startTime.hour} : ${startTime.minute}');
          } else if (foundProject == null && isRunning) {
            // timer.cancel();

            stopTimer();
            stopTimerNotification(
                title: 'Time is added',
                body:
                    'Time is started today at ${startTime.hour} : ${startTime.minute} and ended at ${endTime.hour} : ${endTime.minute}, total you have been working ${timeFromDurationHM(duration)} on $currentProjectName',
                onTap: () {
                  // TODO Go to the edit screen
                });
            // open notification
            saveTimeEntry();
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (context.watch<DataCubit>().state.currentProject?.projectName != null) {
      currentProjectName =
          context.watch<DataCubit>().state.currentProject!.projectName;
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: Switch(
            value: context.read<TimerCubit>().state.autoMode,
            onChanged: (_) {
              // context.read<TimerCubit>().switchAutoMode();
              startTracking();
              setState(() {});
            },
          ),
        ),
        buildTime(),
      ],
    );
  }

  Widget buildTime() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      margin: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.blueGrey, width: 1),
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(10)),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, ChooseProjectScreen.routeName);
              },
              child: Text(
                currentProjectName,
                maxLines: 2,
              ),
            ),
            const Divider(
              indent: 10,
              endIndent: 10,
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, ProjectScreen.routeName);
              },
              child: const Text(
                'SOME TAGS',
                maxLines: 2,
              ),
            ),
            const Divider(
              indent: 10,
              endIndent: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: TextField(
                controller: noteController,
                decoration: const InputDecoration(hintText: 'type a note here'),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  width: 10,
                ),
                Column(
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            chooseTime(Time.total, null);
                          },
                          child: Text(
                            timeFromDurationHM(duration),
                            style: const TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.w600,
                                color: Colors.blueGrey),
                          ),
                        ),
                        isRunning
                            ? Text(
                                timeFromDurationS(duration),
                                style: const TextStyle(
                                    fontSize: 40,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.blueGrey),
                              )
                            : Container()
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        chooseDate();
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: FittedBox(
                          fit: BoxFit.fitWidth,
                          child: Text(
                            '$dateString ${DateFormat.EEEE().format(currentDate)}',
                            style: TextStyle(
                                fontSize: 16, color: Colors.grey.shade600),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  width: 8,
                ),
                Expanded(child: Container()),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Column(
                      children: [
                        GestureDetector(
                          child: isRunning
                              ? timerButton(
                                  icon: Icons.pause,
                                  color: Colors.orange,
                                )
                              : timerButton(
                                  icon: Icons.play_arrow,
                                  color: Colors.greenAccent),
                          onTap: () {
                            if (isRunning) {
                              pauseTimer();
                            } else {
                              startTimer();
                            }
                          },
                        ),
                        GestureDetector(
                          onTap: () {
                            chooseTime(Time.start, startTime);
                          },
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Column(
                              children: [
                                (!isRunning && duration == Duration.zero)
                                    ? Text(
                                        '-//-',
                                        style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.grey.shade600),
                                      )
                                    : Text(
                                        '${startTime.hour}:${startTime.minute}',
                                        style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.grey.shade600),
                                      ),
                                Text(
                                  'start',
                                  style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.grey.shade500),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        GestureDetector(
                          child: timerButton(icon: Icons.stop),
                          onTap: () {
                            stopTimer();
                          },
                        ),
                        GestureDetector(
                          onTap: () {
                            chooseTime(Time.end, endTime);
                          },
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Column(
                              children: [
                                (!isRunning && duration != Duration.zero)
                                    ? Text(
                                        '${endTime.hour}:${endTime.minute}',
                                        style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.grey.shade600),
                                      )
                                    : Text(
                                        '-//-',
                                        style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.grey.shade600),
                                      ),
                                Text(
                                  'end',
                                  style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.grey.shade500),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      width: 25,
                    ),
                  ],
                )
              ],
            ),
            const Divider(
              indent: 20,
              endIndent: 20,
            ),
            SizedBox(
              height: 50,
              child: Visibility(
                  visible: isButtonVisible,
                  maintainSize: true,
                  maintainAnimation: true,
                  maintainState: true,
                  child: AnimatedOpacity(
                    opacity: isButtonVisible ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                    child: GeneralButton(
                      onTap: () {
                        if (currentProjectName == 'Set a project') {
                          showSnackBar(
                              context: context,
                              title: 'You have to set the project',
                              actionTitle: 'Set project',
                              onTap: () {
                                Navigator.pushNamed(
                                    context, ProjectScreen.routeName);
                              });

                          return;
                        }
                        showConfirmationDialog();
                      },
                      title: 'ADD TIME',
                      backgroundColor: Colors.greenAccent,
                      textColor: Colors.black,
                      padding: 2,
                    ),
                  )),
            )
          ],
        ),
      ),
    );
  }

  Widget buildTimeCard({required String time}) {
    return Container(
      child: Text(
        time,
        style: const TextStyle(
            fontWeight: FontWeight.bold, color: Colors.blueGrey, fontSize: 40),
      ),
    );
  }

  Widget timerButton({required IconData icon, Color? color}) {
    return Container(
      padding: const EdgeInsets.all(5),
      child: CircleAvatar(
        radius: 25,
        backgroundColor: Colors.blueGrey,
        child: Icon(
          icon,
          size: 40,
          color: color,
        ),
      ),
    );
  }

  void addTime() {
    const addSeconds = 1;

    setState(() {
      if (duration.inHours >= kMaxHours) stopTimer();
      final seconds = duration.inSeconds + addSeconds;
      duration = Duration(seconds: seconds);
    });
  }

  // region SAVE TIME ENTRY
  void saveTimeEntry() async {
    final project = context.read<DataCubit>().state.currentProject;

    TimeEntry timeEntry = TimeEntry(
        userId: currentUserId,
        duration: timeFromDurationHM(duration),
        projectId: project!.id!,
        timeFrom: startTime,
        timeTo: endTime,
        note: noteController.text,
        autoAdding: context.read<TimerCubit>().state.autoMode);

    String? entryId = await DBHelper.instance.addTime(timeEntry);
    if (entryId != null) {
      duration = const Duration();
    }
    isButtonVisible = false;

    Navigator.pop(context);
    Navigator.pushNamed(context, MainScreen.routeName);
  }

// endregion
  // region START/STOP/PAUSE TIMER
  void startTimer() {
    if (isRunning) return;
    startTime = DateTime.now();
    timer = Timer.periodic(const Duration(seconds: 1), (_) => addTime());
    isRunning = true;
    isButtonVisible = false;
  }

  void pauseTimer() {
    setState(() {
      timer?.cancel();
      isRunning = false;
      isButtonVisible = true;
      endTime = DateTime.now();
    });
  }

  void stopTimer() {
    if (context.read<TimerCubit>().state.autoMode && isRunning) {
      showSnackBar(
          context: context,
          title: 'Auto mode is on, do you want to disable it?',
          actionTitle: 'Disable auto',
          onTap: () {
            // context.read<TimerCubit>().switchAutoMode();
            stopTimer();
            setState(() {
              return;
            });
          });
    }
    endTime = DateTime.now();
    setState(() {
      if (duration != const Duration()) isButtonVisible = true;
      if (!isRunning && duration != Duration.zero) {
        print('dialog');
        showGeneralDialog(
            context: context,
            pageBuilder: (_, __, ___) {
              return ConfirmationDialog(
                  dataList: [
                    {
                      'Do you want to reset this time?':
                          timeFromDurationHM(duration)
                    }
                  ],
                  onOkTap: () {
                    duration = const Duration();
                    Navigator.pop(context);
                    isButtonVisible = false;
                    setState(() {});
                  },
                  okTitle: 'Reset');
            });
      }
    });
    timer?.cancel();
    isRunning = false;
  }
// endregion

  void showConfirmationDialog() {
    showGeneralDialog(
        transitionDuration: const Duration(milliseconds: 400),
        context: context,
        pageBuilder: (_, __, ___) {
          return ConfirmationDialog(
            dataList: [
              {'Project': currentProjectName},
              {'Time': timeFromDurationHM(duration)},
              const {'Tags': 'here some tag, and on'}
            ],
            onOkTap: saveTimeEntry,
            okTitle: 'add',
            noteTextFieldController: noteController,
          );
        });
  }

  void chooseDate() {
    showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      initialDatePickerMode: DatePickerMode.day,
    )
        .then((selectedDate) =>
            {if (selectedDate != null) currentDate = selectedDate})
        .then((value) => setState(() {}));
  }

  void chooseTime(Time timeToSet, DateTime? initialTime) {
    if (isRunning) return;

    if (timeToSet == Time.total) {
      initialTime = DateTime.now();
      initialTime = DateTime(
          initialTime.year,
          initialTime.month,
          initialTime.day,
          8,
          0,
          initialTime.second,
          initialTime.millisecond,
          initialTime.microsecond);
    } else {
      initialTime ??= startTime;
    }

    showGeneralDialog(
        barrierDismissible:
            true, // Set to true to dismiss the dialog on tap outside
        barrierLabel: 'Dismiss',
        context: context,
        pageBuilder: (_, __, ___) {
          return TimePickerW(
            onTimeSelected: (DateTime selectedTime) {
              if (timeToSet == Time.total) {
                startTime = DateTime(
                    selectedTime.year,
                    selectedTime.month,
                    selectedTime.day,
                    0,
                    0,
                    selectedTime.second,
                    selectedTime.millisecond,
                    selectedTime.microsecond);
                endTime = selectedTime;
              }

              if (timeToSet == Time.start) {
                startTime = selectedTime;
                if (startTime == endTime || startTime.isAfter(endTime)) {
                  endTime = startTime.add(const Duration(minutes: 5));
                }
              } else if (timeToSet == Time.end) {
                endTime = selectedTime;
                if (startTime.isAfter(endTime)) {
                  showSnackBar(
                      context: context,
                      title: 'End time have to be later then start time',
                      actionTitle: 'Set start',
                      onTap: () {
                        chooseTime(Time.start, DateTime.now());
                      });
                  endTime = startTime;
                }
              }
              calculateTotalTime();
              setState(() {});
            },
            initialTime: initialTime,
          );
        });
  }

  void calculateTotalTime() {}

  String timeFromDurationHM(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours.remainder(60));
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    // final seconds = twoDigits(duration.inSeconds.remainder(60));
    String timeString = '$hours:$minutes';

    return timeString;
  }

  String timeFromDurationS(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    String timeString = ':$seconds';

    return timeString;
  }
}
