import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:media_kit/media_kit.dart';
import 'package:open_media_server_app/globals/auth_globals.dart';
import 'package:open_media_server_app/globals/platform_globals.dart';
import 'package:open_media_server_app/views/gallery.dart';
import 'package:open_media_server_app/globals/globals.dart';
import 'package:open_media_server_app/helpers/preferences.dart';
import 'package:open_media_server_app/views/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  MediaKit.ensureInitialized();

  await PlatformGlobals.setGlobals();

  args = args.map((arg) => arg.toLowerCase()).toList();
  if (args.contains('--kiosk')) {
    PlatformGlobals.isKiosk = true;
    PlatformGlobals.isTv = true;
  }
  if (args.contains('--tv')) {
    PlatformGlobals.isTv = true;
  }

  var prefs = await SharedPreferences.getInstance();
  Preferences.prefs = prefs;

  if (PlatformGlobals.isKiosk) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    if (Platform.isLinux) {
      try {
        await const MethodChannel('my_app/fullscreen').invokeMapMethod('enableFullscreen');
      } on PlatformException catch (e) 
      {
        log("Failed to enable fullscreen: '${e.message}'.");
      }
    }
  }
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
      home: LoginView(widget: const Gallery()),
    );
  }
}
