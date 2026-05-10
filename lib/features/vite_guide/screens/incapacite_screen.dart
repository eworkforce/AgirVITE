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
            // The Custom Painter Canvas with Alarm Background
            Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: dropOpacity > 0.2 
                    ? AppColors.emergency.withValues(alpha: 0.15 * dropOpacity)
                    : Colors.transparent,
                boxShadow: dropOpacity > 0.5 
                    ? [
                        BoxShadow(
                          color: AppColors.emergency.withValues(alpha: 0.2 * dropOpacity),
                          blurRadius: 20 * dropOpacity,
                          spreadRadius: 10 * dropOpacity,
                        )
                      ]
                    : [],
              ),
              child: Center(
                child: SizedBox(
                  width: 160,
                  height: 160,
                  child: CustomPaint(
                    painter: _BodyPainter(dropFactor: dropOpacity),
                  ),
                ),
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
    final paint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final headRadius = size.height * 0.15;
    final headCenter = Offset(center.dx, center.dy - size.height * 0.25);
    
    // Draw Head
    canvas.drawCircle(headCenter, headRadius, paint);

    // Draw Torso
    final neckY = headCenter.dy + headRadius;
    final waistY = center.dy + size.height * 0.25;
    canvas.drawLine(Offset(center.dx, neckY), Offset(center.dx, waistY), paint);

    // Draw Right Arm (User's left, viewer's right - stays up)
    final shouldersY = neckY + 10;
    final armLength = size.width * 0.35;
    
    // Right arm raised
    final rightElbow = Offset(center.dx + armLength * 0.6, shouldersY - armLength * 0.2);
    final rightHand = Offset(rightElbow.dx + armLength * 0.4, rightElbow.dy - armLength * 0.4);
    
    Path rightArmPath = Path();
    rightArmPath.moveTo(center.dx, shouldersY);
    rightArmPath.lineTo(rightElbow.dx, rightElbow.dy);
    rightArmPath.lineTo(rightHand.dx, rightHand.dy);
    canvas.drawPath(rightArmPath, paint);

    // Draw Left Arm (User's right, viewer's left - drops down)
    // Calculate angle based on dropFactor. 
    // Raised angle approx -30 degrees from horizontal (-pi/6). Dropped angle approx 70 degrees from horizontal (pi/3).
    // Using simple rotation around the shoulder point.
    
    // Starting raised position (mirrored from right arm)
    final startLeftElbow = Offset(center.dx - armLength * 0.6, shouldersY - armLength * 0.2);
    final startLeftHand = Offset(startLeftElbow.dx - armLength * 0.4, startLeftElbow.dy - armLength * 0.4);
    
    // Target dropped position
    final endLeftElbow = Offset(center.dx - armLength * 0.3, shouldersY + armLength * 0.5);
    final endLeftHand = Offset(endLeftElbow.dx - armLength * 0.1, endLeftElbow.dy + armLength * 0.5);

    // Interpolate positions based on dropFactor
    final currentLeftElbow = Offset(
      startLeftElbow.dx + (endLeftElbow.dx - startLeftElbow.dx) * dropFactor,
      startLeftElbow.dy + (endLeftElbow.dy - startLeftElbow.dy) * dropFactor,
    );
    final currentLeftHand = Offset(
      startLeftHand.dx + (endLeftHand.dx - startLeftHand.dx) * dropFactor,
      startLeftHand.dy + (endLeftHand.dy - startLeftHand.dy) * dropFactor,
    );

    Path leftArmPath = Path();
    leftArmPath.moveTo(center.dx, shouldersY);
    leftArmPath.lineTo(currentLeftElbow.dx, currentLeftElbow.dy);
    leftArmPath.lineTo(currentLeftHand.dx, currentLeftHand.dy);
    
    // Draw the dropping arm with potentially changing color to highlight the issue
    final armPaint = Paint()
      ..color = Color.lerp(AppColors.primary, AppColors.emergency, dropFactor)!
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    canvas.drawPath(leftArmPath, armPaint);
  }

  @override
  bool shouldRepaint(covariant _BodyPainter oldDelegate) {
    return oldDelegate.dropFactor != dropFactor;
  }
}
