import 'package:flutter/material.dart';
import '../services/bluetooth_service.dart';
import '../theme/app_theme.dart';
import 'dashboard_card.dart';

/// Tarjeta de estado Bluetooth: conexión, dispositivo y botones.
class ConnectionCard extends StatelessWidget {
  final BluetoothService bt;
  final VoidCallback onScan;
  final VoidCallback onDisconnect;

  const ConnectionCard({
    super.key,
    required this.bt,
    required this.onScan,
    required this.onDisconnect,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final conectado = bt.status == ConnectionStatus.connected;
    final conectando = bt.status == ConnectionStatus.connecting;

    final (color, texto, icono) = switch (bt.status) {
      ConnectionStatus.connected => (
          AppColors.verde,
          'Conectado',
          Icons.bluetooth_connected
        ),
      ConnectionStatus.connecting => (
          AppColors.ambar,
          'Conectando...',
          Icons.bluetooth_searching
        ),
      ConnectionStatus.disconnected => (
          theme.colorScheme.outline,
          'Desconectado',
          Icons.bluetooth_disabled
        ),
    };

    return DashboardCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              AnimatedScale(
                scale: conectando ? 1.15 : 1.0,
                duration: const Duration(milliseconds: 500),
                child: Icon(icono, color: color, size: 22),
              ),
              const SizedBox(width: 8),
              Text(texto,
                  style: theme.textTheme.titleSmall
                      ?.copyWith(color: color, fontWeight: FontWeight.w600)),
            ],
          ),
          if (conectado && bt.connected != null) ...[
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(bt.connected!.name,
                    style: theme.textTheme.bodyMedium),
                Text(bt.connected!.address,
                    style: theme.textTheme.bodySmall?.copyWith(
                        fontFamily: 'monospace',
                        color: theme.colorScheme.outline)),
              ],
            ),
          ],
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: bt.scanning ? null : onScan,
                  icon: bt.scanning
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2))
                      : const Icon(Icons.search, size: 18),
                  label: const Text('Buscar'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: conectado ? onDisconnect : null,
                  style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.rojo),
                  icon: const Icon(Icons.link_off, size: 18),
                  label: const Text('Desconectar'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
