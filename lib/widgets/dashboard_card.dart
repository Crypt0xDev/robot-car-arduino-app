import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../theme/app_tokens.dart';

/// Tarjeta base reutilizable del dashboard (título, icono y contenido).
class DashboardCard extends StatelessWidget {
  final String? titulo;
  final IconData? icono;
  final Widget child;
  final Widget? accion;
  final Color? acento; // color de la línea/icono de acento

  const DashboardCard({
    super.key,
    this.titulo,
    this.icono,
    required this.child,
    this.accion,
    this.acento,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final acentoColor = acento ?? theme.colorScheme.primary;
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: AppRadii.brMd,
        border: Border.all(color: theme.colorScheme.outlineVariant, width: 0.6),
        boxShadow: AppShadows.suave(context),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (titulo != null) ...[
            Row(
              children: [
                if (icono != null) ...[
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: acentoColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(icono, size: 16, color: acentoColor),
                  ),
                  const SizedBox(width: 10),
                ],
                Text(titulo!,
                    style: theme.textTheme.titleSmall
                        ?.copyWith(fontWeight: FontWeight.w700)),
                const Spacer(),
                if (accion != null) accion!,
              ],
            ),
            const SizedBox(height: 14),
          ],
          child,
        ],
      ),
    );
  }
}
