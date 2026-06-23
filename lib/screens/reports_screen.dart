import 'package:flutter/material.dart';
import '../services/event_logger.dart';
import '../theme/app_theme.dart';
import '../widgets/dashboard_card.dart';

/// Registro y reportes: historial completo de eventos.
class ReportsScreen extends StatelessWidget {
  final EventLogger logger;
  const ReportsScreen({super.key, required this.logger});

  Color _color(LogLevel level) => switch (level) {
        LogLevel.success => AppColors.verde,
        LogLevel.error => AppColors.rojo,
        LogLevel.warning => AppColors.ambar,
        LogLevel.info => AppColors.azul,
        LogLevel.tx => AppColors.morado,
        LogLevel.rx => AppColors.verde,
      };

  IconData _icono(LogLevel level) => switch (level) {
        LogLevel.success => Icons.check_circle_outline,
        LogLevel.error => Icons.error_outline,
        LogLevel.warning => Icons.warning_amber_outlined,
        LogLevel.info => Icons.info_outline,
        LogLevel.tx => Icons.arrow_outward,
        LogLevel.rx => Icons.arrow_downward,
      };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final eventos = logger.events.reversed.toList(); // más reciente arriba
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        DashboardCard(
          titulo: 'Historial de eventos',
          icono: Icons.history,
          accion: Row(
            children: [
              Text('${eventos.length}',
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: theme.colorScheme.outline)),
              IconButton(
                visualDensity: VisualDensity.compact,
                icon: const Icon(Icons.delete_outline, size: 18),
                tooltip: 'Limpiar',
                onPressed: logger.clear,
              ),
            ],
          ),
          child: eventos.isEmpty
              ? Text('Sin eventos registrados todavía.',
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: theme.colorScheme.outline))
              : Column(
                  children: eventos.map((e) {
                    final c = _color(e.level);
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(_icono(e.level), size: 16, color: c),
                          const SizedBox(width: 8),
                          Text(e.hora,
                              style: TextStyle(
                                  fontFamily: 'monospace',
                                  fontSize: 12,
                                  color: theme.colorScheme.outline)),
                          const SizedBox(width: 10),
                          Expanded(
                              child: Text(e.message,
                                  style: theme.textTheme.bodyMedium)),
                        ],
                      ),
                    );
                  }).toList(),
                ),
        ),
        const SizedBox(height: 12),
        DashboardCard(
          titulo: 'Exportar reporte',
          icono: Icons.file_download_outlined,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Más adelante se podrá guardar este historial como PDF o CSV.',
                style: theme.textTheme.bodySmall
                    ?.copyWith(color: theme.colorScheme.outline),
              ),
              const SizedBox(height: 10),
              OutlinedButton.icon(
                onPressed: null, // habilitado en el futuro
                icon: const Icon(Icons.download, size: 18),
                label: const Text('Exportar (próximamente)'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
