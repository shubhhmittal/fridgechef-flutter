import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../app_state.dart';
import '../logic/matcher.dart';
import '../theme.dart';

class RecipeDetailScreen extends StatelessWidget {
  final MatchedRecipe match;
  const RecipeDetailScreen({super.key, required this.match});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final recipe = match.recipe;
    final isSaved = state.isSaved(recipe.id);
    final canCook = match.missingCount == 0;

    return Scaffold(
      backgroundColor: FridgeColors.fridgeWhite,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 190,
            pinned: true,
            backgroundColor: FridgeColors.fridgeWhite,
            elevation: 0,
            scrolledUnderElevation: 0,
            leading: Padding(
              padding: const EdgeInsets.all(8),
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    shape: BoxShape.circle,
                    boxShadow: [BoxShadow(color: FridgeColors.inkNavy.withOpacity(0.1), blurRadius: 8)],
                  ),
                  child: const Icon(Icons.arrow_back_ios_new_rounded, size: 16, color: FridgeColors.inkNavy),
                ),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: GestureDetector(
                  onTap: () => state.toggleSaved(recipe.id),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 40, height: 40,
                    decoration: BoxDecoration(
                      color: isSaved ? FridgeColors.selectedAmber.withOpacity(0.15) : Colors.white.withOpacity(0.9),
                      shape: BoxShape.circle,
                      boxShadow: [BoxShadow(color: FridgeColors.inkNavy.withOpacity(0.1), blurRadius: 8)],
                    ),
                    child: Icon(
                      isSaved ? Icons.bookmark_rounded : Icons.bookmark_outline_rounded,
                      size: 20,
                      color: isSaved ? FridgeColors.selectedAmber : FridgeColors.inkNavy,
                    ),
                  ),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [FridgeColors.fridgeLight.withOpacity(0.25), FridgeColors.shelfGlass],
                  ),
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: Container(
                      width: 80, height: 80,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.85),
                        shape: BoxShape.circle,
                        boxShadow: [BoxShadow(color: FridgeColors.fridgeLight.withOpacity(0.3), blurRadius: 20, spreadRadius: 4)],
                      ),
                      child: Center(child: Text(recipe.isVeg ? '🥗' : '🍳', style: const TextStyle(fontSize: 38))),
                    ),
                  ),
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(recipe.name,
                          style: GoogleFonts.playfairDisplay(fontSize: 26, fontWeight: FontWeight.w700, color: FridgeColors.inkNavy)),
                      ),
                      const SizedBox(width: 8),
                      _VegDot(isVeg: recipe.isVeg),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Meta chips
                  Wrap(
                    spacing: 8, runSpacing: 6,
                    children: [
                      _DetailChip(icon: Icons.restaurant_rounded, label: recipe.cuisine),
                      _DetailChip(icon: Icons.timer_outlined, label: '${recipe.cookTime} min'),
                      _DetailChip(icon: Icons.people_outline_rounded, label: '${recipe.servings} servings'),
                      _DetailChip(icon: Icons.bar_chart_rounded, label: recipe.difficulty),
                    ],
                  ),

                  const SizedBox(height: 18),

                  // Cookability banner
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: canCook ? FridgeColors.haveGreen.withOpacity(0.1) : FridgeColors.missingRed.withOpacity(0.07),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: canCook ? FridgeColors.haveGreen.withOpacity(0.4) : FridgeColors.missingRed.withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          canCook ? Icons.check_circle_rounded : Icons.info_outline_rounded,
                          size: 18,
                          color: canCook ? FridgeColors.haveGreen : FridgeColors.missingRed,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            canCook
                                ? 'You have everything — ready to cook!'
                                : '${match.missingCount} ingredient${match.missingCount == 1 ? '' : 's'} missing',
                            style: GoogleFonts.dmSans(fontSize: 13, fontWeight: FontWeight.w600,
                              color: canCook ? FridgeColors.haveGreen : FridgeColors.missingRed),
                          ),
                        ),
                        if (!canCook)
                          GestureDetector(
                            onTap: () {
                              state.addToShopping(match.missing);
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text('Added ${match.missingCount} item${match.missingCount == 1 ? '' : 's'} to list',
                                  style: GoogleFonts.dmSans(fontSize: 13, color: Colors.white)),
                                backgroundColor: FridgeColors.inkNavy,
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                margin: const EdgeInsets.all(16),
                              ));
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(color: FridgeColors.missingRed, borderRadius: BorderRadius.circular(20)),
                              child: Text('Add to list', style: GoogleFonts.dmSans(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white)),
                            ),
                          ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Ingredients
                  Text('Ingredients', style: GoogleFonts.playfairDisplay(fontSize: 20, fontWeight: FontWeight.w700, color: FridgeColors.inkNavy)),
                  const SizedBox(height: 12),

                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: FridgeColors.divider),
                    ),
                    child: Column(
                      children: recipe.ingredients.asMap().entries.map((entry) {
                        final i = entry.key;
                        final ingId = entry.value;
                        final have = match.have.contains(ingId);
                        final ing = state.ingredientById(ingId);
                        final isLast = i == recipe.ingredients.length - 1;
                        return Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
                              child: Row(
                                children: [
                                  Container(
                                    width: 28, height: 28,
                                    decoration: BoxDecoration(
                                      color: have ? FridgeColors.haveGreen.withOpacity(0.12) : FridgeColors.missingRed.withOpacity(0.08),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      have ? Icons.check_rounded : Icons.close_rounded,
                                      size: 14,
                                      color: have ? FridgeColors.haveGreen : FridgeColors.missingRed,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  if (ing != null) ...[
                                    Text(ing.emoji, style: const TextStyle(fontSize: 16)),
                                    const SizedBox(width: 8),
                                  ],
                                  Expanded(
                                    child: Text(
                                      ing?.name ?? ingId,
                                      style: GoogleFonts.dmSans(
                                        fontSize: 14, fontWeight: FontWeight.w500,
                                        color: have ? FridgeColors.inkNavy : FridgeColors.inkMid,
                                        decoration: have ? null : TextDecoration.none,
                                      ),
                                    ),
                                  ),
                                  if (ing != null)
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: FridgeColors.categoryTint(ing.category),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(ing.category,
                                        style: GoogleFonts.dmSans(fontSize: 9, fontWeight: FontWeight.w600,
                                          color: FridgeColors.categoryAccent(ing.category))),
                                    ),
                                ],
                              ),
                            ),
                            if (!isLast) Divider(height: 1, color: FridgeColors.divider, indent: 16, endIndent: 16),
                          ],
                        );
                      }).toList(),
                    ),
                  ),

                  const SizedBox(height: 28),

                  // Steps
                  Text('Instructions', style: GoogleFonts.playfairDisplay(fontSize: 20, fontWeight: FontWeight.w700, color: FridgeColors.inkNavy)),
                  const SizedBox(height: 12),

                  ...recipe.steps.asMap().entries.map((entry) {
                    final step = entry.key + 1;
                    final text = entry.value;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 28, height: 28,
                            decoration: BoxDecoration(
                              color: FridgeColors.fridgeLight,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text('$step',
                                style: GoogleFonts.dmSans(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white)),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: FridgeColors.divider),
                              ),
                              child: Text(text,
                                style: GoogleFonts.dmSans(fontSize: 14, color: FridgeColors.inkNavy, height: 1.5)),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _VegDot extends StatelessWidget {
  final bool isVeg;
  const _VegDot({required this.isVeg});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 22, height: 22,
      decoration: BoxDecoration(
        border: Border.all(color: isVeg ? FridgeColors.vegGreen : FridgeColors.nonVegRed, width: 1.5),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Center(
        child: Container(
          width: 10, height: 10,
          decoration: BoxDecoration(
            color: isVeg ? FridgeColors.vegGreen : FridgeColors.nonVegRed,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}

class _DetailChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _DetailChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: FridgeColors.shelfGlass,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: FridgeColors.shelfEdge),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: FridgeColors.inkMid),
          const SizedBox(width: 4),
          Text(label, style: GoogleFonts.dmSans(fontSize: 11, fontWeight: FontWeight.w600, color: FridgeColors.inkMid)),
        ],
      ),
    );
  }
}
