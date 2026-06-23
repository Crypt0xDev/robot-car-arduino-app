import 'package:flutter/material.dart';
import 'dashboard_card.dart';

/// Control de velocidad. Mientras se arrastra actualiza el valor; al
/// soltar envía el comando `V<valor>` al robot (firmware).
class SpeedSlider extends StatelessWidget {
  final bool habilitado;
  final int valor; // 0-255
  final ValueChanged<int> onChanged;   // arrastre (solo UI)
  final ValueChanged<int> onChangeEnd; // al soltar (envía al robot)

  const SpeedSlider({
    super.key,
    required this.habilitado,
    required this.valor,
    required this.onChanged,
    required this.onChangeEnd,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final pct = (valor / 255 * 100).round();
    return DashboardCard(
      titulo: 'Velocidad',
      icono: Icons.speed,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('$pct%',
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: theme.colorScheme.outline)),
              Text('$valor / 255',
                  style: theme.textTheme.titleSmall
                      ?.copyWith(fontWeight: FontWeight.w600)),
            ],
          ),
          Slider(
            value: valor.toDouble(),
            min: 0,
            max: 255,
            divisions: 51,
            label: '$valor',
            onChanged:
                habilitado ? (v) => onChanged(v.round()) : null,
            onChangeEnd:
                habilitado ? (v) => onChangeEnd(v.round()) : null,
          ),
        ],
      ),
    );
  }
}
