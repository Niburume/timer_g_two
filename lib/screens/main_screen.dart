import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timerg/controllers/settings/settings_cubit.dart';
import 'package:timerg/controllers/timer/timer_cubit.dart';
import 'package:timerg/helpers/geolocator.dart';

import 'package:timerg/helpers/notifications.dart';

import 'package:timerg/screens/projects_screen.dart';
import 'package:timerg/screens/set_project_screen.dart';
import 'package:timerg/screens/timer_screen.dart';

import '../nav_bar/nav_bar.dart';
import '../widgets/status_widget.dart';

class MainScreen extends StatefulWidget {
  static const routeName = 'main_screen';

  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
    GeoPosition.instance.determinePosition();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: signUserOut,
            icon: const Icon(
              Icons.logout,
            ),
          )
        ],
      ),
      body: Center(
        child: Column(
          children: [
            Text('Logged as ${user?.email} + ${user?.uid}'),
            ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, SetProjectScreen.routeName);
                },
                child: const Text('Set project screen')),
            ElevatedButton(
                onPressed: () async {
                  // startTimerNotification('time is started on', 'aaa:sss:ss');
                  stopTimerNotification(
                      title: 'title',
                      body: 'body',
                      onTap: () {
                        Navigator.pushNamed(context, ProjectScreen.routeName);
                      });
                },
                child: const Text('Show notification')),
            ElevatedButton(
                onPressed: () async {
                  context.read<SettingsCubit>().setTabBarIndex(1);
                  setState(() {});
                  // Navigator.of(context).push(
                  //     MaterialPageRoute(builder: (context) => TimerScreen()));
                  // Navigator.pushNamed(context, TimerScreen.routeName);
                },
                child: const Text('TimerScreen')),
            // ElevatedButton(
            //     onPressed: () async {}, child: const Text('Start background')),
            ElevatedButton(
                onPressed: () async {
                  showGeneralDialog(
                      barrierDismissible: true,
                      barrierLabel: 'Dismiss',
                      context: context,
                      transitionDuration: const Duration(milliseconds: 500),
                      pageBuilder: (_, __, ___) {
                        return const StatusW();
                      });
                  context.read<TimerCubit>().startTimer();
                },
                child: const Text('Show Success')),
            Expanded(child: Container()),
            // TimerW(),
            const SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }

  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }
}
