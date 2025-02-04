import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
// Adjust the import path according to your project structure.
import 'package:flat_match/widgets/person_info.dart';

void main() {
  setUpAll(() {
    HttpOverrides.global = null;
  });
  testWidgets('PersonInfo displays user information correctly',
      (WidgetTester tester) async {
    // Create a test user data map.
    final Map<String, dynamic> testUserData = {
      'name': 'Alice',
      'surname': 'Smith',
      'age': 28,
      'gender': 'Female',
      'petPreference': 'Yes',
      'description': 'A passionate traveler and foodie.',
    };

    // Build the PersonInfo widget inside a MaterialApp.
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PersonInfo(userData: testUserData),
        ),
      ),
    );

    // Allow any animations to complete.
    await tester.pumpAndSettle();

    // Verify that the full name is displayed.
    expect(find.text('Alice Smith'), findsOneWidget);

    // Verify that the age is displayed.
    expect(find.text('28'), findsOneWidget);

    // Verify that the gender is displayed.
    expect(find.text('Female'), findsOneWidget);

    // Verify that the pet preference is displayed.
    expect(find.text('Yes'), findsOneWidget);

    // Verify that the description is displayed.
    expect(find.text('A passionate traveler and foodie.'), findsOneWidget);

    // Verify that the CircleAvatar widget is present.
    expect(find.byType(CircleAvatar), findsOneWidget);

    // Optionally, check that the CircleAvatar uses the correct image URL.
    final circleAvatarFinder = find.byType(CircleAvatar);
    final CircleAvatar circleAvatar =
        tester.widget<CircleAvatar>(circleAvatarFinder);
    final backgroundImage = circleAvatar.backgroundImage as NetworkImage;
    expect(backgroundImage.url,
        equals("https://magonsky.scay.net/img/room1.jpg"));
  });
}
