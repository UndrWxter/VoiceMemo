import 'package:shared_preferences/shared_preferences.dart';

const String themeKey = 'theme_key';

Future<String> getThemeFromSharedPref() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString(themeKey) ?? 'light';
}

Future<void> setThemeInSharedPref(String themeText) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString(themeKey, themeText);
}
