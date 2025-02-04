import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flat_match/widgets/chat.dart';

void main() {
  const dummyChatterData = {'name': 'Test Chatter'};

  testWidgets('sends a message when the send button is pressed',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Chat(chatterData: dummyChatterData),
      ),
    );

    final textFieldFinder = find.byType(TextField);
    expect(textFieldFinder, findsOneWidget);
    await tester.enterText(textFieldFinder, 'Hello, Flutter!');

    final sendButtonFinder = find.byIcon(Icons.send);
    expect(sendButtonFinder, findsOneWidget);
    await tester.tap(sendButtonFinder);

    await tester.pump();

    expect(find.text('Hello, Flutter!'), findsOneWidget);
  });

  testWidgets('clears the text field after sending a message',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Chat(chatterData: dummyChatterData),
      ),
    );

    final textFieldFinder = find.byType(TextField);
    await tester.enterText(textFieldFinder, 'Clearing test');

    // Tap the send button.
    final sendButtonFinder = find.byIcon(Icons.send);
    await tester.tap(sendButtonFinder);
    await tester.pump();

    final TextField textFieldWidget =
        tester.widget<TextField>(textFieldFinder);
    expect(textFieldWidget.controller?.text, equals(''));
  });
}
