import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../app/theme/colors.dart';

class TroubleScreen extends StatelessWidget {
  final VoidCallback onNext;

  const TroubleScreen({super.key, required this.onNext});

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
              'T - Trouble',
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
            ).animate().fadeIn(duration: 500.ms).slideY(begin: -0.2),
            const SizedBox(height: 8),
            Text(
              'Trouble de la parole',
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
              child: const _CodeAnimatedSpeech(),
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
                    'Faites répéter une phrase simple. La personne a-t-elle du mal à parler ? Les mots sont-ils incompréhensibles ?',
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
                  'Suivant : E comme En Urgence',
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

class _CodeAnimatedSpeech extends StatefulWidget {
  const _CodeAnimatedSpeech();

  @override
  State<_CodeAnimatedSpeech> createState() => _CodeAnimatedSpeechState();
}

class _CodeAnimatedSpeechState extends State<_CodeAnimatedSpeech> with SingleTickerProviderStateMixin {
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
        double troubleOpacity = 0.0;
        final value = _controller.value;
        if (value > 0.4 && value <= 0.6) {
          troubleOpacity = (value - 0.4) * 5;
        } else if (value > 0.6 && value <= 0.9) {
          troubleOpacity = 1.0;
        } else if (value > 0.9 && value <= 1.0) {
          troubleOpacity = 1.0 - ((value - 0.9) * 10);
        }
        
        troubleOpacity = troubleOpacity.clamp(0.0, 1.0);
        final statusColor = Color.lerp(AppColors.primary, AppColors.emergency, troubleOpacity)!;

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
                color: troubleOpacity > 0.2 
                    ? AppColors.emergency.withValues(alpha: 0.15 * troubleOpacity)
                    : Colors.transparent,
                boxShadow: troubleOpacity > 0.5 
                    ? [
                        BoxShadow(
                          color: AppColors.emergency.withValues(alpha: 0.2 * troubleOpacity),
                          blurRadius: 20 * troubleOpacity,
                          spreadRadius: 10 * troubleOpacity,
                        )
                      ]
                    : [],
              ),
              child: Center(
                child: SizedBox(
                  width: 160,
                  height: 160,
                  child: CustomPaint(
                    painter: _SpeechPainter(
                      troubleFactor: troubleOpacity,
                      animationValue: value,
                    ),
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
                troubleOpacity < 0.5 ? 'Parole claire' : 'Parole confuse !',
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

class _SpeechPainter extends CustomPainter {
  final double troubleFactor; // 0.0 = smooth wave, 1.0 = jagged scribble
  final double animationValue; // For continuous wave movement

  _SpeechPainter({required this.troubleFactor, required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    // Draw stylized person profile on the left
    final profilePaint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.fill;
      
    Path profilePath = Path();
    profilePath.moveTo(size.width * 0.1, size.height * 0.8);
    profilePath.quadraticBezierTo(size.width * 0.2, size.height * 0.6, size.width * 0.2, size.height * 0.4);
    profilePath.arcToPoint(Offset(size.width * 0.4, size.height * 0.4), radius: Radius.circular(size.width * 0.1), clockwise: true);
    profilePath.quadraticBezierTo(size.width * 0.4, size.height * 0.6, size.width * 0.3, size.height * 0.8);
    profilePath.close();
    canvas.drawPath(profilePath, profilePaint);

    // Speech Bubble Background
    final bubblePaint = Paint()
      ..color = AppColors.background
      ..style = PaintingStyle.fill;
    
    final bubbleOutlinePaint = Paint()
      ..color = Color.lerp(AppColors.primary.withValues(alpha: 0.3), AppColors.emergency.withValues(alpha: 0.5), troubleFactor)!
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    final bubbleRect = Rect.fromLTRB(size.width * 0.3, size.height * 0.2, size.width * 0.95, size.height * 0.7);
    final bubbleRRect = RRect.fromRectAndRadius(bubbleRect, const Radius.circular(16));
    
    canvas.drawRRect(bubbleRRect, bubblePaint);
    canvas.drawRRect(bubbleRRect, bubbleOutlinePaint);

    // Draw Sound Wave / Text inside bubble
    final wavePaint = Paint()
      ..color = Color.lerp(AppColors.primary, AppColors.emergency, troubleFactor)!
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final waveCenterY = bubbleRect.center.dy;
    final waveStartX = bubbleRect.left + 15;
    final waveWidth = bubbleRect.width - 30;
    
    Path wavePath = Path();
    wavePath.moveTo(waveStartX, waveCenterY);

    // Generate wave points
    const int segments = 50;
    final double phaseShift = animationValue * 2 * pi * 4; // Moves the wave
    
    for (int i = 1; i <= segments; i++) {
      double t = i / segments;
      double x = waveStartX + (waveWidth * t);
      
      // Smooth sine wave
      double smoothY = sin((t * 2 * pi * 2) - phaseShift) * 15;
      
      // Jagged noise based on x and time
      double noise = (sin(i * 12.3 + phaseShift * 2) * cos(i * 7.1) * 25);
      
      // Interpolate between smooth and jagged based on troubleFactor
      double y = waveCenterY + (smoothY * (1 - troubleFactor)) + (noise * troubleFactor);
      
      wavePath.lineTo(x, y);
    }

    canvas.drawPath(wavePath, wavePaint);
  }

  @override
  bool shouldRepaint(covariant _SpeechPainter oldDelegate) {
    return oldDelegate.troubleFactor != troubleFactor || oldDelegate.animationValue != animationValue;
  }
}
