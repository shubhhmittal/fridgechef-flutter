import 'package:shared_preferences/shared_preferences.dart';

class SavedService {
  static const _key = 'saved_recipes';

  static Future<Set<String>> load() async {
    final prefs = await SharedPreferences.getInstance();
    return (prefs.getStringList(_key) ?? []).toSet();
  }

  static Future<void> save(Set<String> saved) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_key, saved.toList());
  }
}
