import 'package:flutter/foundation.dart';
import 'models/ingredient.dart';
import 'models/recipe.dart';
import 'logic/matcher.dart';
import 'services/pantry_service.dart';
import 'services/saved_service.dart';
import 'services/shopping_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AppState extends ChangeNotifier {
  // ── Data ──────────────────────────────────────────────────────────────────
  List<Ingredient> ingredients = [];
  List<Recipe> recipes = [];

  Future<void> fetchIngredients() async {
    final snapshot =
      await FirebaseFirestore.instance.collection('ingredients').get();

    ingredients = snapshot.docs.map((doc) {
      return Ingredient(
        id: doc['id'],
        name: doc['name'],
        category: doc['category'],
        emoji: doc['emoji'],
      );
    }).toList();
    notifyListeners();
  }

  Future<void> fetchRecipes() async {
    final snapshot =
      await FirebaseFirestore.instance.collection('recipes').get();

    recipes = snapshot.docs.map((doc) {
      return Recipe(
        id: doc['id'],
        name: doc['name'],
        ingredients: List<String>.from(doc['ingredients']),
        steps: List<String>.from(doc['steps']),
        cookTime: doc.data().containsKey('cookTime') ? doc['cookTime'] : 20,
        servings: doc.data().containsKey('servings') ? doc['servings'] : 2,
        cuisine: doc.data().containsKey('cuisine') ? doc['cuisine'] : 'Unknown',
        difficulty: doc.data().containsKey('difficulty') ? doc['difficulty'] : 'Easy',
        isVeg: doc.data().containsKey('isVeg') ? doc['isVeg'] : true,
      );
    }).toList();

    notifyListeners();
  }

  // ── Pantry ────────────────────────────────────────────────────────────────
  Set<String> _pantry = {};
  Set<String> get pantry => _pantry;

  void toggleIngredient(String id) {
    if (_pantry.contains(id)) {
      _pantry = {..._pantry}..remove(id);
    } else {
      _pantry = {..._pantry, id};
    }
    PantryService.save(_pantry);
    notifyListeners();
  }

  // ── Matched recipes ───────────────────────────────────────────────────────
  List<MatchedRecipe> get matchedRecipes =>
      RecipeMatcher.match(recipes: recipes, pantry: _pantry);

  // ── Saved ─────────────────────────────────────────────────────────────────
  Set<String> _saved = {};
  Set<String> get saved => _saved;

  void toggleSaved(String id) {
    if (_saved.contains(id)) {
      _saved = {..._saved}..remove(id);
    } else {
      _saved = {..._saved, id};
    }
    SavedService.save(_saved);
    notifyListeners();
  }

  bool isSaved(String id) => _saved.contains(id);

  List<MatchedRecipe> get savedRecipes =>
      matchedRecipes.where((m) => _saved.contains(m.recipe.id)).toList();

  // ── Shopping list ─────────────────────────────────────────────────────────
  List<String> _shoppingList = [];
  Set<String>  _shoppingChecked = {};

  List<String> get shoppingList     => _shoppingList;
  Set<String>  get shoppingChecked  => _shoppingChecked;

  void addToShopping(List<String> items) {
    for (final item in items) {
      if (!_shoppingList.contains(item)) _shoppingList.add(item);
    }
    ShoppingService.saveList(_shoppingList);
    notifyListeners();
  }

  void removeFromShopping(String item) {
    _shoppingList.remove(item);
    _shoppingChecked.remove(item);
    ShoppingService.saveList(_shoppingList);
    ShoppingService.saveChecked(_shoppingChecked);
    notifyListeners();
  }

  void toggleShoppingCheck(String item) {
    if (_shoppingChecked.contains(item)) {
      _shoppingChecked = {..._shoppingChecked}..remove(item);
    } else {
      _shoppingChecked = {..._shoppingChecked, item};
    }
    ShoppingService.saveChecked(_shoppingChecked);
    notifyListeners();
  }

  void clearCheckedShopping() {
    _shoppingList.removeWhere((i) => _shoppingChecked.contains(i));
    _shoppingChecked = {};
    ShoppingService.saveList(_shoppingList);
    ShoppingService.saveChecked(_shoppingChecked);
    notifyListeners();
  }

  // ── Init ──────────────────────────────────────────────────────────────────
  Future<void> init() async {
    _pantry          = await PantryService.load();
    _saved           = await SavedService.load();
    _shoppingList    = await ShoppingService.loadList();
    _shoppingChecked = await ShoppingService.loadChecked();

    await fetchIngredients(); 
    await fetchRecipes(); 
     
    notifyListeners();
  }

  // ── Helpers ───────────────────────────────────────────────────────────────
  Ingredient? ingredientById(String id) {
    try {
      return ingredients.firstWhere((i) => i.id == id);
    } catch (_) {
      return null;
    }
  }
}
