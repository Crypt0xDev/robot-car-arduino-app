import 'dart:async';
import 'package:flutter/widgets.dart';

/// Reloj "vivo": se reconstruye solo a sí mismo cada [intervalo] y entrega la
/// hora actual a su [builder]. Evita hacer setState en pantallas completas
/// (mejor rendimiento: solo este widget se repinta, no todo el árbol).
class LiveClock extends StatefulWidget {
  final Duration intervalo;
  final Widget Function(BuildContext context, DateTime ahora) builder;

  const LiveClock({
    super.key,
    required this.builder,
    this.intervalo = const Duration(seconds: 1),
  });

  @override
  State<LiveClock> createState() => _LiveClockState();
}

class _LiveClockState extends State<LiveClock> {
  late DateTime _ahora = DateTime.now();
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(widget.intervalo, (_) {
      if (mounted) setState(() => _ahora = DateTime.now());
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.builder(context, _ahora);
}
