import 'package:flutter/material.dart';

enum ToastVariant { neutral, success, failed }

void showToast(
  BuildContext context,
  String message, {
  ToastVariant variant = ToastVariant.neutral,
}) {
  Color textColor;
  Color backgroundColor;

  // Define colors for each variant using .withValues()
  switch (variant) {
    case ToastVariant.success:
      textColor = const Color.fromARGB(255, 0, 163, 5);
      backgroundColor = const Color.fromARGB(255, 196, 255, 198);
      break;
    case ToastVariant.failed:
      textColor = const Color.fromARGB(255, 150, 0, 0);
      backgroundColor = const Color.fromARGB(255, 255, 199, 195).withValues(
        red: 1.0,
        green: 0.0,
        blue: 0.0,
        alpha: 0.7, // Washed red background with reduced opacity
      );
      break;
    case ToastVariant.neutral:
      textColor = Color(0xff350f0f);
      backgroundColor = Colors.yellow;
      break;
  }

  // Show the toast using a SnackBar
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message, style: TextStyle(color: textColor)),
      backgroundColor: backgroundColor,
      duration: Duration(seconds: 3),
    ),
  );
}
