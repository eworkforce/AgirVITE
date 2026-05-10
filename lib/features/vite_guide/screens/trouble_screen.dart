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
                      painter: _SpeechPainter(
                        troubleFactor: troubleOpacity,
                        animationValue: value,
                      ),
                    ),
                  ),
                  if (troubleOpacity > 0.5)
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
  final double troubleFactor; // 0.0 = clear speech, 1.0 = confused speech
  final double animationValue; // For continuous movement

  _SpeechPainter({required this.troubleFactor, required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    
    // Draw person profile (chest and head)
    final profilePaint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.fill;
      
    // Body (Shirt)
    Path bodyPath = Path();
    bodyPath.moveTo(center.dx - size.width * 0.25, size.height * 0.9);
    bodyPath.quadraticBezierTo(center.dx, size.height * 0.7, center.dx + size.width * 0.25, size.height * 0.9);
    bodyPath.lineTo(center.dx + size.width * 0.25, size.height);
    bodyPath.lineTo(center.dx - size.width * 0.25, size.height);
    bodyPath.close();
    canvas.drawPath(bodyPath, profilePaint);

    // Head
    final skinPaint = Paint()
      ..color = const Color(0xFFFFD1B3) // Skin tone
      ..style = PaintingStyle.fill;
      
    final headRadius = size.width * 0.16;
    final headCenter = Offset(center.dx, center.dy + size.height * 0.05);
    canvas.drawCircle(headCenter, headRadius, skinPaint);
    
    // Hair
    final hairPaint = Paint()
      ..color = const Color(0xFF3E2723)
      ..style = PaintingStyle.fill;
    
    Path hairPath = Path();
    hairPath.moveTo(headCenter.dx - headRadius, headCenter.dy);
    hairPath.quadraticBezierTo(headCenter.dx - headRadius, headCenter.dy - headRadius * 1.2, headCenter.dx, headCenter.dy - headRadius * 1.2);
    hairPath.quadraticBezierTo(headCenter.dx + headRadius, headCenter.dy - headRadius * 1.2, headCenter.dx + headRadius, headCenter.dy);
    hairPath.quadraticBezierTo(headCenter.dx, headCenter.dy - headRadius * 0.5, headCenter.dx - headRadius, headCenter.dy);
    canvas.drawPath(hairPath, hairPaint);

    // Speech Bubble
    final bubbleRect = Rect.fromLTRB(
      center.dx + size.width * 0.05, 
      center.dy - size.height * 0.4, 
      center.dx + size.width * 0.45, 
      center.dy - size.height * 0.1
    );
    
    final bubblePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
      
    final bubbleOutlinePaint = Paint()
      ..color = Color.lerp(AppColors.primary, AppColors.emergency, troubleFactor)!
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    final bubbleRRect = RRect.fromRectAndRadius(bubbleRect, const Radius.circular(16));
    canvas.drawRRect(bubbleRRect, bubblePaint);
    canvas.drawRRect(bubbleRRect, bubbleOutlinePaint);
    
    // Bubble Tail
    Path tailPath = Path();
    tailPath.moveTo(bubbleRect.left + 15, bubbleRect.bottom);
    tailPath.lineTo(bubbleRect.left + 5, bubbleRect.bottom + 15);
    tailPath.lineTo(bubbleRect.left + 25, bubbleRect.bottom);
    canvas.drawPath(tailPath, bubblePaint);
    
    // Draw the outline of the tail, skipping the top edge where it connects
    Path tailOutlinePath = Path();
    tailOutlinePath.moveTo(bubbleRect.left + 15, bubbleRect.bottom);
    tailOutlinePath.lineTo(bubbleRect.left + 5, bubbleRect.bottom + 15);
    tailOutlinePath.lineTo(bubbleRect.left + 25, bubbleRect.bottom);
    canvas.drawPath(tailOutlinePath, bubbleOutlinePaint);

    // Draw content inside the bubble
    // We'll draw 3 clear dots initially, morphing into a large red question mark and scrambled lines
    final contentCenter = bubbleRect.center;
    
    if (troubleFactor < 0.5) {
      // Clear speech: 3 dots (ellipsis) animating up and down
      final dotPaint = Paint()
        ..color = AppColors.primary
        ..style = PaintingStyle.fill;
        
      final offset1 = sin(animationValue * 2 * pi * 4) * 3;
      final offset2 = sin(animationValue * 2 * pi * 4 + pi/2) * 3;
      final offset3 = sin(animationValue * 2 * pi * 4 + pi) * 3;
      
      canvas.drawCircle(Offset(contentCenter.dx - 12, contentCenter.dy + offset1), 4, dotPaint);
      canvas.drawCircle(Offset(contentCenter.dx, contentCenter.dy + offset2), 4, dotPaint);
      canvas.drawCircle(Offset(contentCenter.dx + 12, contentCenter.dy + offset3), 4, dotPaint);
    } else {
      // Troubled speech: A red question mark and scrambled lines
      final troublePaint = Paint()
        ..color = AppColors.emergency
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round;
        
      // Draw "?"
      TextSpan span = TextSpan(
        style: TextStyle(
          color: AppColors.emergency,
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
        text: '?',
      );
      TextPainter tp = TextPainter(
        text: span,
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      );
      tp.layout();
      tp.paint(canvas, Offset(contentCenter.dx - tp.width/2, contentCenter.dy - tp.height/2));
      
      // Draw jagged line showing confusion
      Path jaggedPath = Path();
      jaggedPath.moveTo(bubbleRect.left + 10, bubbleRect.bottom - 10);
      
      // Animate the jaggedness
      final noiseOffset = sin(animationValue * 2 * pi * 10) * 5;
      
      jaggedPath.lineTo(bubbleRect.left + 20, bubbleRect.top + 20 + noiseOffset);
      jaggedPath.lineTo(bubbleRect.right - 20, bubbleRect.bottom - 15 - noiseOffset);
      jaggedPath.lineTo(bubbleRect.right - 10, bubbleRect.top + 10 + noiseOffset);
      
      canvas.drawPath(jaggedPath, troublePaint..color = AppColors.emergency.withValues(alpha: 0.5));
    }
  }

  @override
  bool shouldRepaint(covariant _SpeechPainter oldDelegate) {
    return oldDelegate.troubleFactor != troubleFactor || oldDelegate.animationValue != animationValue;
  }
}
