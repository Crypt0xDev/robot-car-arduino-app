/// Datos de un dispositivo Bluetooth mostrado en la app.
class BluetoothDeviceInfo {
  final String name;
  final String address; // MAC
  final int? rssi;      // intensidad de señal (si está disponible)

  const BluetoothDeviceInfo({
    required this.name,
    required this.address,
    this.rssi,
  });
}
