import 'package:flutter/material.dart';

class TimerProvider with ChangeNotifier {
  bool autoMode = false;

  void switchAutoMode() {
    autoMode = !autoMode;
    notifyListeners();
  }
}
