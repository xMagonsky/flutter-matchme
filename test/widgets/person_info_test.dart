import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flat_match/widgets/person_info.dart';

void main() {
  setUpAll(() {
    HttpOverrides.global = null;
  });
  testWidgets('PersonInfo displays user information correctly',
      (WidgetTester tester) async {
    final Map<String, dynamic> testUserData = {
      'name': 'Alice',
      'surname': 'Smith',
      'age': 28,
      'gender': 'Female',
      'petPreference': 'Yes',
      'description': 'A passionate traveler and foodie.',
      'image': 'https://magonsky.scay.net/img/room1.jpg',
    };

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PersonInfo(userData: testUserData),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Alice Smith'), findsOneWidget);

    expect(find.text('28'), findsOneWidget);

    expect(find.text('Female'), findsOneWidget);

    expect(find.text('Yes'), findsOneWidget);

    expect(find.text('A passionate traveler and foodie.'), findsOneWidget);

    expect(find.byType(CircleAvatar), findsOneWidget);

    final circleAvatarFinder = find.byType(CircleAvatar);
    final CircleAvatar circleAvatar =
        tester.widget<CircleAvatar>(circleAvatarFinder);
    final backgroundImage = circleAvatar.backgroundImage as NetworkImage;
    expect(backgroundImage.url,
        equals("https://magonsky.scay.net/img/room1.jpg"));
  });
}
