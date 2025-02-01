import 'package:flutter/material.dart';
import 'dart:math';

class MatchPopup extends StatefulWidget {
  const MatchPopup({super.key});

  @override
  State<MatchPopup> createState() => _MatchPopupState();
}

class _Sparkle {
  final double angle;
  final double distance;
  final double radius;
  final Color color;

  _Sparkle(this.angle, this.distance, this.radius, this.color);
}

class _MatchPopupState extends State<MatchPopup> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  late Animation<double> _scaleAnimation;

  late Animation<double> _sparkleExpansion;
  late Animation<double> _sparkleFade;

  late List<_Sparkle> _sparkles;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.7, curve: Curves.elasticOut),
      ),
    );

    _sparkleExpansion = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 1.0, curve: Curves.easeOut),
      ),
    );

    _sparkleFade = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.7, 1.0, curve: Curves.easeOut),
      ),
    );

    final rand = Random();
    _sparkles = List.generate(15, (index) {
      final angle = rand.nextDouble() * 2 * pi;
      final distance = 70 + rand.nextDouble() * 150;
      final radius = 3 + rand.nextDouble() * 7;
      final color = HSVColor.fromAHSV(
        1.0,
        280 + (rand.nextDouble() * 20),
        0.5 + (rand.nextDouble() * 0.5),
        0.5 + (rand.nextDouble() * 0.5),
      ).toColor();
      return _Sparkle(angle, distance, radius, color);
    });

    _controller.addListener(() => setState(() {}));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Sparkles behind the container
            CustomPaint(
              size: const Size(400, 400),
              painter: _SparklesPainter(
                sparkles: _sparkles,
                expansion: _sparkleExpansion.value,
                fade: _sparkleFade.value,
              ),
            ),
            Container(
              padding: const EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                color: Colors.purple,
                borderRadius: BorderRadius.circular(16.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    offset: Offset(0, 4),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: const Text(
                "It's a match!",
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      offset: Offset(2, 2),
                      blurRadius: 3,
                      color: Colors.black38,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SparklesPainter extends CustomPainter {
  final List<_Sparkle> sparkles;
  final double expansion;
  final double fade;

  _SparklesPainter({
    required this.sparkles,
    required this.expansion,
    required this.fade,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    for (final sparkle in sparkles) {
      final dx = center.dx + sparkle.distance * expansion * cos(sparkle.angle);
      final dy = center.dy + sparkle.distance * expansion * sin(sparkle.angle);

      final paint = Paint()..color = sparkle.color.withOpacity(fade);
      canvas.drawCircle(Offset(dx, dy), sparkle.radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _SparklesPainter oldDelegate) {
    return oldDelegate.expansion != expansion ||
        oldDelegate.fade != fade ||
        oldDelegate.sparkles != sparkles;
  }
}
