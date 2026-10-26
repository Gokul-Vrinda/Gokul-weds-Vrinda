import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class FallingHearts extends StatefulWidget {
  final int count;
  const FallingHearts({super.key, this.count = 16});

  @override
  State<FallingHearts> createState() => _FallingHeartsState();
}

class _FallingHeartsState extends State<FallingHearts>
    with SingleTickerProviderStateMixin {
  late final Ticker _ticker;
  final _seconds = ValueNotifier<double>(0);
  final _rnd = Random();
  late final List<_Heart> _hearts;

  @override
  void initState() {
    super.initState();
    _hearts = List.generate(widget.count, (i) {
      final h = _Heart(lane: i, lanes: widget.count);
      h.reset(_rnd, 0, initial: true);
      return h;
    });
    _ticker = createTicker((e) => _seconds.value = e.inMicroseconds / 1e6)
      ..start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    _seconds.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => IgnorePointer(
    child: CustomPaint(
      size: Size.infinite,
      painter: _HeartsPainter(_hearts, _seconds, _rnd),
    ),
  );
}

// 3-4 colors only (replace with your exact ones)
const _palette = [
  Color(0xFF8B1E2D), // dark red
  Color(0xFFB3263A), // red
  Color(0xFF6B1520), // maroon
  Color(0xFFD4A24C), // gold
];

class _Heart {
  final int lane, lanes;
  _Heart({required this.lane, required this.lanes});

  late double x,
      size,
      speed,
      rotation,
      rotSpeed,
      sway,
      swaySpeed,
      phase,
      opacity,
      startTime;
  late Color color;

  void reset(Random r, double now, {bool initial = false}) {
    x = (lane + r.nextDouble()) / lanes;

    // random size: mostly small, a few big
    final k = pow(r.nextDouble(), 2).toDouble(); // 0..1, skewed toward 0
    size = 6 + k * 16; // 6 px (tiny) to 30 px (big)

    // bigger hearts fall a bit faster and look a bit stronger (gives depth)
    speed = 25 + r.nextDouble() * 30 + k * 30;
    opacity = 0.4 + r.nextDouble() * 0.3 + k * 0.2;

    rotation = r.nextDouble() * pi * 2;
    rotSpeed = (r.nextBool() ? 1 : -1) * (0.2 + r.nextDouble() * 0.5);
    sway = 3 + r.nextDouble() * 8;
    swaySpeed = 0.5 + r.nextDouble();
    phase = r.nextDouble() * pi * 2;
    color = _palette[r.nextInt(_palette.length)];
    startTime = initial
        ? now + r.nextDouble() * 10 - 5
        : now + r.nextDouble() * 6;
  }
}

class _HeartsPainter extends CustomPainter {
  final List<_Heart> hearts;
  final ValueNotifier<double> seconds;
  final Random rnd;
  _HeartsPainter(this.hearts, this.seconds, this.rnd) : super(repaint: seconds);

  @override
  void paint(Canvas canvas, Size size) {
    final t = seconds.value;
    final paint = Paint()..isAntiAlias = true;

    for (final h in hearts) {
      final elapsed = t - h.startTime;
      if (elapsed < 0) continue;

      final y = -h.size + elapsed * h.speed;
      if (y > size.height + h.size) {
        h.reset(rnd, t);
        continue;
      }
      final x =
          h.x * size.width + sin(elapsed * h.swaySpeed + h.phase) * h.sway;

      paint.color = h.color.withValues(alpha: h.opacity);
      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(h.rotation + elapsed * h.rotSpeed);
      canvas.drawPath(_heart(h.size), paint);
      canvas.restore();
    }
  }

  // Symmetric heart centered on (0,0)
  Path _heart(double s) => Path()
    ..moveTo(0, s * 0.5)
    ..cubicTo(-s * 0.65, s * 0.05, -s * 0.55, -s * 0.5, -s * 0.25, -s * 0.5)
    ..cubicTo(-s * 0.1, -s * 0.5, 0, -s * 0.4, 0, -s * 0.25)
    ..cubicTo(0, -s * 0.4, s * 0.1, -s * 0.5, s * 0.25, -s * 0.5)
    ..cubicTo(s * 0.55, -s * 0.5, s * 0.65, s * 0.05, 0, s * 0.5)
    ..close();

  @override
  bool shouldRepaint(covariant _HeartsPainter old) => false;
}
