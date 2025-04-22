import 'package:flutter/material.dart';

class ResultDialog extends StatelessWidget {
  final String title;

  final String result;

  final VoidCallback? onClose;

  const ResultDialog({
    super.key,
    required this.title,
    required this.result,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(
        result,
        style: const TextStyle(fontSize: 18),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();

            if (onClose != null) onClose!();
          },
          child: const Text("OK"),
        ),
      ],
    );
  }
}
