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
    // 1. A sample currentData map for the widget to use:
    final initialData = {
      'searchLocation': const GeoPoint(45.468, 9.182),
      'searchRange': 100.0,
      'petPreference': '',
      'rentPriceLimit': double.infinity,
    };

    // 2. A variable to capture the submitted data from the form:
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

    // At this point, rentPriceLimit is double.infinity, so the switch is OFF.
    // 3. Toggle the switch on to enable the rent price field.
    await tester.tap(find.byType(SwitchListTile));
    await tester.pumpAndSettle();

    // 4. Enter a new value in the rent price text field.
    final rentFieldFinder = find.byType(TextFormField);
    expect(rentFieldFinder, findsOneWidget);

    await tester.enterText(rentFieldFinder, '650');
    await tester.pumpAndSettle();

    // 5. Select the dropdown (petPreference) and choose 'Yes'
    final dropdownFinder = find.byType(DropdownButtonFormField<String>);
    expect(dropdownFinder, findsOneWidget);

    // Tap to open the dropdown
    await tester.tap(dropdownFinder);
    await tester.pumpAndSettle();

    // Tap the 'Yes' menu item
    await tester.tap(find.text('Yes').last);
    await tester.pumpAndSettle();

    // 6. Tap the 'Save' button to submit the form
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    // 7. Validate that the submittedData now reflects the user inputs
    expect(submittedData['rentPriceLimit'], 650.0);
    expect(submittedData['petPreference'], 'Yes');
    expect(submittedData['searchLocation'], isA<GeoPoint>());  // or more specific check
    expect(submittedData['searchRange'], 100.0);
  });
}
