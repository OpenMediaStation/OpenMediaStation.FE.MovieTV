import 'package:flutter/material.dart';
import 'package:open_media_server_app/apis/auth_info_api.dart';
import 'package:open_media_server_app/auth/login_manager.dart';
import 'package:open_media_server_app/globals/auth_globals.dart';
import 'package:open_media_server_app/globals/globals.dart';
import 'package:open_media_server_app/helpers/preferences.dart';
import 'package:open_media_server_app/views/gallery.dart';

class LoginView extends StatelessWidget {
  LoginView({super.key, required this.widget});

  final Widget widget;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final domainController = TextEditingController();
  var displayMessage = false;

  @override
  Widget build(BuildContext context) {
    if (Preferences.prefs?.getString("BaseUrl") != null) {
      return FutureBuilder(
        future: authenticate(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "🫤",
                  style: TextStyle(
                      color: Colors.white,
                      decoration: TextDecoration.none,
                      fontSize: 60),
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Looks like \n that's not working...",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.blueGrey,
                      decoration: TextDecoration.none,
                      fontSize: 30,
                    ),
                  ),
                ),
                //Text('Error: ${snapshot.error}'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton.icon(
                        onPressed: () async => await Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    LoginView(widget: const Gallery()))),
                        label: const Text("Retry Login"),
                        icon: const Icon(Icons.refresh),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          await Preferences.prefs?.remove("BaseUrl");
                          await Preferences.prefs?.remove("AccessToken");
                          await Preferences.prefs?.remove("RefreshToken");
                          await Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      LoginView(widget: const Gallery())));
                        },
                        label: const Text("Change URL"),
                        icon: const Icon(Icons.edit),
                      ),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () => {showDialog(context: context, builder: (BuildContext context){
                    return Dialog(
                      insetPadding: const EdgeInsets.all(20),
                      shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(10)),
                      
                      child: SizedBox(width: 300, height: 300, child: SingleChildScrollView(padding: const EdgeInsets.all(8), scrollDirection: Axis.vertical , child: Text('Error: ${snapshot.error}' ,textWidthBasis: TextWidthBasis.parent, softWrap: true,)))
                    );
                  })},
                  style: const ButtonStyle(
                      backgroundColor: WidgetStateColor.transparent,
                      enableFeedback: false),
                  child: const Text("what happened?"),
                ),
                SingleChildScrollView(scrollDirection: Axis.vertical , child: Text(displayMessage ? 'Error: ${snapshot.error}' : ''))
              ],
            ));
          }

          return widget;
        },
      );
    }

    var focusNode = FocusNode();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        surfaceTintColor: Colors.transparent,
        title: Text(Globals.Title),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextFormField(
                focusNode: focusNode,
                keyboardType: TextInputType.url,
                controller: domainController,
                onFieldSubmitted: (value) async { await validateAndAuthenticate(context, focusNode);
                },
                decoration: InputDecoration(
                  hintText: 'Host',
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 16.0,
                    horizontal: 16.0,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(
                      color: Colors.grey[400]!,
                      width: 1.5,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: const BorderSide(
                      color: Colors.blue,
                      width: 2.0,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(
                      color: Colors.grey[400]!,
                      width: 1.5,
                    ),
                  ),
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }

                  if (!value.contains("http://") &&
                      !value.contains("https://")) {
                    return 'You need to specify the host in this format\nExample: https://example.com';
                  }

                  return null;
                },
              ),
              const SizedBox(
                height: 16,
              ),
              SizedBox(
                width: double.infinity,
                height: 40,
                child: ElevatedButton(
                  onPressed: () async {
                    await validateAndAuthenticate(context, focusNode);
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                    ),
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                    ),
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                  ),
                  child: const Text("Connect"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future validateAndAuthenticate(BuildContext context, FocusNode focusNode)async {
    focusNode.nextFocus();
    if(_formKey.currentState!.validate()){
      await Preferences.prefs!.setString("BaseUrl", domainController.text);
      await authenticate(context);
    }
    else{
      focusNode.requestFocus();
    }
  }

  Future authenticate(BuildContext context) async {
    var refreshToken = Preferences.prefs?.getString("RefreshToken");
    var accessToken = Preferences.prefs?.getString("AccessToken");

    AuthInfoApi authInfoApi = AuthInfoApi();
    var info = await authInfoApi.getAuthInfo();
    AuthGlobals.authInfo = info;

    LoginManager loginManager = LoginManager(info);

    if (refreshToken != null && accessToken != null) {
      var token = await loginManager.refreshAsync(info);

      if (token == null || token.isEmpty) {
        token = await loginManager.login(info, context);
      }
    } else {
      var token = await loginManager.login(info, context);
    }

    if (context.mounted){
      await Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => widget
        ),
      );
    }else
    {
      throw Exception("Context wasn't mounted correctly!");
    }
  }
}
