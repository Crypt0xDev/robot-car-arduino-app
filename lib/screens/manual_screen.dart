import 'package:flutter/material.dart';
import '../widgets/dashboard_card.dart';

/// Manual de usuario y preguntas frecuentes.
class ManualScreen extends StatelessWidget {
  const ManualScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        DashboardCard(
          titulo: 'Guía de uso',
          icono: Icons.menu_book_outlined,
          child: Column(
            children: const [
              _Paso(
                  n: '1',
                  titulo: 'Conectar el Bluetooth',
                  texto:
                      'Enciende el robot. En el celular, empareja el módulo '
                      'HC-05 desde Ajustes → Bluetooth (PIN 1234 o 0000). '
                      'Esto se hace una sola vez.'),
              _Paso(
                  n: '2',
                  titulo: 'Seleccionar el dispositivo',
                  texto:
                      'En la pantalla Dispositivos pulsa "Buscar", elige '
                      'HC-05 de la lista y la app se conectará. El estado '
                      'cambiará a "Conectado".'),
              _Paso(
                  n: '3',
                  titulo: 'Elegir un modo',
                  texto:
                      'En Control elige el modo: Manual (manejas tú), '
                      'Evasión (esquiva obstáculos solo) o Línea (sigue una '
                      'línea negra). "Detener" frena el robot.'),
              _Paso(
                  n: '4',
                  titulo: 'Control manual',
                  texto:
                      'En modo Manual aparece el D-pad. Mantén presionada una '
                      'flecha para mover el robot; al soltar, se detiene.'),
              _Paso(
                  n: '5',
                  titulo: 'Control de velocidad',
                  texto:
                      'Mueve el slider de Velocidad. El valor se envía al '
                      'robot al soltar (0 a 255).'),
            ],
          ),
        ),
        const SizedBox(height: 12),
        const DashboardCard(
          titulo: 'Solución de problemas',
          icono: Icons.build_outlined,
          child: Column(
            children: [
              _Faq(
                  p: 'No aparece el HC-05 al buscar',
                  r: 'Verifica que el robot esté encendido y que hayas '
                      'emparejado el HC-05 antes desde Ajustes → Bluetooth.'),
              _Faq(
                  p: 'Se conecta pero el robot no se mueve',
                  r: 'Revisa que estés en modo Manual, que la batería tenga '
                      'carga y que el L298N reciba alimentación. Sube la '
                      'velocidad si está muy baja.'),
              _Faq(
                  p: 'Se desconecta solo',
                  r: 'Puede ser distancia o batería baja del HC-05. Acércate '
                      'al robot y revisa la alimentación.'),
            ],
          ),
        ),
        const SizedBox(height: 12),
        const DashboardCard(
          titulo: 'Preguntas frecuentes',
          icono: Icons.help_outline,
          child: Column(
            children: [
              _Faq(
                  p: '¿Funciona en iPhone?',
                  r: 'No. El HC-05 es Bluetooth Clásico y Apple no lo permite. '
                      'Usa un teléfono Android.'),
              _Faq(
                  p: '¿Puedo usar varios modos a la vez?',
                  r: 'No, los modos son excluyentes: el robot opera en uno por '
                      'vez. Cambia cuando quieras desde Control.'),
              _Faq(
                  p: '¿La velocidad afecta a los modos autónomos?',
                  r: 'Sí, define la velocidad base con la que se mueve el '
                      'robot en todos los modos.'),
            ],
          ),
        ),
      ],
    );
  }
}

class _Paso extends StatelessWidget {
  final String n, titulo, texto;
  const _Paso({required this.n, required this.titulo, required this.texto});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 13,
            backgroundColor: theme.colorScheme.primaryContainer,
            child: Text(n,
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: theme.colorScheme.onPrimaryContainer)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(titulo,
                    style: theme.textTheme.bodyMedium
                        ?.copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                Text(texto,
                    style: theme.textTheme.bodySmall
                        ?.copyWith(color: theme.colorScheme.outline)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Faq extends StatelessWidget {
  final String p, r;
  const _Faq({required this.p, required this.r});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Theme(
      data: theme.copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        tilePadding: EdgeInsets.zero,
        childrenPadding: const EdgeInsets.only(bottom: 10),
        title: Text(p,
            style: theme.textTheme.bodyMedium
                ?.copyWith(fontWeight: FontWeight.w600)),
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(r,
                style: theme.textTheme.bodySmall
                    ?.copyWith(color: theme.colorScheme.outline)),
          ),
        ],
      ),
    );
  }
}
