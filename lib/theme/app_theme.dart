import 'package:flutter/material.dart';

/// Colores, degradados, sombras y tema general de la aplicación.
class AppColors {
  static const Color azul = Color(0xFF1565C0);    // institucional / principal
  static const Color azulOscuro = Color(0xFF0D47A1);
  static const Color verde = Color(0xFF2E7D32);   // conexión / estados OK
  static const Color rojo = Color(0xFFC62828);    // detener / errores
  static const Color morado = Color(0xFF6A4AB7);  // seguimiento de línea
  static const Color ambar = Color(0xFFB26A00);   // advertencias

  static const LinearGradient banner = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [azul, azulOscuro],
  );
}

/// Sombras reutilizables para dar profundidad (efecto 3D sutil).
class AppShadows {
  static List<BoxShadow> suave(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return [
      BoxShadow(
        color: Colors.black.withValues(alpha: dark ? 0.35 : 0.10),
        blurRadius: 14,
        offset: const Offset(0, 6),
      ),
    ];
  }

  static List<BoxShadow> color(Color c, {double alpha = 0.40}) => [
        BoxShadow(
          color: c.withValues(alpha: alpha),
          blurRadius: 12,
          offset: const Offset(0, 5),
        ),
      ];
}

/// Tema Material 3 con soporte para modo claro y oscuro.
class AppTheme {
  static ThemeData _base(Brightness brillo) {
    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.azul,
      brightness: brillo,
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: scheme.surface,
      cardTheme: CardThemeData(
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        clipBehavior: Clip.antiAlias,
      ),
      sliderTheme: const SliderThemeData(
        trackHeight: 6,
      ),
    );
  }

  static ThemeData get light => _base(Brightness.light);
  static ThemeData get dark => _base(Brightness.dark);
}
