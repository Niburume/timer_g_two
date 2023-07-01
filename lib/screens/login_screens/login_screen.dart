import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:timerg/components/login_textfield.dart';
import 'package:timerg/components/general_button.dart';
import 'package:timerg/constants/constants.dart';
import 'package:timerg/helpers/helper_UI.dart';
import '../../components/square_tile.dart';

class LogInScreen extends StatefulWidget {
  final Function()? onTap;
  const LogInScreen({super.key, required this.onTap});

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                verticalSpace(0.05, context),
                Icon(
                  Icons.lock,
                  size: height * 0.1,
                ),
                verticalSpace(0.05, context),
                const Text(tgreetingText),
                verticalSpace(0.025, context),
                LoginTextfield(
                  controller: emailController,
                  hintText: tNickname,
                  obscureText: false,
                ),
                LoginTextfield(
                  controller: passwordController,
                  hintText: tPassword,
                  obscureText: true,
                ),
                Text(
                  'Forgot password?',
                ),
                Icon(
                  Icons.lock,
                  size: height * 0.03,
                ),
                verticalSpace(0.025, context),
                GeneralButton(
                  onTap: signUserIn,
                  title: 'Sign Up',
                ),
                verticalSpace(0.025, context),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          'Or continue with',
                          style: TextStyle(
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ),
                      ),
                    ],
                  ),
                ),
                verticalSpace(0.05, context),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SquareTile(
                        imagePath: 'assets/images/apple_logo2.png'),
                    horizontalSpace(0.05, context),
                    const SquareTile(
                        imagePath: 'assets/images/google_logo.jpg'),
                  ],
                ),
                verticalSpace(0.025, context),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Not a member?'),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        'Register now',
                        style: TextStyle(color: Colors.blueGrey),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void signUserIn() async {
    showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });

    // try sign in
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      print(e.code);
      if (e.code == 'invalid-email') {
        showErrorMessage('Invalid email');
      } else if (e.code == 'user-not-found') {
        showErrorMessage('User not found');
      } else if (e.code == 'wrong-password') {
        showErrorMessage('Wrong password');
      }
    }
  }

  // error message to user
  void showErrorMessage(String errorMessage) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              errorMessage,
              style: const TextStyle(color: Colors.white),
            ),
          );
        });
  }

  void userNotFoundMessage() {
    showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            title: Text('User not found'),
          );
        });
  }

  void wrongPasswordMessage() {
    showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            title: Text('Wrong password'),
          );
        });
  }
}
