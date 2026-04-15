import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../app_state.dart';
import '../theme.dart';
import '../widgets/recipe_card.dart';
import 'recipe_detail_screen.dart';

class SavedScreen extends StatelessWidget {
  const SavedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final saved = state.savedRecipes;

    return Scaffold(
      backgroundColor: FridgeColors.fridgeWhite,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            backgroundColor: FridgeColors.fridgeWhite,
            elevation: 0,
            scrolledUnderElevation: 0,
            expandedHeight: 120,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(gradient: FridgeColors.fridgeGradient),
                padding: const EdgeInsets.fromLTRB(20, 56, 20, 0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Saved Recipes',
                          style: GoogleFonts.playfairDisplay(fontSize: 26, fontWeight: FontWeight.w700, color: FridgeColors.inkNavy)),
                        Text('${saved.length} bookmark${saved.length == 1 ? '' : 's'}',
                          style: GoogleFonts.dmSans(fontSize: 13, color: FridgeColors.inkMid)),
                      ],
                    ),
                    const Spacer(),
                    Text('🔖', style: const TextStyle(fontSize: 28)),
                  ],
                ),
              ),
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(1),
              child: Container(height: 1, color: FridgeColors.divider),
            ),
          ),

          if (saved.isEmpty)
            SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('🔖', style: const TextStyle(fontSize: 52)),
                    const SizedBox(height: 16),
                    Text('No saved recipes yet',
                      style: GoogleFonts.playfairDisplay(fontSize: 20, color: FridgeColors.inkMid)),
                    const SizedBox(height: 8),
                    Text('Bookmark recipes from the Recipes screen',
                      style: GoogleFonts.dmSans(fontSize: 13, color: FridgeColors.inkLight)),
                  ],
                ),
              ),
            )
          else ...[
            const SliverToBoxAdapter(child: SizedBox(height: 12)),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final m = saved[index];
                  return RecipeCard(
                    match: m,
                    isSaved: true,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => RecipeDetailScreen(match: m)),
                    ),
                    onSave: () => state.toggleSaved(m.recipe.id),
                  );
                },
                childCount: saved.length,
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
          ],
        ],
      ),
    );
  }
}
