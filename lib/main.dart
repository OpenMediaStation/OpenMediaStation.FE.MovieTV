import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:open_media_server_app/auth/login_manager.dart';
import 'package:open_media_server_app/gallery.dart';
import 'package:open_media_server_app/globals.dart';
import 'package:open_media_server_app/helpers/Preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MediaKit.ensureInitialized();
  Globals.isMobile = defaultTargetPlatform == TargetPlatform.iOS ||
      defaultTargetPlatform == TargetPlatform.android;

  if (defaultTargetPlatform == TargetPlatform.android) {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    Globals.isTv =
        androidInfo.systemFeatures.contains('android.software.leanback');
  }

  if (Globals.isTv) {
    Globals.isMobile = false;
  }

  if (Globals.isTv && defaultTargetPlatform == TargetPlatform.android) {
    Globals.isAndroidTv = true;
  }

  if (kIsWeb) {
    Globals.isWeb = true;
  }

  var prefs = await SharedPreferences.getInstance();
  Preferences.prefs = prefs;

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Globals.Title,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: HomePage(title: Globals.Title),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        surfaceTintColor: Colors.transparent,
        title: Text(title),
      ),
      body: FutureBuilder(
        future: authenticate(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          return const Gallery();
        },
      ),
    );
  }

  Future authenticate(BuildContext context) async {
    LoginManager loginManager = LoginManager();
    var token =
        await loginManager.login(Globals.ClientId, Globals.ClientSecret, context);
  }
}
