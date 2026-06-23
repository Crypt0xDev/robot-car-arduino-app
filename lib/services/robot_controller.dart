import 'package:flutter/foundation.dart';
import '../models/robot_mode.dart';
import 'bluetooth_service.dart';
import 'event_logger.dart';

/// Estado de alto nivel del robot (modo activo y velocidad), compartido
/// entre las pantallas de Control y Estado. Centraliza el envío de comandos.
class RobotController extends ChangeNotifier {
  final BluetoothService bt;
  final EventLogger logger;
  RobotController(this.bt, this.logger);

  RobotMode? mode;
  int speed = 150;

  /// Cambia de modo. Devuelve false si no hay conexión.
  bool setMode(RobotMode m) {
    if (!bt.isConnected) return false;
    mode = m;
    bt.send(m.comando);
    logger.log('Modo → ${m.etiqueta}', LogLevel.info);
    notifyListeners();
    return true;
  }

  void clearMode() {
    mode = null;
    notifyListeners();
  }

  /// Parada: envía '0' (IDLE en el firmware) y deja sin modo activo.
  void stop() {
    bt.send('0');
    mode = null;
    logger.log('Detener', LogLevel.warning);
    notifyListeners();
  }

  /// Envía un comando manual (WASD) sin cambiar el modo ni la velocidad
  void manual(String c) => bt.send(c, quiet: true);

  /// Cambia la velocidad de vista previa (sin enviar al robot). Para el slider
  void previewSpeed(int v) {
    speed = v;
    notifyListeners();
  }

  /// Fija la velocidad en el robot (comando `V<num>`).
  void commitSpeed(int v) {
    speed = v;
    bt.send('V$v\n');
    logger.log('Velocidad → $v', LogLevel.info);
    notifyListeners();
  }
}
