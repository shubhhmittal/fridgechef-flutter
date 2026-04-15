import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../logic/matcher.dart';
import '../theme.dart';

class RecipeCard extends StatelessWidget {
  final MatchedRecipe match;
  final bool isSaved;
  final VoidCallback onTap;
  final VoidCallback onSave;

  const RecipeCard({
    super.key,
    required this.match,
    required this.isSaved,
    required this.onTap,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    final recipe = match.recipe;
    final canCook = match.missingCount == 0;
    final pct = (match.matchPercent * 100).round();

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: canCook
                ? FridgeColors.haveGreen.withOpacity(0.5)
                : FridgeColors.divider,
            width: canCook ? 1.5 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: canCook
                  ? FridgeColors.haveGreen.withOpacity(0.08)
                  : FridgeColors.inkNavy.withOpacity(0.05),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top row
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 12, 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Cuisine + veg badge row
                        Row(
                          children: [
                            _CuisinePill(cuisine: recipe.cuisine),
                            const SizedBox(width: 6),
                            _VegBadge(isVeg: recipe.isVeg),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          recipe.name,
                          style: GoogleFonts.playfairDisplay(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: FridgeColors.inkNavy,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Save button
                  GestureDetector(
                    onTap: onSave,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: isSaved
                            ? FridgeColors.selectedAmber.withOpacity(0.12)
                            : FridgeColors.shelfGlass,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isSaved ? Icons.bookmark_rounded : Icons.bookmark_outline_rounded,
                        size: 18,
                        color: isSaved
                            ? FridgeColors.selectedAmber
                            : FridgeColors.inkLight,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // Match bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        canCook ? 'Ready to cook' : '$pct% match',
                        style: GoogleFonts.dmSans(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: canCook
                              ? FridgeColors.haveGreen
                              : FridgeColors.inkMid,
                        ),
                      ),
                      if (!canCook)
                        Text(
                          '${match.missingCount} missing',
                          style: GoogleFonts.dmSans(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: FridgeColors.missingRed,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: match.matchPercent,
                      minHeight: 5,
                      backgroundColor: FridgeColors.shelfGlass,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        canCook ? FridgeColors.haveGreen : FridgeColors.fridgeLight,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // Meta row
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
              child: Row(
                children: [
                  _MetaChip(
                    icon: Icons.timer_outlined,
                    label: '${recipe.cookTime}m',
                  ),
                  const SizedBox(width: 8),
                  _MetaChip(
                    icon: Icons.people_outline_rounded,
                    label: '${recipe.servings}',
                  ),
                  const SizedBox(width: 8),
                  _MetaChip(
                    icon: Icons.bar_chart_rounded,
                    label: recipe.difficulty,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CuisinePill extends StatelessWidget {
  final String cuisine;
  const _CuisinePill({required this.cuisine});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: FridgeColors.shelfGlass,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: FridgeColors.shelfEdge, width: 1),
      ),
      child: Text(
        cuisine,
        style: GoogleFonts.dmSans(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: FridgeColors.inkMid,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}

class _VegBadge extends StatelessWidget {
  final bool isVeg;
  const _VegBadge({required this.isVeg});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 18,
      height: 18,
      decoration: BoxDecoration(
        border: Border.all(
          color: isVeg ? FridgeColors.vegGreen : FridgeColors.nonVegRed,
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(3),
      ),
      child: Center(
        child: Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: isVeg ? FridgeColors.vegGreen : FridgeColors.nonVegRed,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _MetaChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 13, color: FridgeColors.inkLight),
        const SizedBox(width: 3),
        Text(
          label,
          style: GoogleFonts.dmSans(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: FridgeColors.inkMid,
          ),
        ),
      ],
    );
  }
}
