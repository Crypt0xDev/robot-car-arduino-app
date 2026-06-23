import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/dashboard_card.dart';

/// Información del proyecto + documentación técnica.
class ProjectInfoScreen extends StatelessWidget {
  const ProjectInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        DashboardCard(
          titulo: 'Robot Car 2WD Multifunción',
          icono: Icons.smart_toy_outlined,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _p(context,
                  'Carro robot de dos ruedas con Arduino UNO que se maneja por '
                  'Bluetooth desde el celular. Puede conducirse a mano, esquivar '
                  'obstáculos por su cuenta o seguir una línea negra en el piso.'),
              const SizedBox(height: 12),
              _sub(context, 'Objetivos'),
              _bullet(context,
                  'Armar y programar el robot con Arduino para el curso de '
                  'Física Aplicada.'),
              _bullet(context,
                  'Medir distancias con el ultrasónico y reaccionar a los '
                  'obstáculos.'),
              _bullet(context,
                  'Manejarlo desde una app propia hecha en Flutter.'),
              const SizedBox(height: 12),
              _sub(context, 'Problema que resuelve'),
              _p(context,
                  'En clase vemos la teoría de movimiento, sensores y control. '
                  'Aquí esa teoría se ve funcionando: el robot calcula a qué '
                  'distancia tiene un objeto, decide hacia dónde girar y responde '
                  'a lo que le mandamos desde el celular.'),
            ],
          ),
        ),
        const SizedBox(height: 12),
        DashboardCard(
          titulo: 'Tecnologías utilizadas',
          icono: Icons.code,
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: const [
              _Chip('Arduino C/C++'),
              _Chip('Flutter / Dart'),
              _Chip('Material 3'),
              _Chip('Bluetooth SPP'),
              _Chip('PWM / control'),
            ],
          ),
        ),
        const SizedBox(height: 12),
        DashboardCard(
          titulo: 'Hardware y sensores',
          icono: Icons.memory,
          child: Column(
            children: const [
              _Item(Icons.developer_board, 'Arduino UNO R3', 'Microcontrolador'),
              _Item(Icons.electrical_services, 'Driver L298N', 'Control de motores'),
              _Item(Icons.straighten, 'HC-SR04', 'Sensor ultrasónico'),
              _Item(Icons.threed_rotation, 'Servo SG-90', 'Escaneo del sensor'),
              _Item(Icons.timeline, 'QTR-8A', 'Sensores de línea (IR)'),
              _Item(Icons.bluetooth, 'HC-05', 'Comunicación Bluetooth'),
            ],
          ),
        ),
        const SizedBox(height: 12),
        DashboardCard(
          titulo: 'Diagrama general del sistema',
          icono: Icons.account_tree_outlined,
          child: const _Diagrama(),
        ),
        const SizedBox(height: 12),
        DashboardCard(
          titulo: 'Documentación técnica',
          icono: Icons.description_outlined,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _sub(context, 'Pines (Arduino UNO)'),
              _pin(context, 'Motores L298N', 'ENA 5 · ENB 6 · IN1-4 7-10'),
              _pin(context, 'HC-SR04', 'TRIG 2 · ECHO 4'),
              _pin(context, 'Servo SG-90', 'D3 (PWM)'),
              _pin(context, 'HC-05', 'RX 11 · TX 12'),
              _pin(context, 'QTR-8A', 'A0-A4 (5 canales)'),
              const SizedBox(height: 12),
              _sub(context, 'Protocolo Bluetooth'),
              _p(context,
                  '9600 baud. Comandos de 1 carácter: 0/1/2/3 (modo), '
                  'F/B/L/R/S (movimiento), +/- y V<n> (velocidad).'),
              const SizedBox(height: 12),
              _sub(context, 'Versiones'),
              _pin(context, 'App', 'Flutter 3.44 · v1.0'),
              _pin(context, 'Firmware', 'robot_car.ino · v1.0'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _p(BuildContext c, String t) => Text(t,
      style: Theme.of(c).textTheme.bodyMedium?.copyWith(height: 1.5));
  Widget _sub(BuildContext c, String t) => Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Text(t,
            style: Theme.of(c)
                .textTheme
                .titleSmall
                ?.copyWith(fontWeight: FontWeight.w700)),
      );
  Widget _bullet(BuildContext c, String t) => Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('•  '),
          Expanded(child: Text(t, style: Theme.of(c).textTheme.bodyMedium)),
        ]),
      );
  Widget _pin(BuildContext c, String k, String v) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(k, style: Theme.of(c).textTheme.bodyMedium),
            Text(v,
                style: Theme.of(c).textTheme.bodySmall?.copyWith(
                    fontFamily: 'monospace',
                    color: Theme.of(c).colorScheme.outline)),
          ],
        ),
      );
}

class _Chip extends StatelessWidget {
  final String texto;
  const _Chip(this.texto);
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.azul.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(texto,
          style: theme.textTheme.bodySmall
              ?.copyWith(color: AppColors.azul, fontWeight: FontWeight.w600)),
    );
  }
}

class _Item extends StatelessWidget {
  final IconData icon;
  final String titulo, sub;
  const _Item(this.icon, this.titulo, this.sub);
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(children: [
        Icon(icon, size: 20, color: AppColors.azul),
        const SizedBox(width: 12),
        Expanded(child: Text(titulo, style: theme.textTheme.bodyMedium)),
        Text(sub,
            style: theme.textTheme.bodySmall
                ?.copyWith(color: theme.colorScheme.outline)),
      ]),
    );
  }
}

class _Diagrama extends StatelessWidget {
  const _Diagrama();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _caja(context, 'App Android (Bluetooth)', AppColors.azul),
        _flecha(),
        _caja(context, 'HC-05  ·  Arduino UNO', AppColors.morado),
        _flecha(),
        Row(
          children: [
            Expanded(child: _caja(context, 'L298N → Motores', AppColors.verde)),
            const SizedBox(width: 8),
            Expanded(
                child: _caja(context, 'HC-SR04 · Servo · QTR', AppColors.ambar)),
          ],
        ),
      ],
    );
  }

  Widget _caja(BuildContext c, String t, Color color) => Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.5)),
        ),
        child: Text(t,
            textAlign: TextAlign.center,
            style: TextStyle(color: color, fontWeight: FontWeight.w600)),
      );
  Widget _flecha() => const Padding(
        padding: EdgeInsets.symmetric(vertical: 4),
        child: Icon(Icons.keyboard_arrow_down, size: 22),
      );
}
