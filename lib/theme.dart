import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ── Fridge Colour Palette ──────────────────────────────────────────────────
class FridgeColors {
  // Backgrounds
  static const Color fridgeWhite        = Color(0xFFF0F6F8);
  static const Color shelfGlass         = Color(0xFFDCEEF5);
  static const Color shelfEdge          = Color(0xFFADD4E4);
  static const Color innerPanel         = Color(0xFFE4F2F8);
  static const Color shelfBar           = Color(0xFFC8E2EE); // shelf divider bar

  // Accents
  static const Color fridgeLight        = Color(0xFF5BB8D4);
  static const Color fridgeLightGlow    = Color(0xFF7EC8E3);
  static const Color selectedAmber      = Color(0xFFF4A261);
  static const Color selectedAmberLight = Color(0xFFFDE8D5);
  static const Color vegGreen           = Color(0xFF52B788);
  static const Color nonVegRed          = Color(0xFFE05C5C);
  static const Color missingRed         = Color(0xFFE05C5C);
  static const Color haveGreen          = Color(0xFF52B788);
  static const Color cookableGold       = Color(0xFFE9C46A);

  // Category shelf tints
  static const Color dairyTint     = Color(0xFFF5F0E8); // warm cream
  static const Color vegTint       = Color(0xFFEDF7EE); // soft green
  static const Color proteinTint   = Color(0xFFFAEEEE); // soft rose
  static const Color pantryTint    = Color(0xFFF5F2E8); // warm sand
  static const Color spiceTint     = Color(0xFFFFF3E8); // warm orange

  // Text
  static const Color inkNavy       = Color(0xFF152535);
  static const Color inkMid        = Color(0xFF3D5A6E);
  static const Color inkLight      = Color(0xFF7A9BAD);

  // Nav / Surface
  static const Color navBar        = Color(0xFFFFFFFF);
  static const Color cardSurface   = Color(0xFFFFFFFF);
  static const Color divider       = Color(0xFFC4DCE8);

  // Gradients
  static const LinearGradient fridgeGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFE2F3FA), Color(0xFFF0F6F8)],
  );

  static const LinearGradient shelfGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFECF6FB), Color(0xFFDCEEF5)],
  );

  static Color categoryTint(String category) {
    switch (category) {
      case 'Dairy':     return dairyTint;
      case 'Vegetable': return vegTint;
      case 'Protein':   return proteinTint;
      case 'Pantry':    return pantryTint;
      case 'Spice':     return spiceTint;
      default:          return shelfGlass;
    }
  }

  static Color categoryAccent(String category) {
    switch (category) {
      case 'Dairy':     return const Color(0xFFD4A853);
      case 'Vegetable': return const Color(0xFF52B788);
      case 'Protein':   return const Color(0xFFE07070);
      case 'Pantry':    return const Color(0xFFB08A5A);
      case 'Spice':     return const Color(0xFFE07A30);
      default:          return fridgeLight;
    }
  }
}

// ── Theme ──────────────────────────────────────────────────────────────────
ThemeData buildFridgeTheme() {
  final base = ThemeData.light(useMaterial3: true);
  return base.copyWith(
    scaffoldBackgroundColor: FridgeColors.fridgeWhite,
    colorScheme: const ColorScheme.light(
      primary:     FridgeColors.fridgeLight,
      secondary:   FridgeColors.selectedAmber,
      surface:     FridgeColors.cardSurface,
      onPrimary:   Colors.white,
      onSecondary: Colors.white,
      onSurface:   FridgeColors.inkNavy,
    ),
    textTheme: GoogleFonts.dmSansTextTheme(base.textTheme).copyWith(
      displayLarge: GoogleFonts.playfairDisplay(
        fontSize: 32, fontWeight: FontWeight.w700, color: FridgeColors.inkNavy,
      ),
      displayMedium: GoogleFonts.playfairDisplay(
        fontSize: 26, fontWeight: FontWeight.w700, color: FridgeColors.inkNavy,
      ),
      displaySmall: GoogleFonts.playfairDisplay(
        fontSize: 22, fontWeight: FontWeight.w600, color: FridgeColors.inkNavy,
      ),
      headlineMedium: GoogleFonts.playfairDisplay(
        fontSize: 20, fontWeight: FontWeight.w600, color: FridgeColors.inkNavy,
      ),
      titleLarge: GoogleFonts.dmSans(
        fontSize: 17, fontWeight: FontWeight.w600, color: FridgeColors.inkNavy,
      ),
      titleMedium: GoogleFonts.dmSans(
        fontSize: 15, fontWeight: FontWeight.w600, color: FridgeColors.inkNavy,
      ),
      bodyLarge: GoogleFonts.dmSans(
        fontSize: 15, fontWeight: FontWeight.w400, color: FridgeColors.inkNavy,
      ),
      bodyMedium: GoogleFonts.dmSans(
        fontSize: 13, fontWeight: FontWeight.w400, color: FridgeColors.inkMid,
      ),
      labelLarge: GoogleFonts.dmSans(
        fontSize: 13, fontWeight: FontWeight.w600, color: FridgeColors.inkNavy,
        letterSpacing: 0.3,
      ),
      labelSmall: GoogleFonts.dmSans(
        fontSize: 11, fontWeight: FontWeight.w500, color: FridgeColors.inkLight,
        letterSpacing: 0.5,
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: FridgeColors.fridgeWhite,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      titleTextStyle: GoogleFonts.playfairDisplay(
        fontSize: 24, fontWeight: FontWeight.w700, color: FridgeColors.inkNavy,
      ),
      iconTheme: const IconThemeData(color: FridgeColors.inkNavy),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: FridgeColors.navBar,
      selectedItemColor: FridgeColors.fridgeLight,
      unselectedItemColor: FridgeColors.inkLight,
      elevation: 0,
      type: BottomNavigationBarType.fixed,
    ),
    chipTheme: ChipThemeData(
      backgroundColor: FridgeColors.shelfGlass,
      selectedColor: FridgeColors.fridgeLight,
      labelStyle: GoogleFonts.dmSans(fontSize: 12, fontWeight: FontWeight.w500),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      side: const BorderSide(color: FridgeColors.shelfEdge),
    ),
    dividerTheme: const DividerThemeData(
      color: FridgeColors.divider, thickness: 1, space: 1,
    ),
  );
}
