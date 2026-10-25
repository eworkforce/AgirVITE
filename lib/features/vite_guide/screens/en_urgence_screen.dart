import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/colors.dart';
import '../../emergency/widgets/sos_button.dart';
import '../../shared/widgets/vite_video_player.dart';

class EnUrgenceScreen extends ConsumerWidget {
  final VoidCallback onNext;

  const EnUrgenceScreen({super.key, required this.onNext});

  void _triggerSosFromGuide(BuildContext context, WidgetRef ref) {
    HapticFeedback.heavyImpact();
    ref.read(emergencyTriggerProvider.notifier).state++;
    context.go('/map?emergency=true');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 72.0),
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

            const SizedBox(height: 18),

            // Emergency Protocol Video
            Container(
              height: 250,
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
                caption: 'Protocole d\'urgence : Centre AVC et fenêtre 4h30',
                aspectRatio: 16 / 9,
              ),
            ).animate().fadeIn(delay: 400.ms).scale(begin: const Offset(0.95, 0.95)),

            const SizedBox(height: 22),

            // Stylized Two-Tier Headline (matching Dashboard style)
            Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.emergency.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.bolt_rounded,
                          size: 15,
                          color: AppColors.emergency,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '1 SEUL SIGNE V, I OU T SUFFIT',
                          maxLines: 1,
                          style: Theme.of(context)
                              .textTheme
                              .labelSmall
                              ?.copyWith(
                                color: AppColors.emergency,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 1.0,
                                fontSize: 11,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Si vous observez l'un de ces signes,\nn'attendez pas\u00A0!",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: AppColors.primary,
                        fontSize: 20,
                        letterSpacing: -0.3,
                        height: 1.25,
                      ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: 36,
                  height: 3.5,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.emergency, AppColors.primary],
                    ),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ],
            ).animate().fadeIn(delay: 500.ms),

            const SizedBox(height: 18),

            // CTA to trigger SOS Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                key: const Key('en_urgence_sos_cta_button'),
                onPressed: () => _triggerSosFromGuide(context, ref),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.emergency,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  elevation: 3,
                ),
                icon: const Icon(Icons.touch_app_rounded, size: 22),
                label: const Text(
                  'Activer le bouton SOS maintenant',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 15.5,
                  ),
                ),
              ),
            ).animate().fadeIn(delay: 600.ms).scale(),

            const SizedBox(height: 18),

            // 4h30 Time Window Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.emergency.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.emergency.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.timer_outlined,
                    color: AppColors.emergency,
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Il existe une fenêtre thérapeutique critique de 4h30 maximum pour agir et limiter les séquelles irréversibles.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.textPrimary,
                            height: 1.4,
                          ),
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(delay: 700.ms).slideY(begin: 0.2),
          ],
        ),
      ),
    );
  }
}
