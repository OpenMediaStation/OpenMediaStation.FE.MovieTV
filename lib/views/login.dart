import 'package:flutter/material.dart';
import 'package:open_media_server_app/apis/auth_info_api.dart';
import 'package:open_media_server_app/auth/login_manager.dart';
import 'package:open_media_server_app/globals/globals.dart';
import 'package:open_media_server_app/helpers/preferences.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key, required this.widget});

  final Widget widget;

  @override
  Widget build(BuildContext context) {
    Preferences.prefs!.setString("BaseUrl", "");

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        surfaceTintColor: Colors.transparent,
        title: Text(Globals.Title),
      ),
      body: FutureBuilder(
        future: authenticate(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          return widget;
        },
      ),
    );
  }

  Future authenticate(BuildContext context) async {
    AuthInfoApi authInfoApi = AuthInfoApi();
    var info = await authInfoApi.getAuthInfo();

    LoginManager loginManager = LoginManager(info);

    var token = await loginManager.login(info, context);
  }
}
