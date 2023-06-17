import 'package:flutter/material.dart';

showSnackBar(
    {required BuildContext context,
    required String title,
    required String actionTitle,
    required Function onTap}) {
  final snackBar = SnackBar(
    content: Text(title),
    duration: const Duration(seconds: 3),
    action: SnackBarAction(
      label: actionTitle,
      onPressed: () {
        onTap();
      },
    ),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
