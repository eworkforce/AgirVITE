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
    return const _ImageCrossfadePlaceholder();
  }
}

class _ImageCrossfadePlaceholder extends StatefulWidget {
  const _ImageCrossfadePlaceholder();

  @override
  State<_ImageCrossfadePlaceholder> createState() => _ImageCrossfadePlaceholderState();
}

class _ImageCrossfadePlaceholderState extends State<_ImageCrossfadePlaceholder> with SingleTickerProviderStateMixin {
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
          children: [
            // Image Container (Aspect Ratio matched to landscape photos)
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: statusColor, width: 4),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  )
                ],
              ),
              clipBehavior: Clip.antiAlias, // Ensures the images don't bleed out of the rounded corners
              child: AspectRatio(
                aspectRatio: 16 / 9, // Forces the container to be a landscape rectangle perfectly wrapping the image
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Base Normal Image
                    _buildImage('assets/images/visage_normal.jpg'),
                    
                    // Droop Image fades over it
                    Opacity(
                      opacity: droopOpacity,
                      child: _buildImage('assets/images/visage_droop.jpg'),
                    ),
                    
                    // Warning icon
                    if (droopOpacity > 0.8)
                      Positioned(
                        top: 10,
                        right: 10,
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
                            size: 28,
                          ),
                        ).animate().scale(curve: Curves.elasticOut),
                      ),
                  ],
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

  Widget _buildImage(String path) {
    return Image.asset(
      path,
      fit: BoxFit.cover, // Fills the 16:9 AspectRatio container completely edge-to-edge
      errorBuilder: (context, error, stackTrace) {
        // Fallback UI when images are missing
        return Container(
          color: Colors.grey[200],
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.image_not_supported, color: Colors.grey, size: 40),
              const SizedBox(height: 8),
              Text(
                'Missing Image:\n$path',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.black54, fontSize: 12),
              ),
            ],
          ),
        );
      },
    );
  }
}
