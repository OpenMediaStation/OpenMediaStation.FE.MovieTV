import 'package:flutter/material.dart';

class FileInfoBox extends StatelessWidget {
  final String text;

  const FileInfoBox(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(8),
          color: const Color.fromARGB(41, 158, 158, 158),
        ),
        child: Text(
          text,
          style: TextStyle(color: Colors.grey.shade300),
        ),
      ),
    );
  }
}