import 'package:flutter/material.dart';
import 'package:open_media_server_app/helpers/preferences.dart';
import 'package:open_media_server_app/views/gallery.dart';
import 'package:open_media_server_app/views/login.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        // title: AppBarTitle(screenWidth: MediaQuery.of(context).size.width),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "User",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  await logout(context);
                },
                child: const Text("Log out"),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future logout(BuildContext context) async {
    await Preferences.prefs?.clear();

    if (context.mounted) {
      await Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => LoginView(widget: const Gallery()),
        ),
        (route) => false, // This removes all previous routes
      );
    } else {
      throw Exception("Context wasn't mounted correctly!");
    }
  }
}
