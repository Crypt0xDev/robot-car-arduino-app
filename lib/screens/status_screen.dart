import 'package:flutter/material.dart';
import '../models/robot_mode.dart';
import '../services/bluetooth_service.dart';
import '../services/robot_controller.dart';
import '../theme/app_theme.dart';
import '../widgets/dashboard_card.dart';
import '../widgets/live_clock.dart';

/// Panel técnico de Estado del Sistema.
class StatusScreen extends StatelessWidget {
  final BluetoothService bt;
  final RobotController ctrl;
  const StatusScreen({super.key, required this.bt, required this.ctrl});

  String _uptime(DateTime ahora) {
    if (bt.connectedSince == null) return '--:--';
    final d = ahora.difference(bt.connectedSince!);
    final m = d.inMinutes.toString().padLeft(2, '0');
    final s = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final conectado = bt.isConnected;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        DashboardCard(
          titulo: 'Estado del sistema',
          icono: Icons.monitor_heart_outlined,
          child: Column(
            children: [
              _Fila(
                  icon: Icons.bluetooth,
                  label: 'Bluetooth',
                  valor: conectado ? 'Conectado' : 'Desconectado',
                  color: conectado ? AppColors.verde : AppColors.rojo),
              _Fila(
                  icon: Icons.smart_toy_outlined,
                  label: 'Robot',
                  valor: conectado ? 'En línea' : 'Sin conexión',
                  color: conectado ? AppColors.verde : null),
              _Fila(
                  icon: Icons.devices,
                  label: 'Dispositivo',
                  valor: bt.connected?.name ?? '—'),
              // Reloj vivo: solo esta fila se actualiza cada segundo.
              LiveClock(
                builder: (context, ahora) => _Fila(
                    icon: Icons.timer_outlined,
                    label: 'Tiempo de conexión',
                    valor: _uptime(ahora)),
              ),
              _Fila(
                  icon: Icons.settings_suggest,
                  label: 'Modo activo',
                  valor: ctrl.mode?.etiqueta ?? '—',
                  color: ctrl.mode?.color),
              _Fila(
                  icon: Icons.speed,
                  label: 'Velocidad actual',
                  valor: '${ctrl.speed} / 255'),
              _Fila(
                  icon: Icons.terminal,
                  label: 'Último comando',
                  valor: bt.lastCommand,
                  mono: true),
              _Fila(
                  icon: Icons.cell_tower,
                  label: 'Respuesta del robot',
                  valor: bt.lastTelemetry,
                  mono: true),
            ],
          ),
        ),
        const SizedBox(height: 12),
        DashboardCard(
          titulo: 'Sensores',
          icono: Icons.sensors,
          child: Column(
            children: const [
              _Fila(
                  icon: Icons.straighten,
                  label: 'Ultrasónico (HC-SR04)',
                  valor: 'Sin telemetría'),
              _Fila(
                  icon: Icons.timeline,
                  label: 'Sensores de línea (QTR)',
                  valor: 'Sin telemetría'),
              _Fila(
                  icon: Icons.battery_unknown,
                  label: 'Batería',
                  valor: '—'),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Por ahora el robot no devuelve lecturas de sensores ni batería. '
          'Lo mostraremos aquí cuando agreguemos ese envío al firmware.',
          style: Theme.of(context)
              .textTheme
              .bodySmall
              ?.copyWith(color: Theme.of(context).colorScheme.outline),
        ),
      ],
    );
  }
}

class _Fila extends StatelessWidget {
  final IconData icon;
  final String label;
  final String valor;
  final Color? color;
  final bool mono;
  const _Fila(
      {required this.icon,
      required this.label,
      required this.valor,
      this.color,
      this.mono = false});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        children: [
          Icon(icon, size: 18, color: theme.colorScheme.outline),
          const SizedBox(width: 10),
          Expanded(
              child: Text(label, style: theme.textTheme.bodyMedium)),
          Text(valor,
              style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: color,
                  fontFamily: mono ? 'monospace' : null)),
        ],
      ),
    );
  }
}
