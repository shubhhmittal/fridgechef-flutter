import '../models/recipe.dart';

class MatchedRecipe {
  final Recipe recipe;
  final List<String> missing;
  final List<String> have;

  const MatchedRecipe({
    required this.recipe,
    required this.missing,
    required this.have,
  });

  int get missingCount => missing.length;
  double get matchPercent =>
      recipe.ingredients.isEmpty ? 0 : have.length / recipe.ingredients.length;
}

class RecipeMatcher {
  static List<MatchedRecipe> match({
    required List<Recipe> recipes,
    required Set<String> pantry,
  }) {
    final results = recipes.map((r) {
      final have    = r.ingredients.where((i) => pantry.contains(i)).toList();
      final missing = r.ingredients.where((i) => !pantry.contains(i)).toList();
      return MatchedRecipe(recipe: r, have: have, missing: missing);
    }).toList();

    results.sort((a, b) {
      final cmp = a.missingCount.compareTo(b.missingCount);
      if (cmp != 0) return cmp;
      return b.matchPercent.compareTo(a.matchPercent);
    });

    return results;
  }
}
