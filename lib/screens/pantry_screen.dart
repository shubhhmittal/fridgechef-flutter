import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../app_state.dart';
import '../models/ingredient.dart';
import '../theme.dart';
import '../widgets/ingredient_card.dart';
import 'recipes_screen.dart';

class PantryScreen extends StatefulWidget {
  const PantryScreen({super.key});

  @override
  State<PantryScreen> createState() => _PantryScreenState();
}

class _PantryScreenState extends State<PantryScreen> {
  final _searchCtrl = TextEditingController();
  String _query = '';

  static const _categories = ['All', 'Dairy', 'Vegetable', 'Protein', 'Pantry', 'Spice'];
  String _selectedCategory = 'All';

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  List<Ingredient> _filtered(List<Ingredient> all) {
    return all.where((i) {
      final matchCat = _selectedCategory == 'All' || i.category == _selectedCategory;
      final matchQ = _query.isEmpty ||
          i.name.toLowerCase().contains(_query.toLowerCase());
      return matchCat && matchQ;
    }).toList();
  }

  Map<String, List<Ingredient>> _groupByCategory(List<Ingredient> items) {
    final map = <String, List<Ingredient>>{};
    for (final i in items) {
      map.putIfAbsent(i.category, () => []).add(i);
    }
    return map;
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final filtered = _filtered(state.ingredients);
    final grouped = _groupByCategory(filtered);
    final pantryCount = state.pantry.length;

    return Scaffold(
      backgroundColor: FridgeColors.fridgeWhite,
      body: CustomScrollView(
        slivers: [
          // ── App Bar ──────────────────────────────────────────────────────
          SliverAppBar(
            pinned: true,
            expandedHeight: 130,
            backgroundColor: FridgeColors.fridgeWhite,
            elevation: 0,
            scrolledUnderElevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: FridgeColors.fridgeGradient,
                ),
                padding: const EdgeInsets.fromLTRB(20, 56, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'My Fridge',
                          style: GoogleFonts.playfairDisplay(
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                            color: FridgeColors.inkNavy,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text('🧊', style: const TextStyle(fontSize: 22)),
                        const Spacer(),
                        if (pantryCount > 0)
                          GestureDetector(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const RecipesScreen(),
                              ),
                            ),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 8),
                              decoration: BoxDecoration(
                                color: FridgeColors.fridgeLight,
                                borderRadius: BorderRadius.circular(24),
                                boxShadow: [
                                  BoxShadow(
                                    color: FridgeColors.fridgeLight.withOpacity(0.35),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    'Cook',
                                    style: GoogleFonts.dmSans(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  const Icon(Icons.arrow_forward_rounded,
                                      size: 14, color: Colors.white),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      pantryCount == 0
                          ? 'Tap ingredients to stock your fridge'
                          : '$pantryCount ingredient${pantryCount == 1 ? '' : 's'} in your fridge',
                      style: GoogleFonts.dmSans(
                        fontSize: 13,
                        color: FridgeColors.inkMid,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(0),
              child: Container(
                height: 1,
                color: FridgeColors.divider,
              ),
            ),
          ),

          // ── Search bar ───────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
              child: Container(
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: FridgeColors.shelfEdge),
                  boxShadow: [
                    BoxShadow(
                      color: FridgeColors.inkNavy.withOpacity(0.04),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchCtrl,
                  onChanged: (v) => setState(() => _query = v),
                  style: GoogleFonts.dmSans(
                      fontSize: 14, color: FridgeColors.inkNavy),
                  decoration: InputDecoration(
                    hintText: 'Search ingredients…',
                    hintStyle: GoogleFonts.dmSans(
                        fontSize: 14, color: FridgeColors.inkLight),
                    prefixIcon: const Icon(Icons.search_rounded,
                        size: 18, color: FridgeColors.inkLight),
                    suffixIcon: _query.isNotEmpty
                        ? GestureDetector(
                            onTap: () {
                              _searchCtrl.clear();
                              setState(() => _query = '');
                            },
                            child: const Icon(Icons.close_rounded,
                                size: 16, color: FridgeColors.inkLight),
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ),
          ),

          // ── Category filter ──────────────────────────────────────────────
          SliverToBoxAdapter(
            child: SizedBox(
              height: 44,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                itemCount: _categories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (_, i) {
                  final cat = _categories[i];
                  final active = cat == _selectedCategory;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedCategory = cat),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 160),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 5),
                      decoration: BoxDecoration(
                        color: active
                            ? (cat == 'All'
                                ? FridgeColors.fridgeLight
                                : FridgeColors.categoryAccent(cat))
                            : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: active
                              ? Colors.transparent
                              : FridgeColors.shelfEdge,
                        ),
                      ),
                      child: Text(
                        cat,
                        style: GoogleFonts.dmSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: active ? Colors.white : FridgeColors.inkMid,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 12)),

          // ── Fridge shelves ───────────────────────────────────────────────
          if (filtered.isEmpty)
            SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('🔍', style: const TextStyle(fontSize: 40)),
                    const SizedBox(height: 12),
                    Text(
                      'Nothing found',
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 18,
                        color: FridgeColors.inkMid,
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
                  final category = grouped.keys.toList()[index];
                  final items = grouped[category]!;
                  return _FridgeShelf(
                    category: category,
                    items: items,
                    pantry: state.pantry,
                    onToggle: state.toggleIngredient,
                  );
                },
                childCount: grouped.length,
              ),
            ),

          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }
}

// ── Fridge Shelf Widget ────────────────────────────────────────────────────
class _FridgeShelf extends StatelessWidget {
  final String category;
  final List<Ingredient> items;
  final Set<String> pantry;
  final void Function(String) onToggle;

  const _FridgeShelf({
    required this.category,
    required this.items,
    required this.pantry,
    required this.onToggle,
  });

  static const _categoryEmoji = {
    'Dairy': '🥛',
    'Vegetable': '🥦',
    'Protein': '🍗',
    'Pantry': '🫙',
    'Spice': '🌶️',
  };

  @override
  Widget build(BuildContext context) {
    final accent = FridgeColors.categoryAccent(category);
    final tint = FridgeColors.categoryTint(category);
    final emoji = _categoryEmoji[category] ?? '📦';

    return Container(
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Shelf label
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 0, 4, 8),
            child: Row(
              children: [
                Text(emoji, style: const TextStyle(fontSize: 14)),
                const SizedBox(width: 6),
                Text(
                  category,
                  style: GoogleFonts.dmSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: accent,
                    letterSpacing: 0.8,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Container(
                    height: 1,
                    color: accent.withOpacity(0.2),
                  ),
                ),
              ],
            ),
          ),

          // Shelf container — looks like a fridge shelf
          Container(
            decoration: BoxDecoration(
              color: tint,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: accent.withOpacity(0.15),
                width: 1,
              ),
            ),
            child: Column(
              children: [
                // Shelf glass top bar
                Container(
                  height: 6,
                  decoration: BoxDecoration(
                    color: accent.withOpacity(0.12),
                    borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(16)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 12),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                      childAspectRatio: 0.82,
                    ),
                    itemCount: items.length,
                    itemBuilder: (_, i) {
                      final ing = items[i];
                      return IngredientCard(
                        emoji: ing.emoji,
                        name: ing.name,
                        category: ing.category,
                        selected: pantry.contains(ing.id),
                        onTap: () => onToggle(ing.id),
                      );
                    },
                  ),
                ),
                // Shelf bottom edge
                Container(
                  height: 8,
                  decoration: BoxDecoration(
                    color: accent.withOpacity(0.1),
                    borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(16)),
                    border: Border(
                      top: BorderSide(
                          color: accent.withOpacity(0.2), width: 1),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
        ],
      ),
    );
  }
}
