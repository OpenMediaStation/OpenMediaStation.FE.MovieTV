import 'package:flutter/material.dart';

class ViewCounter extends StatelessWidget {
  const ViewCounter({
    super.key,
    required this.completions,
    this.scaleFactor = 1,
  });

  final int completions;
  final double scaleFactor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
          8 * scaleFactor, 4 * scaleFactor, 8 * scaleFactor, 4 * scaleFactor),
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 71, 131, 188),
        borderRadius: BorderRadius.all(Radius.elliptical(290, 300)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.check_circle,
            color: const Color.fromARGB(234, 255, 255, 255),
            size: 17.0 * scaleFactor,
          ),
          const SizedBox(width: 4.0),
          Text(
            '$completions',
            style: TextStyle(
              fontSize: 13.0 * scaleFactor,
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
