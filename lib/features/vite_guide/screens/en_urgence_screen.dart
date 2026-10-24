import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../app/theme/colors.dart';
import '../../shared/widgets/vite_video_player.dart';

class EnUrgenceScreen extends StatelessWidget {
  final VoidCallback onNext;

  const EnUrgenceScreen({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
        child: Column(
          children: [
            // Title Section
            Text(
              'E - En Urgence',
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    color: AppColors.emergency,
                    fontWeight: FontWeight.bold,
                  ),
            ).animate().fadeIn(duration: 500.ms).slideY(begin: -0.2),
            const SizedBox(height: 6),
            Text(
              'Chaque minute compte (Time is Brain)',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ).animate().fadeIn(delay: 200.ms),

            const SizedBox(height: 20),

            // Emergency Protocol Video
            Container(
              height: 260,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.emergency.withValues(alpha: 0.15),
                    blurRadius: 20,
                    spreadRadius: 2,
                    offset: const Offset(0, 8),
                  )
                ],
              ),
              clipBehavior: Clip.antiAlias,
              child: const ViteVideoPlayer(
                assetPath: 'assets/videos/master_urgence_e.mp4',
                caption: 'Protocole d\'urgence : SAMU 185 et fenêtre 4h30',
                aspectRatio: 16 / 9,
              ),
            ).animate().fadeIn(delay: 400.ms).scale(begin: const Offset(0.95, 0.95)),

            const SizedBox(height: 24),

            Text(
              'Si vous observez l\'un de ces signes,\nn\'attendez pas !',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ).animate().fadeIn(delay: 500.ms),

            const SizedBox(height: 12),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.emergency.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.emergency.withValues(alpha: 0.4)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.phone_in_talk, color: AppColors.emergency, size: 20),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      'Appelez immédiatement le SAMU (185)',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.emergency,
                          ),
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(delay: 600.ms).scale(),

            const SizedBox(height: 20),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.emergency.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.emergency.withValues(alpha: 0.3)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.timer_outlined, color: AppColors.emergency, size: 28),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Il existe une fenêtre thérapeutique critique de 4h30 maximum pour la thrombolyse et limiter les séquelles irréversibles.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.textPrimary,
                            height: 1.4,
                          ),
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(delay: 700.ms).slideY(begin: 0.2),

            const SizedBox(height: 28),

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
                  'Terminer le Guide',
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
