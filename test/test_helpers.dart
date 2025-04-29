import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:tasklist/main.dart';

extension PumpApp on WidgetTester {
  Future<void> pumpMyApp({bool useController = false}) async {
    await pumpWidget(MaterialApp(
      home: MyApp(useController: useController),
    ));
    await pumpAndSettle();
  }
}