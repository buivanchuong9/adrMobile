import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';

/// Modern 2026 Professional Theme
/// Clean, minimal, commercial-grade design
class ModernTheme {
  // 🏢 CORPORATE 3D COLOR PALETTE - PROFESSIONAL BUSINESS
  static const Color primaryWhite = Color(0xFFFFFFFF);
  static const Color primaryBlack = Color(0xFF1A1A1A);
  static const Color backgroundGray = Color(0xFFF5F7FA);
  
  // Corporate business colors
  static const Color corporateBlue = Color(0xFF2563EB);
  static const Color corporateGray = Color(0xFF6B7280);
  static const Color corporateDark = Color(0xFF374151);
  
  // Professional accent colors
  static const Color businessBlue = Color(0xFF3B82F6);
  static const Color businessGreen = Color(0xFF10B981);
  static const Color businessOrange = Color(0xFFF59E0B);
  static const Color businessPurple = Color(0xFF8B5CF6);
  static const Color businessRed = Color(0xFFEF4444);
  static const Color businessTeal = Color(0xFF14B8A6);
  
  // Status colors
  static const Color successGreen = Color(0xFF10B981);
  static const Color warningOrange = Color(0xFFF59E0B);
  static const Color errorRed = Color(0xFFEF4444);
  
  // Corporate surface colors
  static const Color cardWhite = Color(0xFFFFFFFF);
  static const Color surfaceGray = Color(0xFFF9FAFB);
  static const Color borderGray = Color(0xFFE5E7EB);
  static const Color textGray = Color(0xFF6B7280);
  
  // Gradients
  static const LinearGradient neonGradient = LinearGradient(
    colors: [corporateBlue, businessTeal],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient speedGradient = LinearGradient(
    colors: [businessOrange, businessGreen],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
  
  static const LinearGradient darkGradient = LinearGradient(
    colors: [primaryBlack, surfaceGray],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
  
  static const LinearGradient glassGradient = LinearGradient(
    colors: [
      Color(0x20FFFFFF),
      Color(0x10FFFFFF),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Typography - Futuristic fonts
  static TextTheme get textTheme {
    return TextTheme(
      // Headlines - Orbitron for futuristic look
      headlineLarge: GoogleFonts.orbitron(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        color: primaryWhite,
        letterSpacing: -0.5,
      ),
      headlineMedium: GoogleFonts.orbitron(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        color: primaryWhite,
        letterSpacing: -0.3,
      ),
      headlineSmall: GoogleFonts.orbitron(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: primaryWhite,
      ),
      
      // Titles - Rajdhani for readability
      titleLarge: GoogleFonts.rajdhani(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: primaryWhite,
      ),
      titleMedium: GoogleFonts.rajdhani(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: primaryWhite,
      ),
      titleSmall: GoogleFonts.rajdhani(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: textGray,
      ),
      
      // Body text - Inter for readability
      bodyLarge: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: primaryWhite,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: textGray,
      ),
      bodySmall: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: textGray,
        letterSpacing: 0.4,
      ),
      
      // Labels - Rajdhani for UI elements
      labelLarge: GoogleFonts.rajdhani(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: primaryWhite,
        letterSpacing: 1.25,
      ),
      labelMedium: GoogleFonts.rajdhani(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: textGray,
        letterSpacing: 1.5,
      ),
      labelSmall: GoogleFonts.rajdhani(
        fontSize: 10,
        fontWeight: FontWeight.w600,
        color: textGray,
        letterSpacing: 1.5,
      ),
    );
  }

  // Theme Data
  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: backgroundGray,
      textTheme: textTheme,
      
      // AppBar
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        titleTextStyle: textTheme.headlineSmall,
        iconTheme: const IconThemeData(color: primaryWhite),
      ),
      
      // Card
      cardTheme: CardThemeData(
        color: cardWhite,
        elevation: 12,
        shadowColor: Colors.black.withOpacity(0.15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      
      // Elevated Button
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: corporateBlue,
          foregroundColor: primaryWhite,
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.rajdhani(
            fontWeight: FontWeight.w600,
            letterSpacing: 1.0,
          ),
        ),
      ),
      
      // Input Decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceGray,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: corporateBlue, width: 2),
        ),
        labelStyle: textTheme.bodyMedium,
        hintStyle: textTheme.bodyMedium?.copyWith(color: textGray.withOpacity(0.7)),
      ),
      
      // Icon Theme
      iconTheme: const IconThemeData(
        color: primaryWhite,
        size: 24,
      ),
      
      // Bottom Navigation
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: surfaceGray,
        selectedItemColor: corporateBlue,
        unselectedItemColor: textGray,
        type: BottomNavigationBarType.fixed,
        elevation: 16,
      ),
    );
  }

  // Custom decorations
  static BoxDecoration get glassDecoration {
    return BoxDecoration(
      gradient: glassGradient,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(
        color: primaryWhite.withOpacity(0.1),
        width: 1,
      ),
    );
  }

  static BoxDecoration get carbonFiberDecoration {
    return BoxDecoration(
      color: surfaceGray,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: primaryBlack.withOpacity(0.3),
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  static BoxDecoration get neonGlowDecoration {
    return BoxDecoration(
      gradient: neonGradient,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: corporateBlue.withOpacity(0.5),
          blurRadius: 20,
          spreadRadius: 2,
        ),
      ],
    );
  }
}