import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:flat_match/widgets/update_user_data_form.dart';

class MockFunction extends Mock {
  void call(Map<String, dynamic> data);
}

void main() {
  setUpAll(() {
    HttpOverrides.global = null;
  });
  testWidgets('Form validation: Ensures required fields are filled', (WidgetTester tester) async {
    final mockOnSubmit = MockFunction();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: UpdateUserDataForm(onSubmit: mockOnSubmit),
          )
        ),
      ),
    );

    await tester.tap(find.text('Save'));
    await tester.pump();

    expect(find.text('Please enter your name'), findsOneWidget);
    expect(find.text('Please enter your surname'), findsOneWidget);
    expect(find.text('Please enter your age'), findsOneWidget);
    expect(find.text('Please select your gender'), findsOneWidget);
  });

}
