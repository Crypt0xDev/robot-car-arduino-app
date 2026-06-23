import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dashboard_card.dart';

/// D-pad de control manual: flechas de movimiento y parada central.
class DpadControl extends StatelessWidget {
  final bool habilitado;
  final void Function(String cmd) onSend;

  const DpadControl({
    super.key,
    required this.habilitado,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return DashboardCard(
      titulo: 'Control manual',
      icono: Icons.gamepad_outlined,
      child: Opacity(
        opacity: habilitado ? 1 : 0.4,
        child: IgnorePointer(
          ignoring: !habilitado,
          child: Column(
            children: [
              _DpadButton(
                  icon: Icons.keyboard_arrow_up,
                  label: 'Adelante',
                  onDown: () => onSend('F'),
                  onUp: () => onSend('S')),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _DpadButton(
                      icon: Icons.keyboard_arrow_left,
                      label: 'Izquierda',
                      onDown: () => onSend('L'),
                      onUp: () => onSend('S')),
                  const SizedBox(width: 8),
                  _DpadButton(
                      icon: Icons.stop,
                      label: 'Parar',
                      esStop: true,
                      onDown: () => onSend('S'),
                      onUp: () {}),
                  const SizedBox(width: 8),
                  _DpadButton(
                      icon: Icons.keyboard_arrow_right,
                      label: 'Derecha',
                      onDown: () => onSend('R'),
                      onUp: () => onSend('S')),
                ],
              ),
              const SizedBox(height: 8),
              _DpadButton(
                  icon: Icons.keyboard_arrow_down,
                  label: 'Atrás',
                  onDown: () => onSend('B'),
                  onUp: () => onSend('S')),
            ],
          ),
        ),
      ),
    );
  }
}

class _DpadButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final VoidCallback onDown;
  final VoidCallback onUp;
  final bool esStop;

  const _DpadButton({
    required this.icon,
    required this.label,
    required this.onDown,
    required this.onUp,
    this.esStop = false,
  });

  @override
  State<_DpadButton> createState() => _DpadButtonState();
}

class _DpadButtonState extends State<_DpadButton> {
  bool _presionado = false;
  Timer? _heartbeat;

  void _down() {
    setState(() => _presionado = true);
    HapticFeedback.lightImpact();
    widget.onDown();
    // Reenvia el comando mientras se mantiene presionado, asi el robot no se
    // detiene por el failsafe del firmware mientras haya conexion.
    if (!widget.esStop) {
      _heartbeat = Timer.periodic(
          const Duration(milliseconds: 250), (_) => widget.onDown());
    }
  }

  void _up() {
    _heartbeat?.cancel();
    setState(() => _presionado = false);
    widget.onUp();
  }

  @override
  void dispose() {
    _heartbeat?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    // Colores del esquema M3 (adaptan a claro/oscuro). Sin degradado ni glow.
    final base = widget.esStop ? scheme.errorContainer : scheme.primaryContainer;
    final fg = widget.esStop ? scheme.onErrorContainer : scheme.onPrimaryContainer;
    return Semantics(
      button: true,
      label: widget.label,
      child: GestureDetector(
        onTapDown: (_) => _down(),
        onTapUp: (_) => _up(),
        onTapCancel: _up,
        child: AnimatedScale(
          scale: _presionado ? 0.94 : 1.0,
          duration: const Duration(milliseconds: 90),
          child: Container(
            width: 76,
            height: 56,
            decoration: BoxDecoration(
              // Al presionar se oscurece levemente (feedback sin sombra de color).
              color: _presionado
                  ? Color.alphaBlend(fg.withValues(alpha: 0.12), base)
                  : base,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(widget.icon, size: 32, color: fg),
          ),
        ),
      ),
    );
  }
}
