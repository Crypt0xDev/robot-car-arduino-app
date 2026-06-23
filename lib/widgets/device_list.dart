import 'package:flutter/material.dart';
import '../models/bluetooth_device_info.dart';
import '../services/bluetooth_service.dart';
import 'dashboard_card.dart';

/// Lista de dispositivos Bluetooth encontrados, con selección rápida.
class DeviceList extends StatelessWidget {
  final BluetoothService bt;
  final void Function(BluetoothDeviceInfo) onSelect;

  const DeviceList({super.key, required this.bt, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (bt.devices.isEmpty) {
      return DashboardCard(
        titulo: 'Dispositivos',
        icono: Icons.devices_other,
        child: Text(
          bt.scanning ? 'Buscando...' : 'Pulsa "Buscar" para listar dispositivos.',
          style: theme.textTheme.bodySmall
              ?.copyWith(color: theme.colorScheme.outline),
        ),
      );
    }

    return DashboardCard(
      titulo: 'Dispositivos encontrados',
      icono: Icons.devices_other,
      child: Column(
        children: bt.devices.map((d) {
          final esHc05 = d.name.toUpperCase().contains('HC-05');
          final seleccionado = bt.connected?.address == d.address;
          return Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Material(
              color: seleccionado
                  ? theme.colorScheme.primaryContainer
                  : theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(10),
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: () => onSelect(d),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  child: Row(
                    children: [
                      Icon(esHc05 ? Icons.memory : Icons.bluetooth,
                          size: 20, color: theme.colorScheme.primary),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(d.name,
                                style: theme.textTheme.bodyMedium),
                            Text(d.address,
                                style: theme.textTheme.bodySmall?.copyWith(
                                    fontFamily: 'monospace',
                                    color: theme.colorScheme.outline)),
                          ],
                        ),
                      ),
                      if (d.rssi != null)
                        Text('${d.rssi} dBm',
                            style: theme.textTheme.bodySmall
                                ?.copyWith(color: theme.colorScheme.outline)),
                      if (seleccionado)
                        const Icon(Icons.check_circle,
                            size: 18, color: Colors.green),
                    ],
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
