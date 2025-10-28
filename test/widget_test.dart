// Basic widget test for Bundok app

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:bundok_final/main.dart';

void main() {
  testWidgets('App loads successfully', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const BundokApp());

    // Verify that the app loads
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
