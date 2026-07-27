import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tremorly/screens/home_screen.dart';

void main() {
  group('HomeScreen', () {
    testWidgets('displays postcode search widget', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: HomeScreen()));

      expect(find.byType(HomeScreen), findsOneWidget);
      // TODO: Add more assertions
    });
  });
}
