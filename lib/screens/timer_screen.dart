import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timerg/components/general_button.dart';
import 'package:timerg/controllers/settings/settings_cubit.dart';
import 'package:timerg/controllers/timer/timer_cubit.dart';
import 'package:timerg/helpers/helper_UI.dart';

import 'package:timerg/widgets/time_card.dart';

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
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return BlocBuilder<TimerCubit, TimerState>(
      builder: (context, state) {
        final cubit = context.read<TimerCubit>();
        return Scaffold(
          appBar: AppBar(
            backgroundColor: state.isRunning
                ? Colors.greenAccent.shade100
                : Colors.blueGrey.shade100,
            title: const Text('Timer'),
          ),
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                state.isRunning
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
                          horizontalSpace(0.01, context),
                          TimeCard(
                            value: state.minutes,
                            units: 'minutes',
                            onTap: () {
                              cubit.chooseTime(context, state.currentDate);
                            },
                          ),
                          horizontalSpace(0.01, context),
                          context.watch<TimerCubit>().state.isRunning
                              ? TimeCard(
                                  value: state.seconds,
                                  units: 'seconds',
                                  onTap: () {
                                    cubit.chooseTime(
                                        context, state.currentDate);
                                  },
                                )
                              : Container()
                        ],
                      ),
                      verticalSpace(0.015, context),
                      GestureDetector(
                        onTap: () {
                          context.read<TimerCubit>().chooseDate(context);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            DateCard(
                              value: dateString(state.currentDate),
                              fontSizeValue: height * 0.015,
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
                                      fontSize: height * 0.013,
                                      color: Colors.grey.shade600),
                                )
                              : Text(
                                  '${state.startTime!.hour}:${state.startTime!.minute}',
                                  style: TextStyle(
                                      fontSize: height * 0.013,
                                      color: Colors.grey.shade600),
                                ),
                          Text(
                            'started',
                            style: TextStyle(
                                fontSize: height * 0.01,
                                color: Colors.grey.shade500),
                          )
                        ],
                      ),
                    ],
                  ),

                  // region SWITCH ANF PROJECT AND NOTE AND CAMERA
                  Column(
                    children: [
                      Column(
                        children: [
                          SizedBox(
                              height: height * 0.03,
                              width: height * 0.03,
                              child: state.isLoading
                                  ? CircularProgressIndicator()
                                  : Container()),
                          state.isLoading
                              ? Text('Determining position')
                              : Text('')
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Switch(
                              value: state.autoMode,
                              onChanged: (_) async {
                                cubit.switchAutoMode();
                              }),
                          horizontalSpace(0.015, context)
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8, right: 8),
                        child: GestureDetector(
                          onTap: () {
                            context.read<SettingsCubit>().setTabBarIndex(2);
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
                              maxLines: 2,
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
                                    icon: Icon(
                                      Icons.camera_alt_outlined,
                                      size: height * 0.04,
                                    )),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  // endregion a a
                  // region CHECK IN BTNs
                  if (state.currentProject == null && !state.autoMode)
                    GeneralButton(
                        onTap: () {
                          context.read<SettingsCubit>().setTabBarIndex(2);
                        },
                        title: 'Set project')
                  else if (state.autoMode && state.isRunning)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GeneralButton(
                            onTap: () {},
                            backgroundColor: Colors.transparent,
                            textColor: Colors.green,
                            title: 'Auto mode is on...')
                      ],
                    )
                  else if (!state.autoMode && state.duration == Duration.zero)
                    GeneralButton(
                        onTap: () {
                          cubit.startTimer();
                        },
                        backgroundColor: Colors.blueGrey,
                        title: 'Start timer')
                  else if (!state.autoMode && state.isRunning)
                    GeneralButton(
                        onTap: () {
                          cubit.stopTimer();
                        },
                        backgroundColor: Colors.blueGrey,
                        title: 'Stop timer')
                  else if (!state.autoMode &&
                      !state.isRunning &&
                      state.duration != Duration.zero)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: GeneralButton(
                              onTap: () {
                                cubit.startTimer();
                              },
                              backgroundColor: Colors.blueGrey,
                              title: 'Start'),
                        ),
                        Expanded(
                          child: GeneralButton(
                              onTap: () {
                                cubit.saveTimeEntry();
                              },
                              backgroundColor: Colors.green,
                              title: 'Send time'),
                        ),
                      ],
                    )
                  else
                    GeneralButton(
                        onTap: () {},
                        backgroundColor: Colors.transparent,
                        title: 'Is loading'),

                  verticalSpace(0.03, context)
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
