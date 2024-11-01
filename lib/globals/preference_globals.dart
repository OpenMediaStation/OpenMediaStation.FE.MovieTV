import 'package:open_media_server_app/helpers/preferences.dart';

class PreferenceGlobals {
    static String BaseUrl = Preferences.prefs!.getString("BaseUrl")!;
}