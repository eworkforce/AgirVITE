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
            
            // Animated Visual Placeholder (Simulating the Rive animation)
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
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Background decorative circle
                  Container(
                    width: 180,
                    height: 180,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.background,
                    ),
                  ).animate(onPlay: (controller) => controller.repeat(reverse: true))
                   .scale(begin: const Offset(0.95, 0.95), end: const Offset(1.05, 1.05), duration: 2.seconds, curve: Curves.easeInOut),
                   
                  // Face changing states
                  _buildAnimatedFaceSequence(),
                ],
              ),
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

  Widget _buildAnimatedFaceSequence() {
    // We create a sequence: Normal Face -> Wait -> Drooping Face -> Wait -> Loop
    return const SizedBox.shrink()
        .animate(onPlay: (controller) => controller.repeat())
        .custom(
          duration: 4.seconds,
          builder: (context, value, child) {
            // value goes from 0.0 to 1.0 over 4 seconds
            // 0.0 - 0.4: Normal
            // 0.4 - 0.5: Transition
            // 0.5 - 0.9: Drooping
            // 0.9 - 1.0: Transition back
            
            bool isDrooping = value > 0.4 && value < 0.9;
            double transition = 0.0;
            if (value > 0.35 && value <= 0.45) {
              transition = (value - 0.35) * 10; // 0 to 1
            } else if (value > 0.85 && value <= 0.95) {
              transition = 1.0 - ((value - 0.85) * 10); // 1 to 0
            } else if (isDrooping) {
              transition = 1.0;
            }
            
            // Clamp value between 0.0 and 1.0 just to be safe
            transition = transition.clamp(0.0, 1.0);
            
            return _FacePlaceholder(droopFactor: transition);
          },
        );
  }
}

class _FacePlaceholder extends StatelessWidget {
  final double droopFactor; // 0.0 = normal, 1.0 = fully drooping

  const _FacePlaceholder({required this.droopFactor});

  @override
  Widget build(BuildContext context) {
    // We use a fixed status color for the warning UI, but the face stays natural
    final statusColor = Color.lerp(AppColors.primary, AppColors.emergency, droopFactor)!;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Custom Drawn Cartoon Face
        SizedBox(
          width: 140,
          height: 160,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // Hair (Back part)
              Positioned(
                top: 5,
                left: 15,
                right: 15,
                child: Container(
                  height: 60,
                  decoration: const BoxDecoration(
                    color: Color(0xFF2C1E16), // Dark brown/black hair
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50),
                    ),
                  ),
                ),
              ),
              
              // Main Face Base
              Positioned(
                top: 20,
                left: 20,
                right: 20,
                child: Container(
                  height: 120,
                  decoration: BoxDecoration(
                    color: const Color(0xFF8D5524), // Warm brown skin tone
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                      bottomLeft: Radius.circular(50),
                      bottomRight: Radius.circular(50),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      )
                    ],
                  ),
                ),
              ),

              // Hair (Front/Textured)
              Positioned(
                top: 15,
                left: 25,
                right: 25,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(4, (index) => Container(
                    width: 20,
                    height: 15,
                    decoration: const BoxDecoration(
                      color: Color(0xFF2C1E16),
                      shape: BoxShape.circle,
                    ),
                  )),
                ),
              ),

              // Left Eye (Normal)
              Positioned(
                left: 45,
                top: 60,
                child: _buildEye(isDrooping: false),
              ),
              
              // Right Eye (Droops based on factor)
              Positioned(
                right: 45,
                top: 60 + (droopFactor * 10), // Entire eye shifts down slightly
                child: _buildEye(isDrooping: true, factor: droopFactor),
              ),
              
              // Nose (Subtle)
              Positioned(
                top: 85,
                left: 65,
                right: 65,
                child: Container(
                  height: 15,
                  decoration: BoxDecoration(
                    color: const Color(0xFF70431C), // Slightly darker than skin
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              // Mouth
              Positioned(
                bottom: 30,
                left: 40,
                right: 40,
                child: SizedBox(
                  height: 30,
                  child: CustomPaint(
                    painter: _CartoonMouthPainter(
                      droopFactor: droopFactor,
                    ),
                  ),
                ),
              ),
              
              // Warning icon
              if (droopFactor > 0.8)
                Positioned(
                  top: 0,
                  right: -5,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
                    ),
                    child: const Icon(
                      Icons.warning_rounded,
                      color: AppColors.emergency,
                      size: 32,
                    ),
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
            droopFactor < 0.5 ? 'Sourire symétrique' : 'Affaissement facial !',
            style: TextStyle(
              color: statusColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEye({required bool isDrooping, double factor = 0.0}) {
    // Eye closes/squints as droop factor increases
    double eyeHeight = 16.0 - (isDrooping ? factor * 10 : 0);
    
    return Container(
      width: 16,
      height: 16,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Container(
        width: 8,
        height: eyeHeight.clamp(2.0, 16.0), // Pupil height changes
        decoration: BoxDecoration(
          color: const Color(0xFF2C1E16),
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }
}

class _CartoonMouthPainter extends CustomPainter {
  final double droopFactor;

  _CartoonMouthPainter({required this.droopFactor});

  @override
  void paint(Canvas canvas, Size size) {
    // Outer Lip (Darker Skin Tone)
    final lipPaint = Paint()
      ..color = const Color(0xFF5A3515)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    // Inner Mouth (Dark Red/Black)
    final mouthFill = Paint()
      ..color = const Color(0xFF3E1F1F)
      ..style = PaintingStyle.fill;

    final path = Path();
    
    // Contain the mouth slightly inward to prevent it from looking too wide
    double startX = size.width * 0.15;
    double endX = size.width * 0.85;
    
    double startY = size.height * 0.4;
    double midY = size.height * 0.7;
    // Reduce the extreme drop so it doesn't extend outside the face
    double endY = size.height * 0.4 + (droopFactor * size.height * 0.5); 
    
    // Draw the smile/droop curve
    path.moveTo(startX, startY);
    path.quadraticBezierTo(
      size.width / 2, 
      midY + (droopFactor * size.height * 0.2), // Middle sags slightly
      endX, 
      endY
    );
    
    // If it's a normal smile (low droop), make the mouth slightly open to show happiness
    if (droopFactor < 0.3) {
      // Scale down the openness as it starts to droop
      double openness = 1.0 - (droopFactor / 0.3);
      
      final bottomPath = Path()
        ..moveTo(startX, startY)
        ..quadraticBezierTo(
          size.width / 2, 
          size.height * 0.7 + (openness * size.height * 0.4), // Softer open mouth curve
          endX, 
          endY
        );
      
      // Fill the open mouth
      final fullMouth = Path.combine(PathOperation.union, path, bottomPath);
      canvas.drawPath(fullMouth, mouthFill);
      canvas.drawPath(bottomPath, lipPaint);
    }

    // Always draw the top lip line
    canvas.drawPath(path, lipPaint);
  }

  @override
  bool shouldRepaint(covariant _CartoonMouthPainter oldDelegate) {
    return oldDelegate.droopFactor != droopFactor;
  }
}
