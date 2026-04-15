import 'package:shared_preferences/shared_preferences.dart';

class PantryService {
  static const _key = 'pantry_items';

  static Future<Set<String>> load() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_key) ?? [];
    return list.toSet();
  }

  static Future<void> save(Set<String> pantry) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_key, pantry.toList());
  }
}
