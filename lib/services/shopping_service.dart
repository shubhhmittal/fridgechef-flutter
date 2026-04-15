import 'package:shared_preferences/shared_preferences.dart';

class ShoppingService {
  static const _listKey    = 'shopping_list';
  static const _checkedKey = 'shopping_checked';

  static Future<List<String>> loadList() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_listKey) ?? [];
  }

  static Future<Set<String>> loadChecked() async {
    final prefs = await SharedPreferences.getInstance();
    return (prefs.getStringList(_checkedKey) ?? []).toSet();
  }

  static Future<void> saveList(List<String> items) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_listKey, items);
  }

  static Future<void> saveChecked(Set<String> checked) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_checkedKey, checked.toList());
  }
}
