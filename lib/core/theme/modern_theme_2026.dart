import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';

/// 🎨 Modern 2026 Theme - Clean, Professional & Commercial Grade
/// Minimalist design with perfect typography and layouts
class ModernTheme2026 {
  
  // 🎯 2026 Color System - Clean & Minimal
  static const Color primaryWhite = Color(0xFFFFFFFF);
  static const Color primaryBlack = Color(0xFF0C0C0C);
  static const Color neutralGray50 = Color(0xFEFEFE);
  static const Color neutralGray100 = Color(0xFBFCFD);
  static const Color neutralGray200 = Color(0xF7F9FB);
  static const Color neutralGray300 = Color(0xEEF2F6);
  static const Color neutralGray400 = Color(0xE0E7ED);
  static const Color neutralGray500 = Color(0xCBD5E1); 
  static const Color neutralGray600 = Color(0x94A3B8);
  static const Color neutralGray700 = Color(0x64748B);
  static const Color neutralGray800 = Color(0x475569);
  static const Color neutralGray900 = Color(0x334155);
  
  // 🔥 Modern Accent Colors - 2026 Palette
  static const Color primaryBlue = Color(0xFF2563EB);    // Blue 600
  static const Color primaryGreen = Color(0xFF10B981);   // Emerald 500
  static const Color primaryOrange = Color(0xFFF59E0B);  // Amber 500
  static const Color primaryRed = Color(0xFFEF4444);     // Red 500
  static const Color primaryPurple = Color(0xFF8B5CF6);  // Violet 500
  static const Color primaryTeal = Color(0xFF14B8A6);    // Teal 500
  
  // ✨ Glass & Modern Effects
  static const Color glass = Color(0xFFFDFDFD);
  static const Color cardShadow = Color(0x08000000);
  static const Color borderLight = Color(0xFFE2E8F0);
  
  // 📱 2026 Typography System - Clean & Readable
  static TextTheme get textTheme {
    return TextTheme(
      // Modern Headings - System font with fallbacks
      displayLarge: const TextStyle(
        fontFamily: 'SF Pro Display', // iOS system font
        fontSize: 32,
        fontWeight: FontWeight.w700,
        height: 1.2,
        letterSpacing: -0.5,
        color: primaryBlack,
      ).copyWith(
        fontFamily: 'Roboto', // Android fallback
      ),
      
      displayMedium: const TextStyle(
        fontFamily: 'SF Pro Display',
        fontSize: 28,
        fontWeight: FontWeight.w600,
        height: 1.3,
        letterSpacing: -0.3,
        color: primaryBlack,
      ),
      
      displaySmall: const TextStyle(
        fontFamily: 'SF Pro Display', 
        fontSize: 24,
        fontWeight: FontWeight.w600,
        height: 1.3,
        color: primaryBlack,
      ),
      
      // Clean body text - Optimal readability
      headlineLarge: GoogleFonts.inter(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        height: 1.4,
        color: primaryBlack,
      ),
      
      headlineMedium: GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w500,
        height: 1.4,
        color: primaryBlack,
      ),
      
      headlineSmall: GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        height: 1.4,
        color: primaryBlack,
      ),
      
      // Body text - Perfect for content
      bodyLarge: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.6,
        color: neutralGray800,
      ),
      
      bodyMedium: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.5,
        color: neutralGray700,
      ),
      
      bodySmall: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 1.4,
        color: neutralGray600,
      ),
      
      // Labels & UI elements
      labelLarge: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        height: 1.2,
        letterSpacing: 0.1,
        color: primaryBlack,
      ),
      
      labelMedium: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        height: 1.2,
        letterSpacing: 0.5,
        color: neutralGray700,
      ),
      
      labelSmall: GoogleFonts.inter(
        fontSize: 10,
        fontWeight: FontWeight.w500,
        height: 1.2,
        letterSpacing: 0.8,
        color: neutralGray600,
      ),
    );
  }
  
  // 🎨 Modern Theme Data - Clean & Professional
  static ThemeData get lightTheme {
    return FlexThemeData.light(
      scheme: FlexScheme.blue,
      surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
      blendLevel: 7,
      subTheme: const FlexSubThemesData(
        blendOnLevel: 10,
        blendOnColors: false,
        useTextTheme: true,
        useM2StyleDividerInM3: true,
        alignedDropdown: true,
        useInputDecoratorThemeInTextField: true,
      ),
      visualDensity: FlexColorScheme.comfortablePlatformDensity,
      useMaterial3: true,
      swapLegacyOnMaterial3: true,
    ).copyWith(
      textTheme: textTheme,
      scaffoldBackgroundColor: neutralGray100,
      cardColor: primaryWhite,
      dividerColor: borderLight,
      
      // Modern App Bar
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 1,
        surfaceTintColor: Colors.transparent,
        iconTheme: IconThemeData(color: primaryBlack),
        titleTextStyle: TextStyle(
          fontFamily: 'SF Pro Display',
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: primaryBlack,
        ),
      ),
      
      // Clean Cards
      cardTheme: CardTheme(
        color: primaryWhite,
        elevation: 2,
        shadowColor: cardShadow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: borderLight, width: 0.5),
        ),
      ),
      
      // Modern Buttons  
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryBlue,
          foregroundColor: primaryWhite,
          elevation: 2,
          shadowColor: cardShadow,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          textStyle: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            height: 1.2,
          ),
        ),
      ),
      
      // Outlined Buttons
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryBlue,
          side: const BorderSide(color: borderLight, width: 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        ),
      ),
      
      // Clean Input Fields
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: neutralGray200,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryBlue, width: 2),
        ),
        labelStyle: textTheme.bodyMedium,
        hintStyle: textTheme.bodyMedium?.copyWith(
          color: neutralGray500,
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16, 
          horizontal: 16,
        ),
      ),
    );
  }
  
  // 🌙 Dark Theme - Optional
  static ThemeData get darkTheme {
    return FlexThemeData.dark(
      scheme: FlexScheme.blue,
      surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
      blendLevel: 13,
      subTheme: const FlexSubThemesData(
        blendOnLevel: 20,
        useTextTheme: true,
        useM2StyleDividerInM3: true,
        alignedDropdown: true,
        useInputDecoratorThemeInTextField: true,
      ),
      visualDensity: FlexColorScheme.comfortablePlatformDensity,
      useMaterial3: true,
      swapLegacyOnMaterial3: true,
    );
  }
  
  // 📦 Modern Decorations
  static BoxDecoration get cardDecoration {
    return BoxDecoration(
      color: primaryWhite,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: borderLight, width: 0.5),
      boxShadow: [
        BoxShadow(
          color: cardShadow,
          blurRadius: 8,
          spreadRadius: 0,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }
  
  static BoxDecoration get glassMorphism {
    return BoxDecoration(
      color: glass,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(
        color: primaryWhite.withOpacity(0.2),
        width: 1,
      ),
      boxShadow: [
        BoxShadow(
          color: cardShadow,
          blurRadius: 20,
          spreadRadius: 0,
          offset: const Offset(0, 8),
        ),
      ],
    );
  }
  
  // Legacy compatibility - For existing code
  static const Color corporateBlue = primaryBlue;
  static const Color businessGreen = primaryGreen;
  static const Color businessOrange = primaryOrange;
  static const Color businessTeal = primaryTeal;
  static const Color textGray = neutralGray700;
  static const Color backgroundGray = neutralGray200;
  static const Color surfaceGray = neutralGray100;
}

// Alias for backward compatibility
typedef AutomotiveTheme = ModernTheme2026;