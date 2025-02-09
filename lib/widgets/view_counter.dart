import 'package:flutter/material.dart';

class ViewCounter extends StatelessWidget {
  const ViewCounter({super.key, required this.completions});

  final int completions;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 71, 131, 188),
        borderRadius: BorderRadius.all(Radius.elliptical(290, 300)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.check_circle,
            color: Color.fromARGB(234, 255, 255, 255),
            size: 17.0,
          ),
          const SizedBox(width: 4.0),
          Text(
            '$completions',
            style: const TextStyle(
              fontSize: 13.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              backgroundColor: Colors.transparent,
            ),
          ),
        ],
      ),
    );
  }
}
