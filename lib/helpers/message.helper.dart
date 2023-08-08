import 'package:flutter/material.dart';

void showMessageCallAPI(BuildContext context,
    {required String message, required bool success}) {
  final snackBar = SnackBar(
    content: Text(
      message,
      style: const TextStyle(color: Colors.white),
    ),
    backgroundColor: success ? Colors.blue : Colors.red,
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
