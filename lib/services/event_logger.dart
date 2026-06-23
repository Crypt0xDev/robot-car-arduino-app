import 'package:flutter/foundation.dart';

enum LogLevel { info, success, warning, error, tx, rx }

class LogEvent {
  final DateTime time;
  final String message;
  final LogLevel level;
  const LogEvent(this.time, this.message, this.level);

  String get hora =>
      '${time.hour.toString().padLeft(2, '0')}:'
      '${time.minute.toString().padLeft(2, '0')}:'
      '${time.second.toString().padLeft(2, '0')}';
}

/// Registro de eventos (conexión, cambios de modo, comandos enviados).
/// Es un ChangeNotifier para que la consola se actualice sola.
class EventLogger extends ChangeNotifier {
  final List<LogEvent> _events = [];
  List<LogEvent> get events => List.unmodifiable(_events);

  void log(String message, [LogLevel level = LogLevel.info]) {
    _events.add(LogEvent(DateTime.now(), message, level));
    if (_events.length > 100) _events.removeAt(0); // límite de memoria
    notifyListeners();
  }

  void clear() {
    _events.clear();
    notifyListeners();
  }
}
