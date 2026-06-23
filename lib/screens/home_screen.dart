import 'package:flutter/material.dart';
import '../models/robot_mode.dart';
import '../services/bluetooth_service.dart';
import '../services/robot_controller.dart';
import '../theme/app_theme.dart';
import '../widgets/dashboard_card.dart';
import '../widgets/dashboard_header.dart';

/// Pantalla de inicio: resumen del estado y accesos rápidos.
class HomeScreen extends StatelessWidget {
  final BluetoothService bt;
  final RobotController ctrl;
  final void Function(int index) onNavigate;

  const HomeScreen({
    super.key,
    required this.bt,
    required this.ctrl,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final conectado = bt.isConnected;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        DashboardHeader(conectado: conectado),
        const SizedBox(height: 12),
        DashboardCard(
          titulo: 'Resumen',
          icono: Icons.dashboard_outlined,
          child: GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 2.4,
            children: [
              _mini(theme, Icons.bluetooth, 'Conexión',
                  conectado ? 'Conectado' : 'Desconectado',
                  conectado ? AppColors.verde : AppColors.rojo),
              _mini(theme, Icons.settings_suggest, 'Modo',
                  ctrl.mode?.etiqueta ?? '—', ctrl.mode?.color),
              _mini(theme, Icons.speed, 'Velocidad', '${ctrl.speed}', null),
              _mini(theme, Icons.devices, 'Dispositivo',
                  bt.connected?.name ?? '—', null),
            ],
          ),
        ),
        const SizedBox(height: 12),
        DashboardCard(
          titulo: 'Accesos rápidos',
          icono: Icons.bolt,
          child: Column(
            children: [
              _acceso(context, Icons.gamepad_outlined, 'Control del robot',
                  'Modos, D-pad y velocidad', 1),
              _acceso(context, Icons.bluetooth_searching, 'Dispositivos',
                  'Buscar y conectar el HC-05', 2),
              _acceso(context, Icons.monitor_heart_outlined, 'Estado',
                  'Panel técnico del sistema', 3),
            ],
          ),
        ),
      ],
    );
  }

  Widget _mini(ThemeData theme, IconData i, String label, String v, Color? c) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Icon(i, size: 14, color: theme.colorScheme.outline),
            const SizedBox(width: 4),
            Text(label,
                style: theme.textTheme.bodySmall
                    ?.copyWith(color: theme.colorScheme.outline)),
          ]),
          const SizedBox(height: 2),
          Text(v,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.w700, color: c)),
        ],
      ),
    );
  }

  Widget _acceso(BuildContext c, IconData i, String t, String s, int idx) {
    final theme = Theme.of(c);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Material(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => onNavigate(idx),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(children: [
              Icon(i, color: AppColors.azul),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(t,
                        style: theme.textTheme.bodyMedium
                            ?.copyWith(fontWeight: FontWeight.w600)),
                    Text(s,
                        style: theme.textTheme.bodySmall
                            ?.copyWith(color: theme.colorScheme.outline)),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ]),
          ),
        ),
      ),
    );
  }
}
