import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timerg/components/general_button.dart';
import 'package:timerg/controllers/timer/timer_cubit.dart';
import 'package:timerg/controllers/timer_provider.dart';
import 'package:timerg/screens/choose_project_screen.dart';
import 'package:timerg/screens/projects_screen.dart';
import 'package:timerg/widgets/time_card.dart';

import '../controllers/data/data_cubit.dart';
import '../utilities/snack_bar.dart';
import '../widgets/status_widget.dart';

class TimerScreen extends StatefulWidget {
  static const routeName = 'timer_screen';

  const TimerScreen({super.key});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  TextEditingController controller = TextEditingController();

  String dateString(DateTime currentDate) {
    String date = DateFormat('yyyy.MM.dd').format(currentDate);
    String day = DateFormat.EEEE().format(currentDate);
    return '$date $day';
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimerCubit, TimerState>(
      builder: (context, state) {
        final cubit = TimerCubit();
        return Scaffold(
          appBar: AppBar(
            backgroundColor: context.watch<TimerCubit>().state.isRunning
                ? Colors.greenAccent.shade100
                : Colors.blueGrey.shade100,
            title: const Text('Timer'),
          ),
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                context.watch<TimerCubit>().state.isRunning
                    ? Colors.greenAccent.shade100
                    : Colors.blueGrey.shade100,
                Colors.grey.shade50,
              ], begin: Alignment.topLeft, end: Alignment.bottomCenter),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // region TIMER UI
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TimeCard(
                            value: state.hours,
                            units: 'hours',
                            onTap: () {
                              context
                                  .read<TimerCubit>()
                                  .chooseTime(context, state.currentDate);
                            },
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          TimeCard(
                            value: state.minutes,
                            units: 'minutes',
                            onTap: () {
                              context
                                  .read<TimerCubit>()
                                  .chooseTime(context, state.currentDate);
                            },
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          context.watch<TimerCubit>().state.isRunning
                              ? TimeCard(
                                  value: state.seconds,
                                  units: 'seconds',
                                  onTap: () {
                                    context
                                        .read<TimerCubit>()
                                        .chooseTime(context, state.currentDate);
                                  },
                                )
                              : Container()
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      GestureDetector(
                        onTap: () {
                          context.read<TimerCubit>().chooseDate(context);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            DateCard(
                              value: dateString(state.currentDate),
                              fontSizeValue: 15,
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                  // endregion

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          state.startTime == null
                              ? Text(
                                  '-//-',
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey.shade600),
                                )
                              : Text(
                                  '${state.startTime!.hour}:${state.startTime!.minute}',
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey.shade600),
                                ),
                          Text(
                            'started',
                            style: TextStyle(
                                fontSize: 10, color: Colors.grey.shade500),
                          )
                        ],
                      ),
                    ],
                  ),

                  // region PROJECT AND NOTE AND CAMERA
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8, right: 8),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                                context, ChooseProjectScreen.routeName);
                          },
                          child: Container(
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                      colors: [
                                        Colors.grey.shade300,
                                        Colors.blueGrey.shade200,
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomCenter),
                                  border: Border.all(),
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.blueGrey.shade100),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Text(
                                    state.currentProject?.projectName ??
                                        'Set project',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                ),
                              )),
                        ),
                      ),
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              controller: controller,
                              maxLines: 5,
                              decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.grey.shade400,
                                  border: OutlineInputBorder(),
                                  labelText: 'Note'),
                              onChanged: (value) {
                                context.read<TimerCubit>().onNoteChange(value);
                              },
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: IconButton(
                                    onPressed: () {
                                      print('camera');
                                    },
                                    icon: const Icon(
                                      Icons.camera_alt_outlined,
                                      size: 40,
                                    )),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  // endregion a a
                  // region CHECK IN BTN
                  GeneralButton(
                    onTap: () async {
                      state.isRunning
                          ? context.read<TimerCubit>().saveTimeEntry(context,
                              context.read<DataCubit>().state.currentUserId)
                          : context.read<TimerCubit>().startTimer();
                    },
                    title: state.isRunning
                        ? 'Check out'
                        : state.timeChangedManually
                            ? 'Check out'
                            : 'Check in',
                    padding: 15,
                    backgroundColor: context.watch<TimerCubit>().state.isRunning
                        ? Colors.greenAccent.shade100
                        : Colors.blueGrey,
                    textColor: context.watch<TimerCubit>().state.isRunning
                        ? Colors.blueGrey
                        : Colors.greenAccent.shade100,
                  ),
                  // endregion
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
