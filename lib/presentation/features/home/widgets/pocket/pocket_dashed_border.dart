import 'package:flutter/material.dart';

/// Paints a dashed rounded-rectangle border around [child].
///
/// Used to visually distinguish the Open add-slot pocket from real pockets
/// in the home grid. The dashes are drawn as straight segments along the
/// four sides plus quarter-circle arcs at each rounded corner.
class PocketDashedBorder extends StatelessWidget {
  const PocketDashedBorder({
    super.key,
    required this.child,
    required this.color,
    this.radius = 14,
    this.dashLength = 6,
    this.dashGap = 4,
    this.strokeWidth = 1,
  });

  final Widget child;
  final Color color;
  final double radius;
  final double dashLength;
  final double dashGap;
  final double strokeWidth;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _DashedBorderPainter(
        color: color,
        radius: radius,
        dashLength: dashLength,
        dashGap: dashGap,
        strokeWidth: strokeWidth,
      ),
      child: child,
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  _DashedBorderPainter({
    required this.color,
    required this.radius,
    required this.dashLength,
    required this.dashGap,
    required this.strokeWidth,
  });

  final Color color;
  final double radius;
  final double dashLength;
  final double dashGap;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final rect = Offset.zero & size;
    final rrect = RRect.fromRectAndRadius(rect, Radius.circular(radius));
    final path = Path()..addRRect(rrect);

    final dashed = Path();
    final step = dashLength + dashGap;
    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        final next = (distance + dashLength).clamp(0.0, metric.length);
        dashed.addPath(metric.extractPath(distance, next), Offset.zero);
        distance += step;
      }
    }
    canvas.drawPath(dashed, paint);
  }

  @override
  bool shouldRepaint(_DashedBorderPainter old) =>
      old.color != color ||
      old.radius != radius ||
      old.dashLength != dashLength ||
      old.dashGap != dashGap ||
      old.strokeWidth != strokeWidth;
}
