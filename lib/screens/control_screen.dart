import 'package:flutter/material.dart';
import '../models/robot_mode.dart';
import '../services/bluetooth_service.dart';
import '../services/robot_controller.dart';
import '../theme/app_theme.dart';
import '../widgets/dpad_control.dart';
import '../widgets/mode_selector.dart';
import '../widgets/speed_slider.dart';

/// Pantalla de control: selector de modos, D-pad, velocidad y parada.
class ControlScreen extends StatelessWidget {
  final BluetoothService bt;
  final RobotController ctrl;
  const ControlScreen({super.key, required this.bt, required this.ctrl});

  @override
  Widget build(BuildContext context) {
    final manual = ctrl.mode == RobotMode.manual;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ModeSelector(
          activo: ctrl.mode,
          onSelect: (m) {
            if (!ctrl.setMode(m)) {
              ScaffoldMessenger.of(context)
                ..clearSnackBars()
                ..showSnackBar(
                    const SnackBar(content: Text('Conéctate al robot primero')));
            }
          },
        ),
        const SizedBox(height: 12),
        // Parada: acción separada de los modos, siempre disponible.
        _BotonDetener(habilitado: bt.isConnected, onTap: ctrl.stop),
        const SizedBox(height: 12),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child: manual
              ? DpadControl(
                  key: const ValueKey('dpad'),
                  habilitado: bt.isConnected,
                  onSend: ctrl.manual,
                )
              : const SizedBox.shrink(key: ValueKey('nodpad')),
        ),
        const SizedBox(height: 12),
        SpeedSlider(
          habilitado: bt.isConnected,
          valor: ctrl.speed,
          onChanged: ctrl.previewSpeed,
          onChangeEnd: ctrl.commitSpeed,
        ),
      ],
    );
  }
}

class _BotonDetener extends StatelessWidget {
  final bool habilitado;
  final VoidCallback onTap;
  const _BotonDetener({required this.habilitado, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: FilledButton.icon(
        onPressed: habilitado ? onTap : null,
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.rojo,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)),
        ),
        icon: const Icon(Icons.stop_circle),
        label: const Text('DETENER',
            style: TextStyle(fontWeight: FontWeight.w700, letterSpacing: 0.5)),
      ),
    );
  }
}
