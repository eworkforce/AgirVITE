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
            
            // Animated Visual Placeholder (Crossfade)
            const _ImageCrossfadePlaceholder().animate().fadeIn(delay: 400.ms).scale(begin: const Offset(0.9, 0.9)),

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
        // 0.0 - 0.4: Normal
        // 0.4 - 0.5: Fade to Droop
        // 0.5 - 0.9: Drooping
        // 0.9 - 1.0: Fade back to Normal
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
            // Image Container
            Container(
              width: double.infinity,
              height: 220,
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
              clipBehavior: Clip.antiAlias,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Base Normal Image
                  _buildImage('assets/images/bras_normal.jpg'),
                  
                  // Droop Image fades over it
                  Opacity(
                    opacity: droopOpacity,
                    child: _buildImage('assets/images/bras_droop.jpg'),
                  ),
                  
                  // Warning icon
                  if (droopOpacity > 0.8)
                    Positioned(
                      top: 12,
                      right: 12,
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
                droopOpacity < 0.5 ? 'Bras maintenus à l\'horizontale' : 'Un bras retombe !',
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
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
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
