import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flat_match/widgets/update_user_filters_form.dart';

void main() {
  setUpAll(() {
    HttpOverrides.global = null;
  });
  testWidgets('UpdateUserFilterForm submits correct data', (WidgetTester tester) async {
    final initialData = {
      'searchLocation': const GeoPoint(45.468, 9.182),
      'searchRange': 100.0,
      'petPreference': '',
      'rentPriceLimit': double.infinity,
    };

    Map<String, dynamic> submittedData = {};

    await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(
          child: UpdateUserFilterForm(
            currentData: initialData,
            onSubmit: (data) => submittedData = data,
          ),
        ),
      ),
    ),
  );

    await tester.tap(find.byType(SwitchListTile));
    await tester.pumpAndSettle();

    final rentFieldFinder = find.byType(TextFormField);
    expect(rentFieldFinder, findsOneWidget);

    await tester.enterText(rentFieldFinder, '650');
    await tester.pumpAndSettle();

    final dropdownFinder = find.byType(DropdownButtonFormField<String>);
    expect(dropdownFinder, findsOneWidget);

    await tester.tap(dropdownFinder);
    await tester.pumpAndSettle();

    await tester.tap(find.text('Yes').last);
    await tester.pumpAndSettle();

    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(submittedData['rentPriceLimit'], 650.0);
    expect(submittedData['petPreference'], 'Yes');
    expect(submittedData['searchLocation'], isA<GeoPoint>()); 
    expect(submittedData['searchRange'], 100.0);
  });
}
