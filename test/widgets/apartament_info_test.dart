import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flat_match/widgets/apartament_info.dart';
import 'package:latlong2/latlong.dart';

void main() {
  setUpAll(() {
    HttpOverrides.global = null;
  });
  testWidgets('ApartmentInfo widget displays correct data', (WidgetTester tester) async {
    final testUserData = {
      "apartmentImage": "https://magonsky.scay.net/img/no-img.jpg",
      "apartamentAddress": "123 Main Street, City",
      "petPreference": "Allowed",
      "rentPrice": 1200.00,
      "apartmentDescription": "A beautiful apartment in the city center.",
      "apartamentLocation": LatLng(37.7749, -122.4194),
    };

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ApartmentInfo(userData: testUserData),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text("123 Main Street, City"), findsOneWidget);

    expect(find.text("Allowed"), findsOneWidget);

    expect(find.text("1200.00"), findsOneWidget);

    expect(find.text("A beautiful apartment in the city center."), findsOneWidget);

    expect(find.byType(Container), findsWidgets);
  });
}