// custom_progress_dialog.dart

import 'package:flutter/material.dart';

class CustomProgressDialog extends StatelessWidget {
  final String message;

  const CustomProgressDialog({required this.message});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircularProgressIndicator(),
            SizedBox(width: 16.0),
            Text(message),
          ],
        ),
      ),
    );
  }
}
