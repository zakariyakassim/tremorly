import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forui/forui.dart';
import 'package:tremorly/models/crime.dart';
import 'package:tremorly/models/postcode.dart';
import 'package:tremorly/screens/home_screen.dart';
import 'package:tremorly/services/crime_service.dart';
import 'package:tremorly/services/postcode_service.dart';
import 'package:tremorly/theme/theme.dart';

void main() {
  testWidgets('searches a postcode and filters loaded incidents', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(1280, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final postcodeService = _FakePostcodeService();
    final themeChanges = <bool>[];
    await tester.pumpWidget(
      MaterialApp(
        theme: neutralLight.toApproximateMaterialTheme(),
        builder: (context, child) => FTheme(
          data: neutralLight,
          child: FToaster(
            child: FTooltipGroup(child: child ?? const SizedBox.shrink()),
          ),
        ),
        home: HomeScreen(
          postcodeService: postcodeService,
          crimeService: _FakeCrimeService(),
          onThemeChanged: themeChanges.add,
        ),
      ),
    );

    expect(find.text('Neighbourhood Crime Explorer'), findsNothing);
    await tester.tap(find.byKey(const Key('theme-mode-switch')));
    await tester.pump();
    expect(themeChanges, [true]);

    final postcodeInput = find.descendant(
      of: find.byKey(const Key('postcode-field')),
      matching: find.byType(EditableText),
    );
    await tester.enterText(postcodeInput, 'sw1a');
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pumpAndSettle();

    expect(
      find.byKey(const Key('postcode-suggestion-SW1A 1AA')),
      findsOneWidget,
    );
    await tester.tap(find.byKey(const Key('postcode-suggestion-SW1A 1AA')));
    await tester.pumpAndSettle();

    expect(postcodeService.queries, ['SW1A']);
    expect(postcodeService.validationCalls, 0);
    expect(find.text('Explore area'), findsNothing);
    expect(find.text('SW1A 1AA'), findsWidgets);
    expect(find.text('February 2026'), findsWidgets);
    expect(find.text('2'), findsNWidgets(2));
    expect(find.text('Anti social behaviour'), findsWidgets);
    expect(find.text('Burglary'), findsWidgets);

    final filterInput = find.descendant(
      of: find.byKey(const Key('incident-filter')),
      matching: find.byType(EditableText),
    );
    await tester.enterText(filterInput, 'burglary');
    await tester.pump();

    expect(find.text('Showing 1 of 1 matching incidents'), findsOneWidget);
    expect(find.text('Burglary'), findsWidgets);
    expect(find.text('Anti social behaviour'), findsOneWidget);
  });
}

class _FakePostcodeService extends PostcodeService {
  final queries = <String>[];
  int validationCalls = 0;

  @override
  Future<List<Postcode>> searchPostcodes(String query, {int limit = 8}) async {
    queries.add(query);
    return const [
      Postcode(
        postcode: 'SW1A 1AA',
        outcode: 'SW1A',
        incode: '1AA',
        region: 'London',
        adminDistrict: 'Westminster',
        latitude: 51.501009,
        longitude: -0.141588,
      ),
    ];
  }

  @override
  Future<Postcode> validatePostcode(String postcode) async {
    validationCalls++;
    return const Postcode(
      postcode: 'SW1A 1AA',
      outcode: 'SW1A',
      incode: '1AA',
      region: 'London',
      adminDistrict: 'Westminster',
      latitude: 51.501009,
      longitude: -0.141588,
    );
  }
}

class _FakeCrimeService extends CrimeService {
  @override
  Future<List<Crime>> getCrimesByCoordinates(
    double latitude,
    double longitude,
  ) async {
    return const [
      Crime(
        id: 1,
        category: 'anti-social-behaviour',
        streetName: 'On or near Parliament Street',
        latitude: '51.50',
        longitude: '-0.14',
        month: '2026-02',
      ),
      Crime(
        id: 2,
        category: 'burglary',
        streetName: 'On or near Whitehall',
        latitude: '51.50',
        longitude: '-0.13',
        month: '2026-02',
        outcomeStatus: 'Under investigation',
      ),
    ];
  }
}
