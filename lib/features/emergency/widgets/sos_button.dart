import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/colors.dart';

/// Incremented each time the user completes the 2-second SOS hold gesture,
/// allowing [MapScreen] to react even when already visible.
final emergencyTriggerProvider = StateProvider<int>((ref) => 0);

class SOSButton extends ConsumerStatefulWidget {
  const SOSButton({super.key});

  @override
  ConsumerState<SOSButton> createState() => _SOSButtonState();
}

class _SOSButtonState extends ConsumerState<SOSButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2), // 2 seconds long press
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _triggerEmergency();
      }
    });
  }

  void _triggerEmergency() {
    setState(() => _isPressed = false);
    _controller.reset();
    HapticFeedback.heavyImpact();

    // Increment trigger state and navigate directly to the Map in emergency mode.
    ref.read(emergencyTriggerProvider.notifier).state++;
    context.go('/map?emergency=true');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() => _isPressed = true);
        _controller.forward();
      },
      onTapUp: (_) {
        if (_controller.status != AnimationStatus.completed) {
          setState(() => _isPressed = false);
          _controller.reset();
        }
      },
      onTapCancel: () {
        setState(() => _isPressed = false);
        _controller.reset();
      },
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return SizedBox(
            width: 80,
            height: 80,
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                // Curved reminder text hugging the upper circular perimeter of the SOS button
                Positioned(
                  top: -22,
                  left: -22,
                  right: -22,
                  bottom: -22,
                  child: IgnorePointer(
                    child: CustomPaint(
                      key: const Key('sos_curved_perimeter_text'),
                      painter: _CurvedPerimeterTextPainter(
                        text: "EN CAS D'URGENCE : MAINTENEZ 2S",
                        radius: 49.0,
                        textStyle: TextStyle(
                          color: AppColors.textPrimary.withValues(alpha: 0.72),
                          fontSize: 8.2,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                  ),
                ),
                // Main 80x80 SOS Circle
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.emergency,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.emergency.withValues(alpha: 0.4),
                        blurRadius: 15 + (_controller.value * 15),
                        spreadRadius: 4 + (_controller.value * 6),
                      ),
                      BoxShadow(
                        color: AppColors.emergency.withValues(alpha: 0.2),
                        blurRadius: 25,
                        spreadRadius: 8,
                      )
                    ],
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      if (_isPressed)
                        SizedBox(
                          width: 70,
                          height: 70,
                          child: CircularProgressIndicator(
                            value: _controller.value,
                            color: Colors.white,
                            strokeWidth: 4,
                          ),
                        ),
                      const Center(
                        child: Text(
                          'SOS',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// Renders [text] along the upper circular arc of [radius] centered on the canvas.
class _CurvedPerimeterTextPainter extends CustomPainter {
  final String text;
  final double radius;
  final TextStyle textStyle;

  const _CurvedPerimeterTextPainter({
    required this.text,
    required this.radius,
    required this.textStyle,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (text.isEmpty) return;

    final Offset center = Offset(size.width / 2, size.height / 2);
    final List<TextPainter> charPainters = <TextPainter>[];
    double totalArcLength = 0.0;
    const double extraCharSpacing = 0.8;

    for (int i = 0; i < text.length; i++) {
      final tp = TextPainter(
        text: TextSpan(text: text[i], style: textStyle),
        textDirection: TextDirection.ltr,
      )..layout();
      charPainters.add(tp);
      totalArcLength += tp.width + extraCharSpacing;
    }
    if (charPainters.isNotEmpty) {
      totalArcLength -= extraCharSpacing;
    }

    // Center the arc at the top of the circle (-pi / 2)
    final double totalAngle = totalArcLength / radius;
    double currentAngle = (-math.pi / 2) - (totalAngle / 2);

    for (final tp in charPainters) {
      final double charAngleSpan = tp.width / radius;
      final double charCenterAngle = currentAngle + (charAngleSpan / 2);

      final double dx = center.dx + radius * math.cos(charCenterAngle);
      final double dy = center.dy + radius * math.sin(charCenterAngle);

      canvas.save();
      canvas.translate(dx, dy);
      canvas.rotate(charCenterAngle + (math.pi / 2));
      tp.paint(canvas, Offset(-tp.width / 2, -tp.height / 2));
      canvas.restore();

      currentAngle += (tp.width + extraCharSpacing) / radius;
    }
  }

  @override
  bool shouldRepaint(covariant _CurvedPerimeterTextPainter oldDelegate) {
    return oldDelegate.text != text ||
        oldDelegate.radius != radius ||
        oldDelegate.textStyle != textStyle;
  }
}
