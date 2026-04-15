import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../app_state.dart';
import '../logic/matcher.dart';
import '../theme.dart';
import '../widgets/recipe_card.dart';
import 'recipe_detail_screen.dart';

class RecipesScreen extends StatefulWidget {
  const RecipesScreen({super.key});

  @override
  State<RecipesScreen> createState() => _RecipesScreenState();
}

class _RecipesScreenState extends State<RecipesScreen> {
  // 0 = All, 1 = Veg, 2 = Non-veg
  int _vegFilter = 0;
  String _cuisineFilter = 'All';
  bool _cookableOnly = false;

  List<MatchedRecipe> _applyFilters(List<MatchedRecipe> all) {
    return all.where((m) {
      if (_vegFilter == 1 && !m.recipe.isVeg) return false;
      if (_vegFilter == 2 && m.recipe.isVeg) return false;
      if (_cuisineFilter != 'All' && m.recipe.cuisine != _cuisineFilter) return false;
      if (_cookableOnly && m.missingCount != 0) return false;
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final all = state.matchedRecipes;
    final filtered = _applyFilters(all);

    final cuisines = ['All', ...{...all.map((m) => m.recipe.cuisine)}];
    final cookableCount = all.where((m) => m.missingCount == 0).length;

    return Scaffold(
      backgroundColor: FridgeColors.fridgeWhite,
      body: CustomScrollView(
        slivers: [
          // ── App Bar ──────────────────────────────────────────────────────
          SliverAppBar(
            pinned: true,
            backgroundColor: FridgeColors.fridgeWhite,
            elevation: 0,
            scrolledUnderElevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded,
                  size: 18, color: FridgeColors.inkNavy),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              'Recipes',
              style: GoogleFonts.playfairDisplay(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: FridgeColors.inkNavy,
              ),
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(1),
              child: Container(height: 1, color: FridgeColors.divider),
            ),
          ),

          // ── Stats bar ────────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.fromLTRB(16, 14, 16, 0),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFE2F3FA), Color(0xFFECF8F0)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: FridgeColors.shelfEdge),
              ),
              child: Row(
                children: [
                  _StatBubble(
                    value: '${all.length}',
                    label: 'recipes',
                    color: FridgeColors.fridgeLight,
                  ),
                  const SizedBox(width: 16),
                  Container(width: 1, height: 32, color: FridgeColors.divider),
                  const SizedBox(width: 16),
                  _StatBubble(
                    value: '$cookableCount',
                    label: 'cookable now',
                    color: FridgeColors.haveGreen,
                  ),
                  const SizedBox(width: 16),
                  Container(width: 1, height: 32, color: FridgeColors.divider),
                  const SizedBox(width: 16),
                  _StatBubble(
                    value: '${state.pantry.length}',
                    label: 'in fridge',
                    color: FridgeColors.selectedAmber,
                  ),
                ],
              ),
            ),
          ),

          // ── Veg toggle ───────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Row(
                children: [
                  _VegToggleButton(
                    label: 'All',
                    active: _vegFilter == 0,
                    onTap: () => setState(() => _vegFilter = 0),
                    color: FridgeColors.fridgeLight,
                  ),
                  const SizedBox(width: 8),
                  _VegToggleButton(
                    label: '🟢 Veg',
                    active: _vegFilter == 1,
                    onTap: () => setState(() => _vegFilter = 1),
                    color: FridgeColors.vegGreen,
                  ),
                  const SizedBox(width: 8),
                  _VegToggleButton(
                    label: '🔴 Non-veg',
                    active: _vegFilter == 2,
                    onTap: () => setState(() => _vegFilter = 2),
                    color: FridgeColors.nonVegRed,
                  ),
                ],
              ),
            ),
          ),

          // ── Cuisine + cookable filters ───────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: SizedBox(
                height: 36,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    // Cookable toggle
                    GestureDetector(
                      onTap: () =>
                          setState(() => _cookableOnly = !_cookableOnly),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 160),
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: _cookableOnly
                              ? FridgeColors.cookableGold
                              : Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: _cookableOnly
                                ? FridgeColors.cookableGold
                                : FridgeColors.shelfEdge,
                          ),
                        ),
                        child: Row(
                          children: [
                            Text('⚡',
                                style: const TextStyle(fontSize: 11)),
                            const SizedBox(width: 4),
                            Text(
                              'Cookable Now',
                              style: GoogleFonts.dmSans(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: _cookableOnly
                                    ? Colors.white
                                    : FridgeColors.inkMid,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Cuisine chips
                    ...cuisines.map((c) {
                      final active = c == _cuisineFilter;
                      return GestureDetector(
                        onTap: () =>
                            setState(() => _cuisineFilter = c),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 160),
                          margin: const EdgeInsets.only(right: 8),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: active
                                ? FridgeColors.fridgeLight
                                : Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: active
                                  ? FridgeColors.fridgeLight
                                  : FridgeColors.shelfEdge,
                            ),
                          ),
                          child: Text(
                            c,
                            style: GoogleFonts.dmSans(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: active
                                  ? Colors.white
                                  : FridgeColors.inkMid,
                            ),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 12)),

          // ── Recipe list ──────────────────────────────────────────────────
          if (filtered.isEmpty)
            SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('🍽️', style: const TextStyle(fontSize: 44)),
                    const SizedBox(height: 12),
                    Text(
                      'No recipes match',
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 18,
                        color: FridgeColors.inkMid,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Try adjusting your filters',
                      style: GoogleFonts.dmSans(
                        fontSize: 13,
                        color: FridgeColors.inkLight,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final m = filtered[index];
                  return RecipeCard(
                    match: m,
                    isSaved: state.isSaved(m.recipe.id),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => RecipeDetailScreen(match: m),
                      ),
                    ),
                    onSave: () => state.toggleSaved(m.recipe.id),
                  );
                },
                childCount: filtered.length,
              ),
            ),

          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }
}

class _StatBubble extends StatelessWidget {
  final String value;
  final String label;
  final Color color;
  const _StatBubble(
      {required this.value, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: GoogleFonts.playfairDisplay(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.dmSans(
            fontSize: 10,
            fontWeight: FontWeight.w500,
            color: FridgeColors.inkMid,
          ),
        ),
      ],
    );
  }
}

class _VegToggleButton extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;
  final Color color;
  const _VegToggleButton(
      {required this.label,
      required this.active,
      required this.onTap,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: active ? color : Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: active ? color : FridgeColors.shelfEdge,
          ),
          boxShadow: active
              ? [
                  BoxShadow(
                    color: color.withOpacity(0.25),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  )
                ]
              : [],
        ),
        child: Text(
          label,
          style: GoogleFonts.dmSans(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: active ? Colors.white : FridgeColors.inkMid,
          ),
        ),
      ),
    );
  }
}
