import 'dart:io';

import 'package:flutter/material.dart';

abstract class CustomDialog {
  static dynamic onBackPressed(context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Are you sure?'),
          content: const Text('Do you want to exit'),
          actions: <Widget>[
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Yes'),
              onPressed: () {
                exit(0);
              },
            )
          ],
        );
      },
    );
  }
}