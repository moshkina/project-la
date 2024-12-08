import 'package:shared_preferences/shared_preferences.dart';

class AppDatastoreHolder {
  static late SharedPreferences _prefs;

  static const _searchNameKey = 'SEARCH_NAME_KEY';

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static String? get searchName => _prefs.getString(_searchNameKey);

  static Future<void> saveSearchName(String searchName) async {
    await _prefs.setString(_searchNameKey, searchName);
  }

  static Future<void> dropSearchName() async {
    await _prefs.remove(_searchNameKey);
  }
}
