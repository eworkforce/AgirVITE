import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../app/theme/colors.dart';

class IncapaciteScreen extends StatelessWidget {
  final VoidCallback onNext;

  const IncapaciteScreen({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Title Section
            Text(
              'I - Incapacité',
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
            ).animate().fadeIn(duration: 500.ms).slideY(begin: -0.2),
            const SizedBox(height: 8),
            Text(
              'Faiblesse d\'un membre',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ).animate().fadeIn(delay: 200.ms),
            
            const SizedBox(height: 24),
            
            // Code-Generated Animation Visual
            Container(
              height: 280,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.05),
                    blurRadius: 20,
                    spreadRadius: 5,
                    offset: const Offset(0, 10),
                  )
                ],
              ),
              child: const _CodeAnimatedArm(),
            ).animate().fadeIn(delay: 400.ms).scale(begin: const Offset(0.9, 0.9)),

            const SizedBox(height: 24),

            // Explanation Text
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.secondary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.secondary.withValues(alpha: 0.3)),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(Icons.info_outline, color: AppColors.primary),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Comment tester ?',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Demandez à la personne de lever les deux bras à l\'horizontale. Un des bras retombe-t-il ou est-il impossible à lever ?',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.textPrimary,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.2),
            
            const SizedBox(height: 32),
            
            // Action Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: onNext,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Suivant : T comme Trouble',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ).animate().fadeIn(delay: 800.ms),
          ],
        ),
      ),
    );
  }
}

class _CodeAnimatedArm extends StatefulWidget {
  const _CodeAnimatedArm();

  @override
  State<_CodeAnimatedArm> createState() => _CodeAnimatedArmState();
}

