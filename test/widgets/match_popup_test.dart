
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flat_match/widgets/match_popup.dart';

class _TestTickerProvider extends TickerProvider {
  @override
  Ticker createTicker(TickerCallback onTick) => Ticker(onTick);
}

void main() {
  testWidgets('MatchPopup appears and animates correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: MatchPopup(),
        ),
      ),
    );

    expect(find.text("It's a match!"), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 500));
    expect(find.byType(ScaleTransition), findsAny);
  });

  testWidgets('MatchPopup disappears on tap', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => const MatchPopup(),
                );
              },
              child: const Text('Show MatchPopup'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Show MatchPopup'));
    await tester.pumpAndSettle();

    expect(find.text("It's a match!"), findsOneWidget);

    await tester.tap(find.text("It's a match!"));
    await tester.pumpAndSettle();

    expect(find.text("It's a match!"), findsNothing);
  });

  test('Animation controller initializes correctly', () {
    final tickerProvider = _TestTickerProvider();
    final controller = AnimationController(
      vsync: tickerProvider,
      duration: const Duration(milliseconds: 1500),
    );

    expect(controller.duration, const Duration(milliseconds: 1500));
    controller.dispose();
  });
}