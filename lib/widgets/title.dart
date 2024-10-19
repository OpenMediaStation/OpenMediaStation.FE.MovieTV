import 'package:flutter/material.dart';

class TitleElement extends StatelessWidget {
  const TitleElement({super.key, required this.text});

  final String? text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text ?? "Title unknown",
      style: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
