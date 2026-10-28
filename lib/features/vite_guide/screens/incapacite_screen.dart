import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../app/theme/colors.dart';
import '../../shared/widgets/vite_video_player.dart';
import '../widgets/vite_single_sign_alert_banner.dart';
import '../widgets/vite_voice_guide_button.dart';

class IncapaciteScreen extends StatelessWidget {
  final VoidCallback onNext;
  final VoidCallback? onJumpToUrgence;

  const IncapaciteScreen({
    super.key,
    required this.onNext,
    this.onJumpToUrgence,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 68.0),
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
            const SizedBox(height: 6),
            Text(
              'Faiblesse d\'un membre (bras/jambe)',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ).animate().fadeIn(delay: 200.ms),

            const SizedBox(height: 18),

            // Visual Container
            Container(
              height: 250,
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
              clipBehavior: Clip.antiAlias,
              child: const ViteVideoPlayer(
                assetPath: 'assets/videos/master_incapacite_i.mp4',
                caption: 'Test de Mingazzini : chute d\'un bras',
                aspectRatio: 16 / 9,
                looping: false,
              ),
            ).animate().fadeIn(delay: 400.ms).scale(begin: const Offset(0.95, 0.95)),

            const SizedBox(height: 18),

            // Explanation Text ("Comment tester ?")
            Container(
              padding: const EdgeInsets.all(18),
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
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Comment tester ?',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                        ),
                      ),
                      const ViteVoiceGuideButton(
                        audioAssetPath: 'assets/audio/Signe-I.mp3',
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Demandez à la personne de lever les deux bras à l\'horizontale pendant 10 secondes. Un des bras retombe-t-il ou est-il impossible à lever ?',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppColors.textPrimary,
                          height: 1.45,
                        ),
                  ),
                ],
              ),
            ).animate().fadeIn(delay: 550.ms).slideY(begin: 0.2),

            const SizedBox(height: 16),

            // Stylized Single-Sign Alert Banner (right after "Comment tester ?")
            ViteSingleSignAlertBanner(
              onJumpToUrgence: onJumpToUrgence,
            ).animate().fadeIn(delay: 680.ms),

            const SizedBox(height: 20),

            // Action Button
            SizedBox(
              width: double.infinity,
              height: 54,
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
