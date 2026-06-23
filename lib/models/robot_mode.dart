import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

///
enum RobotMode { manual, evasion, linea, detener }

extension RobotModeData on RobotMode {
  /// Caracter que entiende el firmware: 1=manual 2=evasion 3=linea 0=detener
  String get comando => switch (this) {
        RobotMode.manual => '1',
        RobotMode.evasion => '2',
        RobotMode.linea => '3',
        RobotMode.detener => '0',
      };

  String get etiqueta => switch (this) {
        RobotMode.manual => 'Manual',
        RobotMode.evasion => 'Evasión',
        RobotMode.linea => 'Línea',
        RobotMode.detener => 'Detener',
      };

  String get descripcion => switch (this) {
        RobotMode.manual => 'Control directo',
        RobotMode.evasion => 'Esquiva solo',
        RobotMode.linea => 'Sigue la línea',
        RobotMode.detener => 'Parada total',
      };

  IconData get icono => switch (this) {
        RobotMode.manual => Icons.gamepad_outlined,
        RobotMode.evasion => Icons.radar_outlined,
        RobotMode.linea => Icons.timeline_outlined,
        RobotMode.detener => Icons.stop_circle_outlined,
      };

  Color get color => switch (this) {
        RobotMode.manual => AppColors.azul,
        RobotMode.evasion => AppColors.verde,
        RobotMode.linea => AppColors.morado,
        RobotMode.detener => AppColors.rojo,
      };
}
