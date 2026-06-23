import 'package:flutter/material.dart';
import '../models/robot_mode.dart';
import 'dashboard_card.dart';

/// Selector de los tres modos de operación (manual, evasión, línea).
/// "Detener" NO va aquí: es una acción, no un modo, y vive en su propio botón.
class ModeSelector extends StatelessWidget {
  final RobotMode? activo;
  final ValueChanged<RobotMode> onSelect;

  const ModeSelector({super.key, required this.activo, required this.onSelect});

  // Solo modos reales de operación (sin la acción "detener").
  static const _modos = [RobotMode.manual, RobotMode.evasion, RobotMode.linea];

  @override
  Widget build(BuildContext context) {
    return DashboardCard(
      titulo: 'Modo de operación',
      icono: Icons.tune,
      child: Column(
        children: [
          for (final m in _modos)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _ModeTile(
                mode: m,
                activo: m == activo,
                onTap: () => onSelect(m),
              ),
            ),
        ],
      ),
    );
  }
}

class _ModeTile extends StatelessWidget {
  final RobotMode mode;
  final bool activo;
  final VoidCallback onTap;

  const _ModeTile(
      {required this.mode, required this.activo, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Activo: relleno sólido del color del modo (sin degradado ni glow).
    final fg = activo ? Colors.white : theme.colorScheme.onSurface;
    return Semantics(
      button: true,
      selected: activo,
      label: 'Modo ${mode.etiqueta}',
      child: Material(
        color: activo ? mode.color : theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Container(
            constraints: const BoxConstraints(minHeight: 56),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Row(
              children: [
                Icon(mode.icono,
                    color: activo ? Colors.white : theme.colorScheme.outline,
                    size: 24),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(mode.etiqueta,
                          style: theme.textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w600, color: fg)),
                      Text(mode.descripcion,
                          style: theme.textTheme.bodySmall?.copyWith(
                              color: activo
                                  ? Colors.white.withValues(alpha: 0.85)
                                  : theme.colorScheme.outline)),
                    ],
                  ),
                ),
                if (activo)
                  const Icon(Icons.check_circle, color: Colors.white, size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
