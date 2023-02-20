import 'package:flutter/material.dart';

class ConfirmationDialog extends StatelessWidget {
  final String title;
  final String content;
  final String cancelText;
  final String confirmText;
  final void Function() onConfirmed;

  const ConfirmationDialog({
    super.key,
    required this.title,
    required this.content,
    this.cancelText = 'No',
    this.confirmText = 'Yes',
    required this.onConfirmed
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple.shade300
          ),
          onPressed: () { Navigator.of(context).pop(); },
          child: Text(cancelText)
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
            onConfirmed();
          },
          child: Text(confirmText)
        ),
      ],
      backgroundColor: Colors.deepPurpleAccent.shade100,
    );
  }
}