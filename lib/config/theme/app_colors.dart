import 'package:flutter/material.dart';

class AppColors {
  // MARCA
  static const Color primary = Color(0xFF0EA5E9);
  static const Color primaryDark = Color(0xFF0284C7);
  static const Color primaryLight = Color(0xFFE0F2FE);
  static const Color accent = Color(0xFF22D3EE);

  // SEMÁNTICOS
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF8B5CF6);

  // NEUTROS
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF64748B);
  // Color letras de los inputs
  // Color letras de los inputs
  static const Color border = Color.fromARGB(255, 110, 110, 110);
  // Fondo de los inputs
  static const Color surface = Color.fromARGB(255, 236, 240, 241);
  // Fondo de la pantalla
  static const Color background = Color.fromARGB(255, 236, 240, 241);
  // Color blanco
  static const Color white = Color.fromARGB(255, 255, 255, 255);

  // Mapeos de compatibilidad con código existente
  static const Color primaryVariant = primaryDark;
  static const Color onBackground = textPrimary;
  static const Color onSurface = textPrimary;
  static const Color onSurfaceVariant = textSecondary;
  static const Color outline = border;
  static const Color outlineVariant = border;
  static const Color surfaceContainerLow = Color(0xFFF1F5F9);
}
