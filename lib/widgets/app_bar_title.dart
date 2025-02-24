import 'package:flutter/material.dart';
import 'package:open_media_server_app/globals/globals.dart';

class AppBarTitle extends StatelessWidget {
  const AppBarTitle({
    super.key,
    required this.screenWidth,
  });

  final double screenWidth;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: FittedBox(
        child: Row(
          children: [
            const Image(
              image: AssetImage('assets/AppImage/myapp.png'),
              height: 60,
            ),
            Text(screenWidth > 300 ? Globals.Title : ''),
          ],
        ),
      ),
    );
  }
}
