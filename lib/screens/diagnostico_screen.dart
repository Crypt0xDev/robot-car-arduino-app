import 'package:flutter/material.dart';
import '../services/bluetooth_service.dart';
import '../theme/app_theme.dart';
import '../widgets/dashboard_card.dart';

/// Pantalla de diagnóstico: envía comandos sueltos al robot y muestra la
/// respuesta (telemetría) en vivo. Útil para probar el cableado y el firmware.
class DiagnosticoScreen extends StatelessWidget {
  final BluetoothService bt;
  const DiagnosticoScreen({super.key, required this.bt});

  void _enviar(BuildContext context, String cmd) {
    if (!bt.isConnected) {
      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(
            const SnackBar(content: Text('Conéctate al robot primero')));
      return;
    }
    bt.send(cmd);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        DashboardCard(
          titulo: 'Estado del enlace',
          icono: Icons.cell_tower,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _fila(theme, 'Conexión',
                  bt.isConnected ? 'Conectado' : 'Desconectado',
                  bt.isConnected ? AppColors.verde : AppColors.rojo),
              _fila(theme, 'Último comando enviado', bt.lastCommand, null),
              _fila(theme, 'Respuesta del robot', bt.lastTelemetry,
                  AppColors.verde),
            ],
          ),
        ),
        const SizedBox(height: 12),
        DashboardCard(
          titulo: 'Modos',
          icono: Icons.tune,
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _btn(context, 'Detener (0)', '0', AppColors.rojo),
              _btn(context, 'Manual (1)', '1', AppColors.azul),
              _btn(context, 'Evasión (2)', '2', AppColors.verde),
              _btn(context, 'Línea (3)', '3', AppColors.morado),
            ],
          ),
        ),
        const SizedBox(height: 12),
        DashboardCard(
          titulo: 'Movimiento (en modo Manual)',
          icono: Icons.gamepad_outlined,
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _btn(context, 'Adelante (F)', 'F', AppColors.azul),
              _btn(context, 'Atrás (B)', 'B', AppColors.azul),
              _btn(context, 'Izquierda (L)', 'L', AppColors.azul),
              _btn(context, 'Derecha (R)', 'R', AppColors.azul),
              _btn(context, 'Parar (S)', 'S', AppColors.rojo),
            ],
          ),
        ),
        const SizedBox(height: 12),
        DashboardCard(
          titulo: 'Velocidad',
          icono: Icons.speed,
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _btn(context, 'V100', 'V100\n', AppColors.ambar),
              _btn(context, 'V150', 'V150\n', AppColors.ambar),
              _btn(context, 'V200', 'V200\n', AppColors.ambar),
              _btn(context, 'V255', 'V255\n', AppColors.ambar),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Cada botón envía el comando crudo y verás la respuesta del robot '
          'arriba. Si tocas un modo y aparece "OK:..." el robot recibe; si no '
          'llega nada, revisa el Bluetooth (TX→D11) o el firmware.',
          style: theme.textTheme.bodySmall
              ?.copyWith(color: theme.colorScheme.outline),
        ),
      ],
    );
  }

  Widget _btn(BuildContext context, String texto, String cmd, Color color) {
    return FilledButton(
      style: FilledButton.styleFrom(backgroundColor: color),
      onPressed: () => _enviar(context, cmd),
      child: Text(texto),
    );
  }

  Widget _fila(ThemeData theme, String label, String valor, Color? color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(child: Text(label, style: theme.textTheme.bodyMedium)),
          Text(valor,
              style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: color,
                  fontFamily: 'monospace')),
        ],
      ),
    );
  }
}
