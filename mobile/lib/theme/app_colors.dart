import 'package:flutter/material.dart';

/// ARATEL Toss-Style Surface Elevation & Luxury Gold Color Tokens
abstract class AppColors {
  // Brand Luxury Accents
  static const Color satinGold = Color(0xFFD4AF37);
  static const Color satinGoldLight = Color(0xFFF3E5AB);
  static const Color satinGoldDark = Color(0xFF997A15);

  // Surface Elevation Dark Mode Layers
  static const Color bgBase = Color(0xFF0F1115); // Layer 0: App Scaffold Background
  static const Color bgSurface = Color(0xFF161920); // Layer 1: Main Cards & AppBars
  static const Color bgElevated = Color(0xFF1E222B); // Layer 2: Sub-Cards & Input Fills
  static const Color bgTop = Color(0xFF262B36); // Layer 3: Badges, Pills & Modals

  // Text Colors
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFCBD5E1);
  static const Color textMuted = Color(0xFF64748B);
  static const Color textDisabled = Color(0xFF475569);

  // Borders & Dividers
  static const Color borderSubtle = Color(0x22FFFFFF);
  static const Color borderGold = Color(0x44D4AF37);
  static const Color divider = Color(0xFF1E293B);

  // Semantic Status Colors
  static const Color statusSuccess = Color(0xFF4CAF50);
  static const Color statusWarning = Color(0xFFFBBF24);
  static const Color statusError = Color(0xFFEF4444);
  static const Color statusInfo = Color(0xFF38BDF8);
  static const Color statusPurple = Color(0xFFA855F7);
}
