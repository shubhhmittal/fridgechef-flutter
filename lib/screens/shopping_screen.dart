import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../app_state.dart';
import '../theme.dart';

class ShoppingScreen extends StatelessWidget {
  const ShoppingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final items = state.shoppingList;
    final checked = state.shoppingChecked;
    final unchecked = items.where((i) => !checked.contains(i)).toList();
    final checkedItems = items.where((i) => checked.contains(i)).toList();

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
                        Text('Shopping List',
                          style: GoogleFonts.playfairDisplay(fontSize: 26, fontWeight: FontWeight.w700, color: FridgeColors.inkNavy)),
                        Text('${unchecked.length} item${unchecked.length == 1 ? '' : 's'} to get',
                          style: GoogleFonts.dmSans(fontSize: 13, color: FridgeColors.inkMid)),
                      ],
                    ),
                    const Spacer(),
                    Text('🛒', style: const TextStyle(fontSize: 28)),
                  ],
                ),
              ),
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(1),
              child: Container(height: 1, color: FridgeColors.divider),
            ),
          ),

          if (items.isEmpty)
            SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('🛒', style: const TextStyle(fontSize: 52)),
                    const SizedBox(height: 16),
                    Text('Your list is empty',
                      style: GoogleFonts.playfairDisplay(fontSize: 20, color: FridgeColors.inkMid)),
                    const SizedBox(height: 8),
                    Text('Add missing ingredients from a recipe',
                      style: GoogleFonts.dmSans(fontSize: 13, color: FridgeColors.inkLight)),
                  ],
                ),
              ),
            )
          else ...[
            // Unchecked items
            if (unchecked.isNotEmpty) ...[
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                  child: Text('To get',
                    style: GoogleFonts.dmSans(fontSize: 11, fontWeight: FontWeight.w700,
                      color: FridgeColors.inkLight, letterSpacing: 0.8)),
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: FridgeColors.divider),
                    boxShadow: [BoxShadow(color: FridgeColors.inkNavy.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))],
                  ),
                  child: Column(
                    children: unchecked.asMap().entries.map((entry) {
                      final i = entry.key;
                      final item = entry.value;
                      final ing = state.ingredientById(item);
                      final isLast = i == unchecked.length - 1;
                      return _ShoppingItem(
                        item: item,
                        ingredient: ing,
                        isChecked: false,
                        isLast: isLast,
                        onCheck: () => state.toggleShoppingCheck(item),
                        onDelete: () => state.removeFromShopping(item),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],

            // Checked items
            if (checkedItems.isNotEmpty) ...[
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                  child: Row(
                    children: [
                      Text('Got it',
                        style: GoogleFonts.dmSans(fontSize: 11, fontWeight: FontWeight.w700,
                          color: FridgeColors.inkLight, letterSpacing: 0.8)),
                      const Spacer(),
                      GestureDetector(
                        onTap: state.clearCheckedShopping,
                        child: Text('Clear',
                          style: GoogleFonts.dmSans(fontSize: 12, fontWeight: FontWeight.w600,
                            color: FridgeColors.missingRed)),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: FridgeColors.shelfGlass.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: FridgeColors.divider),
                  ),
                  child: Column(
                    children: checkedItems.asMap().entries.map((entry) {
                      final i = entry.key;
                      final item = entry.value;
                      final ing = state.ingredientById(item);
                      final isLast = i == checkedItems.length - 1;
                      return _ShoppingItem(
                        item: item,
                        ingredient: ing,
                        isChecked: true,
                        isLast: isLast,
                        onCheck: () => state.toggleShoppingCheck(item),
                        onDelete: () => state.removeFromShopping(item),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],

            const SliverToBoxAdapter(child: SizedBox(height: 32)),
          ],
        ],
      ),
    );
  }
}

class _ShoppingItem extends StatelessWidget {
  final String item;
  final dynamic ingredient;
  final bool isChecked;
  final bool isLast;
  final VoidCallback onCheck;
  final VoidCallback onDelete;

  const _ShoppingItem({
    required this.item,
    required this.ingredient,
    required this.isChecked,
    required this.isLast,
    required this.onCheck,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(item),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDelete(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: FridgeColors.missingRed.withOpacity(0.1),
          borderRadius: isLast
              ? const BorderRadius.vertical(bottom: Radius.circular(16))
              : BorderRadius.zero,
        ),
        child: const Icon(Icons.delete_outline_rounded, color: FridgeColors.missingRed, size: 20),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                GestureDetector(
                  onTap: onCheck,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    width: 24, height: 24,
                    decoration: BoxDecoration(
                      color: isChecked ? FridgeColors.haveGreen : Colors.transparent,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isChecked ? FridgeColors.haveGreen : FridgeColors.shelfEdge,
                        width: 1.5,
                      ),
                    ),
                    child: isChecked
                        ? const Icon(Icons.check_rounded, size: 14, color: Colors.white)
                        : null,
                  ),
                ),
                const SizedBox(width: 12),
                if (ingredient != null) ...[
                  Text(ingredient.emoji, style: const TextStyle(fontSize: 18)),
                  const SizedBox(width: 8),
                ],
                Expanded(
                  child: Text(
                    ingredient?.name ?? item,
                    style: GoogleFonts.dmSans(
                      fontSize: 14, fontWeight: FontWeight.w500,
                      color: isChecked ? FridgeColors.inkLight : FridgeColors.inkNavy,
                      decoration: isChecked ? TextDecoration.lineThrough : null,
                    ),
                  ),
                ),
                if (ingredient != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                    decoration: BoxDecoration(
                      color: FridgeColors.categoryTint(ingredient.category),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(ingredient.category,
                      style: GoogleFonts.dmSans(fontSize: 9, fontWeight: FontWeight.w600,
                        color: FridgeColors.categoryAccent(ingredient.category))),
                  ),
              ],
            ),
          ),
          if (!isLast) Divider(height: 1, color: FridgeColors.divider, indent: 16, endIndent: 16),
        ],
      ),
    );
  }
}
