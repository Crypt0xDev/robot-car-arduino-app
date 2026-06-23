import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../theme/app_tokens.dart';
import 'live_clock.dart';

/// Encabezado del dashboard con información del robot, fecha/hora y estado de conexión.
class DashboardHeader extends StatelessWidget {
  final bool conectado;
  const DashboardHeader({super.key, this.conectado = false});

  static String _fechaHora(DateTime t) {
    const meses = [
      'ene', 'feb', 'mar', 'abr', 'may', 'jun',
      'jul', 'ago', 'sep', 'oct', 'nov', 'dic'
    ];
    final h = t.hour.toString().padLeft(2, '0');
    final m = t.minute.toString().padLeft(2, '0');
    final s = t.second.toString().padLeft(2, '0');
    return '${t.day} ${meses[t.month - 1]} ${t.year} · $h:$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppColors.banner,
        borderRadius: AppRadii.brLg,
        boxShadow: AppShadows.color(AppColors.azul, alpha: 0.45),
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Image.asset('assets/images/unsm.png',
                    fit: BoxFit.contain),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('RoboCar UNSM',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 19,
                            fontWeight: FontWeight.w700)),
                    Text('Control de robot · Física Aplicada',
                        style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.85),
                            fontSize: 12)),
                  ],
                ),
              ),
              _Punto(conectado: conectado),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _info(Icons.school_outlined, 'U. N. de San Martín'),
              // Reloj vivo: solo este texto se repinta cada segundo.
              LiveClock(
                builder: (context, ahora) =>
                    _info(Icons.schedule, _fechaHora(ahora)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _info(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: Colors.white.withValues(alpha: 0.85)),
        const SizedBox(width: 5),
        Text(text,
            style: TextStyle(
                color: Colors.white.withValues(alpha: 0.85), fontSize: 12)),
      ],
    );
  }
}

/// Punto de estado que parpadea suavemente cuando está conectado.
class _Punto extends StatefulWidget {
  final bool conectado;
  const _Punto({required this.conectado});
  @override
  State<_Punto> createState() => _PuntoState();
}

class _PuntoState extends State<_Punto>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 1100))
    ..repeat(reverse: true);

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.conectado ? AppColors.verde : Colors.white70;
    return FadeTransition(
      opacity: widget.conectado
          ? Tween(begin: 0.4, end: 1.0).animate(_c)
          : const AlwaysStoppedAnimation(0.6),
      child: Container(
        width: 12,
        height: 12,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          boxShadow: widget.conectado
              ? [BoxShadow(color: color, blurRadius: 8)]
              : null,
        ),
      ),
    );
  }
}
