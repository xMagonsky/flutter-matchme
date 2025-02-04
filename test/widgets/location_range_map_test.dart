import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';
import 'package:flat_match/widgets/location_range_map.dart';

void main() {
  setUpAll(() {
    HttpOverrides.global = null;
  });
  testWidgets('calls onChanged with initial values', (WidgetTester tester) async {
    final List<LocationRangeData> callbackCalls = [];

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: LocationRangeMap(
            onChanged: (data) {
              callbackCalls.add(data);
            },
            initialLocation: LatLng(10.0, 20.0),
            initialRange: 1500,
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(callbackCalls, isNotEmpty);
    final initialData = callbackCalls.first;
    expect(initialData.location.latitude, equals(10.0));
    expect(initialData.location.longitude, equals(20.0));
    expect(initialData.range, equals(1500));
  });

  testWidgets('updates range when slider is moved', (WidgetTester tester) async {
    LocationRangeData? lastCallback;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: LocationRangeMap(
            onChanged: (data) {
              lastCallback = data;
            },
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    final sliderFinder = find.byType(Slider);
    expect(sliderFinder, findsOneWidget);

    await tester.tapAt(tester.getCenter(sliderFinder));
    await tester.pumpAndSettle();

    expect(lastCallback, isNotNull);
    expect(lastCallback!.range, isNot(equals(1000)));
  });
}
