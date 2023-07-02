import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timerg/controllers/settings/settings_cubit.dart';
import 'package:timerg/controllers/timer/timer_cubit.dart';

import '../widgets/settings_card.dart';

class SettingsScreen extends StatefulWidget {
  static const routeName = 'settings_screen';
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        final cubit = context.read<SettingsCubit>();
        return Scaffold(
          appBar: AppBar(
            title: Text('Settings'),
          ),
          body: ListView(children: [
            SettingsCard(
              text: 'Auto geoposition',
              value: context.watch<TimerCubit>().state.autoMode,
              onTap: () {
                context.read<TimerCubit>().switchAutoMode();
                setState(() {});
              },
            ),
            // Card(
            //   child: Padding(
            //     padding:
            //         const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            //     child: Row(
            //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //       children: [
            //         Text('widget.text'),
            //         Switch(
            //           value: state.autoMode,
            //           onChanged: (value) {
            //             cubit.switchAutoMode();
            //             setState(() {});
            //           },
            //         ),
            //       ],
            //     ),
            //   ),
            // )
          ]),
        );
      },
    );
  }
}
