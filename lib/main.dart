import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:open_media_server_app/globals/auth_globals.dart';
import 'package:open_media_server_app/globals/platform_globals.dart';
import 'package:open_media_server_app/views/gallery.dart';
import 'package:open_media_server_app/globals/globals.dart';
import 'package:open_media_server_app/helpers/preferences.dart';
import 'package:open_media_server_app/views/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MediaKit.ensureInitialized();

  await PlatformGlobals.setGlobals();

  var prefs = await SharedPreferences.getInstance();
  Preferences.prefs = prefs;

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateRoute: (settings) {
        // For authentication in web
        if (settings.name?.contains("code") ?? false) {
          AuthGlobals.appLoginCodeRoute = settings.name;
        }

        return null;
      },
      title: Globals.Title,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const LoginView(widget: Gallery()),
    );
  }
}
