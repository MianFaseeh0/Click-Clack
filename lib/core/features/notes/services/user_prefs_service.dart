import 'package:shared_preferences/shared_preferences.dart';

/// The one thing ClickClack needs from SharedPreferences: the user's
/// name, asked once and never again.
class UserPrefsService {
  static const _nameKey = 'user_name';

  static Future<String?> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_nameKey);
  }

  static Future<void> saveUserName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_nameKey, name.trim());
  }
}
