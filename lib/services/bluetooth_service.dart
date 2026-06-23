import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:permission_handler/permission_handler.dart';
import '../models/bluetooth_device_info.dart';
import 'event_logger.dart';

enum ConnectionStatus { disconnected, connecting, connected }

/// Encapsula toda la lógica de Bluetooth: permisos, búsqueda, conexión y
/// envío de comandos. La UI solo escucha sus cambios (ChangeNotifier).
class BluetoothService extends ChangeNotifier {
  final EventLogger logger;
  BluetoothService(this.logger);

  ConnectionStatus status = ConnectionStatus.disconnected;
  List<BluetoothDeviceInfo> devices = [];
  BluetoothDeviceInfo? connected;
  DateTime? connectedSince;
  bool scanning = false;
  String lastCommand = '—';
  String lastTelemetry = '—'; // última respuesta recibida del robot

  BluetoothConnection? _conn;
  StreamSubscription? _discoverySub;
  String _rxBuffer = ''; // acumula bytes hasta completar una línea

  bool get isConnected => status == ConnectionStatus.connected;

  Future<bool> _pedirPermisos() async {
    final r = await [
      Permission.bluetoothConnect,
      Permission.bluetoothScan,
      Permission.locationWhenInUse,
    ].request();
    return r.values.every((p) => p.isGranted);
  }

  /// Pide todos los permisos de Bluetooth de una vez. Pensado para llamarlo
  /// al abrir la app por primera vez, asi no falta ninguno despues.
  Future<bool> solicitarPermisos() => _pedirPermisos();

  /// Lista los dispositivos emparejados y busca los cercanos.
  Future<void> scan() async {
    if (scanning) return; // evita escaneos solapados
    if (!await _pedirPermisos()) {
      logger.log('Permisos de Bluetooth denegados', LogLevel.error);
      return;
    }
    // Si el Bluetooth del telefono esta apagado, pedir activarlo.
    final encendido =
        await FlutterBluetoothSerial.instance.isEnabled ?? false;
    if (!encendido) {
      await FlutterBluetoothSerial.instance.requestEnable();
    }
    scanning = true;
    devices = [];
    notifyListeners();
    logger.log('Buscando dispositivos...');

    try {
      final bonded =
          await FlutterBluetoothSerial.instance.getBondedDevices();
      devices = bonded
          .map((d) => BluetoothDeviceInfo(
                name: d.name ?? 'Desconocido',
                address: d.address,
              ))
          .toList();
      notifyListeners();
    } catch (_) {
      logger.log('No se pudieron leer los emparejados', LogLevel.error);
    }

    _discoverySub?.cancel();
    try {
      _discoverySub =
          FlutterBluetoothSerial.instance.startDiscovery().listen((r) {
        final info = BluetoothDeviceInfo(
          name: r.device.name ?? 'Desconocido',
          address: r.device.address,
          rssi: r.rssi,
        );
        final i = devices.indexWhere((d) => d.address == info.address);
        if (i >= 0) {
          devices[i] = info;
        } else {
          devices.add(info);
        }
        notifyListeners();
      });
      _discoverySub!.onDone(() {
        scanning = false;
        notifyListeners();
      });
    } catch (_) {
      scanning = false;
      notifyListeners();
    }
  }

  Future<void> connect(BluetoothDeviceInfo info) async {
    if (status == ConnectionStatus.connecting) return; // ya conectando
    status = ConnectionStatus.connecting;
    notifyListeners();
    logger.log('Conectando a ${info.name}...');
    try {
      _conn = await BluetoothConnection.toAddress(info.address);
      connected = info;
      connectedSince = DateTime.now();
      status = ConnectionStatus.connected;
      _rxBuffer = '';
      logger.log('Conectado a ${info.name}', LogLevel.success);
      _conn!.input?.listen(_alRecibir).onDone(_alDesconectar);
    } catch (_) {
      status = ConnectionStatus.disconnected;
      logger.log('No se pudo conectar a ${info.name}', LogLevel.error);
    }
    notifyListeners();
  }

  /// Procesa los datos que envía el robot (telemetría). Acumula bytes hasta
  /// completar una línea (terminada en \n) y la registra en el log.
  void _alRecibir(Uint8List datos) {
    _rxBuffer += utf8.decode(datos, allowMalformed: true);
    int i;
    while ((i = _rxBuffer.indexOf('\n')) >= 0) {
      final linea = _rxBuffer.substring(0, i).trim();
      _rxBuffer = _rxBuffer.substring(i + 1);
      if (linea.isNotEmpty) {
        lastTelemetry = linea;
        logger.log('Robot: $linea', LogLevel.rx);
        notifyListeners();
      }
    }
  }

  void _alDesconectar() {
    if (status == ConnectionStatus.disconnected) return;
    status = ConnectionStatus.disconnected;
    connected = null;
    connectedSince = null;
    logger.log('Conexión perdida', LogLevel.warning);
    notifyListeners();
  }

  Future<void> disconnect() async {
    try {
      await _conn?.close();
    } catch (_) {}
    _conn = null;
    status = ConnectionStatus.disconnected;
    connected = null;
    connectedSince = null;
    logger.log('Desconectado');
    notifyListeners();
  }

  /// Envía un comando (texto) al robot. quiet evita llenar la consola
  /// con comandos muy repetitivos (ej. el slider durante el arrastre).
  void send(String cmd, {bool quiet = false}) {
    if (!isConnected || _conn == null) return;
    _conn!.output.add(Uint8List.fromList(utf8.encode(cmd)));
    lastCommand = cmd.trim();
    if (!quiet) logger.log('TX: $cmd', LogLevel.tx);
    notifyListeners();
  }

  @override
  void dispose() {
    _discoverySub?.cancel();
    _conn?.dispose();
    super.dispose();
  }
}
