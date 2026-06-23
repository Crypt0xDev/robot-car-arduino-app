import 'package:flutter/widgets.dart';

/// Espaciado (escala de 4 en 4).
class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 32;

  // Atajos como SizedBox para usar en columnas/filas.
  static const Widget gapXs = SizedBox(height: xs, width: xs);
  static const Widget gapSm = SizedBox(height: sm, width: sm);
  static const Widget gapMd = SizedBox(height: md, width: md);
  static const Widget gapLg = SizedBox(height: lg, width: lg);
  static const Widget gapXl = SizedBox(height: xl, width: xl);
}

/// Radios de esquina (una escala, no valores sueltos).
class AppRadii {
  static const double sm = 12;   // controles: botones, chips, celdas
  static const double md = 16;   // tarjetas
  static const double lg = 24;   // banners / cabeceras destacadas
  static const double pill = 999; // pastillas

  static const BorderRadius brSm = BorderRadius.all(Radius.circular(sm));
  static const BorderRadius brMd = BorderRadius.all(Radius.circular(md));
  static const BorderRadius brLg = BorderRadius.all(Radius.circular(lg));
}

/// Duraciones de animación (consistentes y discretas).
class AppDurations {
  static const Duration fast = Duration(milliseconds: 120);
  static const Duration normal = Duration(milliseconds: 220);
  static const Duration slow = Duration(milliseconds: 400);
}
