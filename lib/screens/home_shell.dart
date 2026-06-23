import 'package:flutter/material.dart';
import '../services/bluetooth_service.dart';
import '../services/event_logger.dart';
import '../services/robot_controller.dart';
import '../theme/app_theme.dart';
import 'about_screen.dart';
import 'control_screen.dart';
import 'devices_screen.dart';
import 'diagnostico_screen.dart';
import 'home_screen.dart';
import 'manual_screen.dart';
import 'project_info_screen.dart';
import 'reports_screen.dart';
import 'status_screen.dart';

/// Contenedor principal con Navigation Drawer. Mantiene el estado
/// compartido (Bluetooth, controlador, eventos) y conmuta entre pantallas.
class HomeShell extends StatefulWidget {
  final BluetoothService bt;
  final RobotController ctrl;
  final EventLogger logger;
  const HomeShell(
      {super.key,
      required this.bt,
      required this.ctrl,
      required this.logger});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _Destino {
  final String titulo;
  final IconData icono;
  const _Destino(this.titulo, this.icono);
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;

  static const _destinos = [
    _Destino('Inicio', Icons.home_outlined),
    _Destino('Control', Icons.gamepad_outlined),
    _Destino('Dispositivos', Icons.bluetooth),
    _Destino('Diagnóstico', Icons.troubleshoot),
    _Destino('Estado', Icons.monitor_heart_outlined),
    _Destino('Reportes', Icons.history),
    _Destino('Manual', Icons.menu_book_outlined),
    _Destino('Información del proyecto', Icons.info_outline),
    _Destino('Acerca de', Icons.school_outlined),
  ];

  LogEvent? _ultimoAviso;

  @override
  void initState() {
    super.initState();
    // Pedir todos los permisos de Bluetooth al abrir la app (primera vez),
    // asi no falta ninguno cuando el usuario quiera conectarse.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.bt.solicitarPermisos();
    });
    // Control de errores: cualquier error/advertencia registrado se muestra
    // como aviso visible al usuario, sin importar en que pantalla este.
    widget.logger.addListener(_mostrarErrores);
  }

  @override
  void dispose() {
    widget.logger.removeListener(_mostrarErrores);
    super.dispose();
  }

  void _mostrarErrores() {
    final eventos = widget.logger.events;
    if (eventos.isEmpty) return;
    final ultimo = eventos.last;
    if (ultimo == _ultimoAviso) return; // no repetir el mismo
    if (ultimo.level != LogLevel.error && ultimo.level != LogLevel.warning) {
      return; // solo errores y advertencias
    }
    _ultimoAviso = ultimo;
    final esError = ultimo.level == LogLevel.error;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: esError ? AppColors.rojo : AppColors.ambar,
          content: Row(
            children: [
              Icon(esError ? Icons.error_outline : Icons.warning_amber,
                  color: Colors.white, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(ultimo.message,
                    style: const TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ));
    });
  }

  void _ir(int i) => setState(() => _index = i);

  Future<void> _desconectar() async {
    await widget.bt.disconnect();
    widget.ctrl.clearMode();
  }

  Widget _pantalla() {
    switch (_index) {
      case 0:
        return HomeScreen(
            bt: widget.bt, ctrl: widget.ctrl, onNavigate: _ir);
      case 1:
        return ControlScreen(bt: widget.bt, ctrl: widget.ctrl);
      case 2:
        return DevicesScreen(bt: widget.bt, onDisconnect: _desconectar);
      case 3:
        return DiagnosticoScreen(bt: widget.bt);
      case 4:
        return StatusScreen(bt: widget.bt, ctrl: widget.ctrl);
      case 5:
        return ReportsScreen(logger: widget.logger);
      case 6:
        return const ManualScreen();
      case 7:
        return const ProjectInfoScreen();
      default:
        return const AboutScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_destinos[_index].titulo),
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      drawer: _Drawer(
        destinos: _destinos,
        index: _index,
        onSelect: (i) {
          Navigator.pop(context);
          _ir(i);
        },
      ),
      body: SafeArea(
        child: ListenableBuilder(
          listenable:
              Listenable.merge([widget.bt, widget.ctrl, widget.logger]),
          builder: (context, _) => _pantalla(),
        ),
      ),
    );
  }
}

class _Drawer extends StatelessWidget {
  final List<_Destino> destinos;
  final int index;
  final ValueChanged<int> onSelect;
  const _Drawer(
      {required this.destinos, required this.index, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(gradient: AppColors.banner),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  width: 56,
                  height: 56,
                  padding: const EdgeInsets.all(5),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Image.asset('assets/images/unsm.png',
                      fit: BoxFit.contain),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Text('RoboCar UNSM',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w700)),
                      Text('Control de robot · UNSM',
                          style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.85),
                              fontSize: 12)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          for (var i = 0; i < destinos.length; i++)
            ListTile(
              leading: Icon(destinos[i].icono,
                  color: i == index ? theme.colorScheme.primary : null),
              title: Text(destinos[i].titulo,
                  style: TextStyle(
                      color: i == index ? theme.colorScheme.primary : null,
                      fontWeight:
                          i == index ? FontWeight.w700 : FontWeight.w400)),
              selected: i == index,
              selectedTileColor:
                  theme.colorScheme.primary.withValues(alpha: 0.08),
              onTap: () => onSelect(i),
            ),
        ],
      ),
    );
  }
}
