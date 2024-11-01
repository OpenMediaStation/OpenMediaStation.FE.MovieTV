import 'package:flutter/material.dart';
import 'package:open_media_server_app/apis/auth_info_api.dart';
import 'package:open_media_server_app/auth/login_manager.dart';
import 'package:open_media_server_app/globals/globals.dart';
import 'package:open_media_server_app/helpers/preferences.dart';

class LoginView extends StatelessWidget {
  LoginView({super.key, required this.widget});

  final Widget widget;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final domainController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        surfaceTintColor: Colors.transparent,
        title: Text(Globals.Title),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: domainController,
              decoration: const InputDecoration(
                hintText: 'Domain',
              ),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  Preferences.prefs!
                      .setString("BaseUrl", domainController.text);

                  authenticate(context);
                }
              },
              child: const Text("Submit"),
            ),
          ],
        ),
      ),
    );
  }

  Future authenticate(BuildContext context) async {
    AuthInfoApi authInfoApi = AuthInfoApi();
    var info = await authInfoApi.getAuthInfo();

    LoginManager loginManager = LoginManager(info);

    var token = await loginManager.login(info, context);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            surfaceTintColor: Colors.transparent,
            title: Text(Globals.Title),
          ),
          body: widget,
        ),
      ),
    );
  }
}
