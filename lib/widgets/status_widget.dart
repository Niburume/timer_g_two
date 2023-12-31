import 'package:flutter/material.dart';

class StatusW extends StatefulWidget {
  const StatusW({Key? key}) : super(key: key);

  @override
  State<StatusW> createState() => _StatusWState();
}

double animationValue = 0;
bool isIconHidden = true;
bool isAnimationComplete = false;

class _StatusWState extends State<StatusW> {
  void showIcon() {
    setState(() {
      isAnimationComplete = true;
      isIconHidden = false;
    });
    Future.delayed(const Duration(milliseconds: 100), () {
      animationValue = 0;
      isIconHidden = true;
      isAnimationComplete = false;
      Navigator.pop(context);
    });
  }

  void animateCircle() {
    if (!isAnimationComplete) {
      Future.delayed(const Duration(milliseconds: 10), () {
        animationValue += 0.05;
        if (animationValue >= 1) showIcon();
// Here you can write your code

        setState(() {
          // Here you can write your code for open new view
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!isAnimationComplete) animateCircle();
    return Dialog(
      child: SizedBox(
        height: 300 * animationValue,
        width: 300 * animationValue,
        child: Stack(
          alignment: Alignment.center,
          fit: StackFit.expand,
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: CircularProgressIndicator(
                strokeWidth: 10,
                value: animationValue,
                backgroundColor: Colors.blueGrey,
                color: Colors.greenAccent,
              ),
            ),
            Icon(
              Icons.done_outline,
              size: 100 * animationValue,
              color: isAnimationComplete ? Colors.greenAccent : Colors.blueGrey,
            ),
          ],
        ),
      ),
    );
  }
}
