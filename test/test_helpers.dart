import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:tasklist/main.dart';

extension PumpApp on WidgetTester {
  Future<void> pumpMyApp() async {
    await pumpWidget(MaterialApp(
      home: MyApp(),
    ));
    await pumpAndSettle();
  }
}