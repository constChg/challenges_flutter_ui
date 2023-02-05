import 'package:flutter/material.dart';

class EUFeedback {
  static void showSnackBar(String message, BuildContext context,
      {SnackBarAction? snackBarAction}) {
    final snackBar = SnackBar(
      content: Text(message),
      action: snackBarAction,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
