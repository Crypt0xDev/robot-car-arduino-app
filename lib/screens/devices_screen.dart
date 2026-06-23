import 'package:flutter/material.dart';
import '../models/bluetooth_device_info.dart';
import '../services/bluetooth_service.dart';
import '../widgets/connection_card.dart';
import '../widgets/device_list.dart';

/// Pantalla de dispositivos: busca y muestra los Bluetooth disponibles
/// automáticamente al abrirla, y permite conectarse.
class DevicesScreen extends StatefulWidget {
  final BluetoothService bt;
  final VoidCallback onDisconnect;
  const DevicesScreen({super.key, required this.bt, required this.onDisconnect});

  @override
  State<DevicesScreen> createState() => _DevicesScreenState();
}

class _DevicesScreenState extends State<DevicesScreen> {
  @override
  void initState() {
    super.initState();
    // Auto-escaneo al abrir: muestra los dispositivos disponibles sin que el
    // usuario tenga que pulsar "Buscar". Solo si no hay nada listado todavía.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.bt.devices.isEmpty && !widget.bt.scanning) {
        widget.bt.scan();
      }
    });
  }

  Future<void> _conectar(BluetoothDeviceInfo d) async {
    await widget.bt.connect(d);
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(SnackBar(
          content: Text(widget.bt.isConnected
              ? 'Conectado a ${d.name}'
              : 'No se pudo conectar')));
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ConnectionCard(
            bt: widget.bt,
            onScan: widget.bt.scan,
            onDisconnect: widget.onDisconnect),
        const SizedBox(height: 12),
        DeviceList(bt: widget.bt, onSelect: _conectar),
      ],
    );
  }
}
