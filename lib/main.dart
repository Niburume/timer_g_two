import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:timerg/screens/choose_project_screen.dart';

import 'package:timerg/screens/login_screens/auth_screen.dart';
import 'package:timerg/screens/projects_screen.dart';
import 'package:timerg/screens/settings_screen.dart';
import 'package:timerg/screens/timer_screen.dart';

import 'controllers/data/data_cubit.dart';
import 'controllers/timer/timer_cubit.dart';
import 'firebase_options.dart';
import 'package:timerg/screens/main_screen.dart';
import 'package:timerg/screens/set_project_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    name: 'TimerG',
    options: DefaultFirebaseOptions.currentPlatform,
  );
  AwesomeNotifications().initialize(
      null, // icon notification
      [
        NotificationChannel(
            channelKey: 'basic_channel',
            channelName: 'Notification settings',
            channelDescription: 'Notification channel settings')
      ],
      channelGroups: [
        NotificationChannelGroup(
            channelGroupName: 'Basic group',
            channelGroupkey: 'basic_channel_group')
      ],
      debug: true);

  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(create: (BuildContext context) => DataCubit()),
      BlocProvider(create: (BuildContext context) => TimerCubit())
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.grey),
        useMaterial3: true,
      ),
      initialRoute: '/',
      // home: const MyHomePage(title: 'Flutter Demo Home Page'),
      routes: {
        '/': (context) => const AuthScreen(),
        MainScreen.routeName: (context) => const MainScreen(),

        SetProjectScreen.routeName: (context) => const SetProjectScreen(),
        ProjectScreen.routeName: (context) => const ProjectScreen(),
        ChooseProjectScreen.routeName: (context) => const ChooseProjectScreen(),
        TimerScreen.routeName: (context) => const TimerScreen(),
        SettingsScreen.routeName: (context) => const SettingsScreen(),

        // PinPositionScreen.routeName: (context) => PinPositionScreen,

        // SearchScreen.routeName: (context) => SearchScreen(),
      },
    );
  }
}
