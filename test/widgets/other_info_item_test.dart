import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flat_match/widgets/other_info_item.dart';

void main() {
  testWidgets('OtherInfoItem displays icon and text correctly', (WidgetTester tester) async {
    const testIcon = Icons.info;
    const testValue = 'Test Value';

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: OtherInfoItem(icon: testIcon, value: testValue),
        ),
      ),
    );

    expect(find.byIcon(testIcon), findsOneWidget);

    expect(find.text(testValue), findsOneWidget);
  });
}
