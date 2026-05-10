import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../app/theme/colors.dart';

class VisageScreen extends StatelessWidget {
  final VoidCallback onNext;

  const VisageScreen({super.key, required this.onNext});

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
              'V - Visage',
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
            ).animate().fadeIn(duration: 500.ms).slideY(begin: -0.2),
            const SizedBox(height: 8),
            Text(
              'Paralysie faciale',
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
              child: const _CodeAnimatedFace(),
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
                    'Demandez à la personne de sourire ou de montrer les dents. Est-ce que le sourire est asymétrique ? Un côté du visage tombe-t-il ?',
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
                  'Suivant : I comme Incapacité',
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

class _CodeAnimatedFace extends StatefulWidget {
  const _CodeAnimatedFace();

  @override
  State<_CodeAnimatedFace> createState() => _CodeAnimatedFaceState();
}

class _CodeAnimatedFaceState extends State<_CodeAnimatedFace> with SingleTickerProviderStateMixin {
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
        double droopOpacity = 0.0;
        final value = _controller.value;
        if (value > 0.4 && value <= 0.5) {
          droopOpacity = (value - 0.4) * 10;
        } else if (value > 0.5 && value <= 0.9) {
          droopOpacity = 1.0;
        } else if (value > 0.9 && value <= 1.0) {
          droopOpacity = 1.0 - ((value - 0.9) * 10);
        }
        
        droopOpacity = droopOpacity.clamp(0.0, 1.0);
        final statusColor = Color.lerp(AppColors.primary, AppColors.emergency, droopOpacity)!;

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
                color: droopOpacity > 0.2 
                    ? AppColors.emergency.withValues(alpha: 0.15 * droopOpacity)
                    : Colors.transparent,
                boxShadow: droopOpacity > 0.5 
                    ? [
                        BoxShadow(
                          color: AppColors.emergency.withValues(alpha: 0.2 * droopOpacity),
                          blurRadius: 20 * droopOpacity,
                          spreadRadius: 10 * droopOpacity,
                        )
                      ]
                    : [],
              ),
              child: Center(
                child: SizedBox(
                  width: 160,
                  height: 160,
                  child: CustomPaint(
                    painter: _FacePainter(droopFactor: droopOpacity),
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
                droopOpacity < 0.5 ? 'Sourire symétrique' : 'Affaissement facial !',
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

class _FacePainter extends CustomPainter {
  final double droopFactor; // 0.0 = normal, 1.0 = fully drooped

  _FacePainter({required this.droopFactor});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Head Background
    final paintHead = Paint()
      ..color = AppColors.background
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius, paintHead);

    // Head Outline
    final paintOutline = Paint()
      ..color = AppColors.primary.withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6;
    canvas.drawCircle(center, radius, paintOutline);

    // Eyes
    final eyePaint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;

    final eyeY = center.dy - radius * 0.15;
    final leftEyeX = center.dx - radius * 0.4;
    final rightEyeX = center.dx + radius * 0.4;
    final eyeWidth = radius * 0.3;

    // Left eye (Always serene closed arc)
    Path leftEyePath = Path();
    leftEyePath.moveTo(leftEyeX - eyeWidth / 2, eyeY);
    leftEyePath.quadraticBezierTo(leftEyeX, eyeY - 15, leftEyeX + eyeWidth / 2, eyeY);
    canvas.drawPath(leftEyePath, eyePaint);

    // Right eye (Droops and flattens out)
    final rightEyeDroopY = eyeY + (20 * droopFactor);
    Path rightEyePath = Path();
    rightEyePath.moveTo(rightEyeX - eyeWidth / 2, eyeY);
    rightEyePath.quadraticBezierTo(
      rightEyeX, 
      eyeY - 15 * (1 - droopFactor) + 5 * droopFactor, // Arc flattens and drops
      rightEyeX + eyeWidth / 2, 
      rightEyeDroopY
    );
    canvas.drawPath(rightEyePath, eyePaint);

    // Mouth
    final mouthPaint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;

    final mouthY = center.dy + radius * 0.3;
    final mouthWidth = radius * 0.6;
    final leftMouthX = center.dx - mouthWidth / 2;
    final rightMouthX = center.dx + mouthWidth / 2;

    Path mouthPath = Path();
    mouthPath.moveTo(leftMouthX, mouthY - 10); // Left corner (stable)
    
    // Control point for the smile curve
    final smileControlY = mouthY + 30;
    
    // As droopFactor increases, the right corner and the control point fall
    final rightMouthDroopY = (mouthY - 10) + (50 * droopFactor);
    final droopedControlY = smileControlY + (10 * droopFactor);

    mouthPath.quadraticBezierTo(
      center.dx, 
      droopedControlY, 
      rightMouthX, 
      rightMouthDroopY
    );
    
    canvas.drawPath(mouthPath, mouthPaint);
  }

  @override
  bool shouldRepaint(covariant _FacePainter oldDelegate) {
    return oldDelegate.droopFactor != droopFactor;
  }
}
