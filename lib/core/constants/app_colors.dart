import 'package:flutter/material.dart';

class AppColors {
  // Absolute Cleanliness
  static const Color background = Color(0xFFFFFFFF);
  static const Color surface = Color(0xFFFFFFFF);
  
  static const Color backgroundSubtle = Color(0xFFF9FAFB); 

  // High Contrast Text
  static const Color textPrimary = Color(0xFF000000); 
  static const Color textSecondary = Color(0xFF475467); 
  static const Color textTertiary = Color(0xFF98A2B3); 

  // Premium Accents
  static const Color primary = Color(0xFF000000); 
  static const Color accent = Color(0xFF0052CC); 

  // Premium Orange (Requested)
  static const Color premiumOrange = Color(0xFFFF6D00); // Vibrant Orange
  static const Color premiumOrangeLight = Color(0xFFFF9E40); 
  
  // Gradients
  static const LinearGradient orangeGradient = LinearGradient(
    colors: [Color(0xFFFF9E40), Color(0xFFFF6D00)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const Color border = Color(0xFFEAECF0); 

  // Functional Colors
  static const Color error = Color(0xFFD92D20); 
  static const Color warning = Color(0xFFF79009); 
  static const Color success = Color(0xFF039855); 
  
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color transparent = Colors.transparent;
}
