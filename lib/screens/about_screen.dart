import 'package:flutter/material.dart';
import 'package:simple_icons/simple_icons.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/app_theme.dart';
import '../widgets/dashboard_card.dart';

// ── Autor / dueño de la aplicación ── //
const String _autor = 'Gonzales Perez Alexis Noe';
const String _autorAlias = '@Crypt0xDev';

// Redes del autor: (logo de marca, color de marca, URL, etiqueta)
const List<(IconData, Color, String, String)> _redes = [
  (SimpleIcons.github, Color(0xFF181717), 'https://github.com/Crypt0xDev', 'GitHub'),
  (SimpleIcons.x, Color(0xFF000000), 'https://x.com/Crypt0xDev', 'X'),
  (SimpleIcons.youtube, Color(0xFFFF0000), 'https://www.youtube.com/@Crypt0xDev', 'YouTube'),
  (SimpleIcons.twitch, Color(0xFF9146FF), 'https://www.twitch.tv/crypt0xdev', 'Twitch'),
  (SimpleIcons.instagram, Color(0xFFE4405F), 'https://www.instagram.com/crypt0xdev', 'Instagram'),
];

// ── Datos del equipo ── //
const String _facultad = 'Facultad de Ingeniería de Sistemas e Informática';
const String _escuela = 'Escuela Profesional de Ingeniería de Sistemas e Informática';
const String _curso = 'Física Aplicada';
const String _docente = 'Ing. Carlos Armando Ríos López';
const String _anio = '2026';
const List<String> _integrantes = [
  'Majuan Bustamante Victor Daniel',
  'Gonzales Perez Alexis Noe',
  'Lopez Jimenez Favio Rafael ',
  'Paredes Vásquez Angel Gabriel',
];

// ── Pantalla "Acerca de" con información del equipo y datos académicos ── //
class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: AppColors.banner,
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.fromLTRB(20, 22, 20, 22),
          child: Column(
            children: [
              // Escudos institucionales (UNSM a la izquierda, Facultad a la derecha).
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _Escudo(asset: 'assets/images/unsm.png'),
                  const SizedBox(width: 18),
                  _Escudo(asset: 'assets/images/facultad.png'),
                ],
              ),
              const SizedBox(height: 14),
              const Text('Universidad Nacional de San Martín',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w700)),
              const SizedBox(height: 4),
              Text(_facultad,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.90),
                      fontSize: 12)),
            ],
          ),
        ),
        const SizedBox(height: 12),
        DashboardCard(
          titulo: 'Autor de la aplicación',
          icono: Icons.verified_user_outlined,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: AppColors.azul.withValues(alpha: 0.15),
                    child: const Text('AN',
                        style: TextStyle(
                            color: AppColors.azul,
                            fontWeight: FontWeight.w700,
                            fontSize: 16)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(_autor,
                            style: theme.textTheme.bodyLarge
                                ?.copyWith(fontWeight: FontWeight.w700)),
                        Text('$_autorAlias · Desarrollador',
                            style: theme.textTheme.bodySmall
                                ?.copyWith(color: theme.colorScheme.outline)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  for (final r in _redes)
                    _Red(icono: r.$1, color: r.$2, url: r.$3, label: r.$4),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        DashboardCard(
          titulo: 'Equipo de desarrollo',
          icono: Icons.groups_outlined,
          child: Column(
            children: [
              for (var i = 0; i < _integrantes.length; i++)
                _Integrante(
                    nombre: _integrantes[i],
                    principal: _integrantes[i].contains('Alexis')),
            ],
          ),
        ),
        const SizedBox(height: 12),
        DashboardCard(
          titulo: 'Datos académicos',
          icono: Icons.menu_book_outlined,
          child: Column(
            children: [
              _dato(context, Icons.account_balance, 'Escuela', _escuela),
              _dato(context, Icons.class_outlined, 'Curso', _curso),
              _dato(context, Icons.person_outline, 'Docente / asesor', _docente),
              _dato(context, Icons.event, 'Año académico', _anio),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Center(
          child: Text('RoboCar UNSM · v1.0',
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: theme.colorScheme.outline)),
        ),
      ],
    );
  }

  Widget _dato(BuildContext c, IconData i, String k, String v) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 7),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Icon(i, size: 18, color: Theme.of(c).colorScheme.outline),
          const SizedBox(width: 10),
          SizedBox(
              width: 110,
              child: Text(k,
                  style: Theme.of(c)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: Theme.of(c).colorScheme.outline))),
          Expanded(
              child: Text(v,
                  style: Theme.of(c)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(fontWeight: FontWeight.w600))),
        ]),
      );
}

/// Escudo institucional sobre un disco blanco (para destacar contra el banner).
class _Escudo extends StatelessWidget {
  final String asset;
  const _Escudo({required this.asset});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 72,
      height: 72,
      padding: const EdgeInsets.all(6),
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      child: Image.asset(asset, fit: BoxFit.contain),
    );
  }
}

/// Botón de red social: pastilla con icono + nombre que abre el enlace.
class _Red extends StatelessWidget {
  final IconData icono;
  final Color color;
  final String url;
  final String label;
  const _Red(
      {required this.icono,
      required this.color,
      required this.url,
      required this.label});

  Future<void> _abrir() async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dark = theme.brightness == Brightness.dark;
    final display =
        (dark && color.computeLuminance() < 0.2) ? Colors.white70 : color;
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: _abrir,
      child: Container(
        constraints: const BoxConstraints(minHeight: 48),
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: display.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: display.withValues(alpha: 0.30)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icono, color: display, size: 18),
            const SizedBox(width: 8),
            Text(label,
                style: theme.textTheme.bodyMedium
                    ?.copyWith(color: display, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}

class _Integrante extends StatelessWidget {
  final String nombre;
  final bool principal;
  const _Integrante({required this.nombre, required this.principal});

  String get _iniciales {
    final partes = nombre.trim().split(' ');
    if (partes.length < 2) return partes.first.substring(0, 1);
    return (partes[0][0] + partes[1][0]).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: AppColors.azul.withValues(alpha: 0.15),
            child: Text(_iniciales,
                style: const TextStyle(
                    color: AppColors.azul, fontWeight: FontWeight.w700)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(nombre, style: theme.textTheme.bodyMedium),
                Text(principal ? 'Desarrollador principal' : 'Integrante',
                    style: theme.textTheme.bodySmall
                        ?.copyWith(color: theme.colorScheme.outline)),
              ],
            ),
          ),
          if (principal)
            const Icon(Icons.star, size: 18, color: AppColors.ambar),
        ],
      ),
    );
  }
}