class _CodeAnimatedArmState extends State<_CodeAnimatedArm> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    // 4 second loop
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 4));
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        double dropOpacity = 0.0;
        final value = _controller.value;
        if (value > 0.4 && value <= 0.6) {
          dropOpacity = (value - 0.4) * 5;
        } else if (value > 0.6 && value <= 0.9) {
          dropOpacity = 1.0;
        } else if (value > 0.9 && value <= 1.0) {
          dropOpacity = 1.0 - ((value - 0.9) * 10);
        }
        
        dropOpacity = dropOpacity.clamp(0.0, 1.0);
        final statusColor = Color.lerp(AppColors.primary, AppColors.emergency, dropOpacity)!;

        return Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // The Custom Painter Canvas with Danger Icon
            SizedBox(
              width: 180,
              height: 180,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 160,
                    height: 160,
                    child: CustomPaint(
                      painter: _BodyPainter(dropFactor: dropOpacity),
                    ),
                  ),
                  if (dropOpacity > 0.5)
                    Positioned(
                      top: 0,
                      right: 0,
                      child: const Icon(
                        Icons.warning_rounded,
                        color: Colors.red,
                        size: 36,
                      ).animate().scale(curve: Curves.elasticOut),
                    ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Status pill
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: statusColor.withValues(alpha: 0.3)),
              ),
              child: Text(
                dropOpacity < 0.5 ? 'Bras maintenus' : 'Faiblesse d\'un bras !',
                style: TextStyle(
                  color: statusColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _BodyPainter extends CustomPainter {
  final double dropFactor; // 0.0 = normal, 1.0 = arm fully dropped

  _BodyPainter({required this.dropFactor});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    
    // Draw Torso (Shirt)
    final torsoPaint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.fill;
    
    final torsoWidth = size.width * 0.45;
    final torsoHeight = size.height * 0.4;
    final torsoTopY = center.dy - size.height * 0.1;
    
    final torsoRect = RRect.fromRectAndCorners(
      Rect.fromCenter(
        center: Offset(center.dx, torsoTopY + torsoHeight / 2),
        width: torsoWidth,
        height: torsoHeight,
      ),
      topLeft: const Radius.circular(16),
      topRight: const Radius.circular(16),
      bottomLeft: const Radius.circular(4),
      bottomRight: const Radius.circular(4),
    );
    canvas.drawRRect(torsoRect, torsoPaint);

    // Draw Head
    final skinPaint = Paint()
      ..color = const Color(0xFFFFD1B3) // Simple skin tone
      ..style = PaintingStyle.fill;
      
    final headRadius = size.width * 0.18;
    final headCenter = Offset(center.dx, torsoTopY - headRadius * 1.1);
    canvas.drawCircle(headCenter, headRadius, skinPaint);
    
    // Draw Hair (Simple shape)
    final hairPaint = Paint()
      ..color = const Color(0xFF3E2723) // Dark brown
      ..style = PaintingStyle.fill;
    
    Path hairPath = Path();
    hairPath.moveTo(headCenter.dx - headRadius, headCenter.dy);
    hairPath.quadraticBezierTo(headCenter.dx - headRadius, headCenter.dy - headRadius * 1.2, headCenter.dx, headCenter.dy - headRadius * 1.2);
    hairPath.quadraticBezierTo(headCenter.dx + headRadius, headCenter.dy - headRadius * 1.2, headCenter.dx + headRadius, headCenter.dy);
    hairPath.quadraticBezierTo(headCenter.dx, headCenter.dy - headRadius * 0.5, headCenter.dx - headRadius, headCenter.dy);
    canvas.drawPath(hairPath, hairPaint);

    // Arms
    final armWidth = size.width * 0.12;
    final armLength = size.height * 0.35;
    final shoulderDrop = torsoHeight * 0.1;
    
    // Right Arm (Viewer's right, stays up)
    final rightShoulderX = center.dx + torsoWidth / 2;
    final rightShoulderY = torsoTopY + shoulderDrop;
    
    final rightArmPaint = Paint()
      ..color = skinPaint.color
      ..style = PaintingStyle.stroke
      ..strokeWidth = armWidth
      ..strokeCap = StrokeCap.round;
      
    // Sleeve
    final sleevePaint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.stroke
      ..strokeWidth = armWidth
      ..strokeCap = StrokeCap.round;

    // Draw right arm raised
    Path rightArmPath = Path();
    rightArmPath.moveTo(rightShoulderX, rightShoulderY);
    rightArmPath.lineTo(rightShoulderX + armLength * 0.5, rightShoulderY - armLength * 0.6);
    rightArmPath.lineTo(rightShoulderX + armLength * 0.2, rightShoulderY - armLength * 1.1);
    
    canvas.drawPath(rightArmPath, rightArmPaint);
    
    // Draw right sleeve
    canvas.drawLine(
      Offset(rightShoulderX, rightShoulderY),
      Offset(rightShoulderX + armLength * 0.25, rightShoulderY - armLength * 0.3),
      sleevePaint
    );

    // Left Arm (Viewer's left, drops down)
    final leftShoulderX = center.dx - torsoWidth / 2;
    final leftShoulderY = torsoTopY + shoulderDrop;
    
    // Start position (raised, mirrored from right)
    final startLeftElbow = Offset(leftShoulderX - armLength * 0.5, leftShoulderY - armLength * 0.6);
    final startLeftHand = Offset(leftShoulderX - armLength * 0.2, leftShoulderY - armLength * 1.1);
    
    // Target position (dropped to the side)
    final endLeftElbow = Offset(leftShoulderX - armLength * 0.2, leftShoulderY + armLength * 0.5);
    final endLeftHand = Offset(leftShoulderX - armLength * 0.1, leftShoulderY + armLength * 0.9);

    // Calculate a shake offset that is active only while the arm is dropping
    double shakeX = 0.0;
    if (dropFactor > 0.0 && dropFactor < 1.0) {
      // sin(dropFactor * pi * N) creates N/2 shakes during the fall.
      shakeX = sin(dropFactor * pi * 8) * 15.0; // 15 pixels max horizontal shake
    }

    // Interpolate positions with shake
    final currentLeftElbow = Offset(
      startLeftElbow.dx + (endLeftElbow.dx - startLeftElbow.dx) * dropFactor + shakeX,
      startLeftElbow.dy + (endLeftElbow.dy - startLeftElbow.dy) * dropFactor,
    );
    final currentLeftHand = Offset(
      startLeftHand.dx + (endLeftHand.dx - startLeftHand.dx) * dropFactor + (shakeX * 1.5), // Hand shakes slightly more
      startLeftHand.dy + (endLeftHand.dy - startLeftHand.dy) * dropFactor,
    );

    Path leftArmPath = Path();
    leftArmPath.moveTo(leftShoulderX, leftShoulderY);
    leftArmPath.lineTo(currentLeftElbow.dx, currentLeftElbow.dy);
    leftArmPath.lineTo(currentLeftHand.dx, currentLeftHand.dy);
    
    // The left arm changes color to indicate the issue as it drops
    final leftArmPaint = Paint()
      ..color = Color.lerp(skinPaint.color, AppColors.emergency.withValues(alpha: 0.5), dropFactor)!
      ..style = PaintingStyle.stroke
      ..strokeWidth = armWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    canvas.drawPath(leftArmPath, leftArmPaint);
    
    // Draw left sleeve (interpolated)
    final currentSleeveEnd = Offset(
      leftShoulderX + (currentLeftElbow.dx - leftShoulderX) * 0.5,
      leftShoulderY + (currentLeftElbow.dy - leftShoulderY) * 0.5,
    );
    canvas.drawLine(
      Offset(leftShoulderX, leftShoulderY),
      currentSleeveEnd,
      sleevePaint
    );
    
    // Add downward motion arrows if dropping
    if (dropFactor > 0.1 && dropFactor < 0.9) {
      final arrowPaint = Paint()
        ..color = AppColors.emergency
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..strokeCap = StrokeCap.round;
        
      final arrowX = leftShoulderX - armLength * 0.8;
      final arrowY = leftShoulderY - armLength * 0.2 + (armLength * dropFactor);
      
      Path arrowPath = Path();
      arrowPath.moveTo(arrowX, arrowY);
      arrowPath.lineTo(arrowX, arrowY + 15);
      arrowPath.moveTo(arrowX - 5, arrowY + 10);
      arrowPath.lineTo(arrowX, arrowY + 15);
      arrowPath.lineTo(arrowX + 5, arrowY + 10);
      
      canvas.drawPath(arrowPath, arrowPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _BodyPainter oldDelegate) {
    return oldDelegate.dropFactor != dropFactor;
  }
}
