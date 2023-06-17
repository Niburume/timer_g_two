import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timerg/controllers/timer/timer_cubit.dart';
import 'package:timerg/screens/choose_project_screen.dart';

import '../controllers/data/data_cubit.dart';

class TimerScreen extends StatefulWidget {
  static const routeName = 'timer_screen';
  const TimerScreen({super.key});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Timer'),
      ),
      body: BlocBuilder<TimerCubit, TimerState>(
        builder: (context, state) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextButton(
                  child:
                      Text(state.currentProject?.projectName ?? 'Set project'),
                  onPressed: () {
                    Navigator.pushNamed(context, ChooseProjectScreen.routeName);
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('00:00:00'),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Stack(
                    children: [
                      TextField(
                        controller: controller,
                        maxLines: 5,
                        decoration:
                            InputDecoration(border: OutlineInputBorder()),
                        onChanged: (value) {
                          context.read<TimerCubit>().onNoteChange(value);
                        },
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: Padding(
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
                      )
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
