// Prueba básica: la app arranca y muestra el encabezado del dashboard.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:robot_car_app/main.dart';

void main() {
  testWidgets('La app muestra el encabezado RoboCar UNSM',
      (WidgetTester tester) async {
    await tester.pumpWidget(const RoboCarApp());
    await tester.pump();

    expect(find.text('RoboCar UNSM'), findsOneWidget);
  });
}
