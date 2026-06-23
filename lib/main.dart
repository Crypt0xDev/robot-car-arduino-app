///
import 'package:flutter/material.dart';
import 'screens/home_shell.dart';
import 'services/bluetooth_service.dart';
import 'services/event_logger.dart';
import 'services/robot_controller.dart';
import 'theme/app_theme.dart';

void main() => runApp(const RoboCarApp());

class RoboCarApp extends StatefulWidget {
  const RoboCarApp({super.key});
  @override
  State<RoboCarApp> createState() => _RoboCarAppState();
}

class _RoboCarAppState extends State<RoboCarApp> {
  late final EventLogger _logger = EventLogger();
  late final BluetoothService _bt = BluetoothService(_logger);
  late final RobotController _ctrl = RobotController(_bt, _logger);

  @override
  void dispose() {
    _ctrl.dispose();
    _bt.dispose();
    _logger.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RoboCar UNSM',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      home: HomeShell(bt: _bt, ctrl: _ctrl, logger: _logger),
    );
  }
}
