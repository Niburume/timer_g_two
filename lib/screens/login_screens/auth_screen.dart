import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:timerg/screens/login_screens/login_or_register_screen.dart';
import 'package:timerg/screens/main_screen.dart';

import '../../nav_bar/nav_bar.dart';

class AuthScreen extends StatelessWidget {
  static const routeName = 'auth_screen';

  const AuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // return const MainScreen();
            return const CustomBottomBar();
          } else {
            return const LoginOrRegisterPage();
          }
        },
      ),
    );
  }
}
