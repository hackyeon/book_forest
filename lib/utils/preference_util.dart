
import 'package:shared_preferences/shared_preferences.dart';

const String KEY_LOGIN_EMAIL = "KEY_LOGIN_EMAIL";

Future<void> setString(String key, String value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString(key, value);
}

Future<String> getString(String key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String value = prefs.getString(key) ?? "";
  return value;
}