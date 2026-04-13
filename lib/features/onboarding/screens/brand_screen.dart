import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../app/theme/colors.dart';
import '../providers/onboarding_provider.dart';

class BrandScreen extends ConsumerWidget {
  const BrandScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(),
            // V.I.T.E Pulse Animation (Inverted with Logo)
            Center(
              child: Container(
                width: 220,
                height: 220,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 20,
                      offset: Offset(0, 10),
                    )
                  ],
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: ShaderMask(
                        shaderCallback: (bounds) => const LinearGradient(
                          colors: [AppColors.primary, Color(0xFF8BC34A)], // Green gradient
                          tileMode: TileMode.mirror,
                        ).createShader(bounds),
                        child: Text(
                          "V.I.T.E",
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.w900, // Extra Bold
                            fontSize: 56, // Increased by twice
                            color: Colors.white, // Required for ShaderMask
                            letterSpacing: 1.5,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              )
              .animate(onPlay: (controller) => controller.repeat(reverse: true))
              .scale(
                begin: const Offset(1.0, 1.0),
                end: const Offset(1.05, 1.05),
                duration: 2.seconds,
                curve: Curves.easeInOut,
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Slogan
            Text(
              "Pour sauver des Vies, évitons l'AVC,\nS'informer, prévenir et agir",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
                height: 1.5,
              ),
            ).animate().fadeIn(delay: 500.ms).moveY(begin: 20, end: 0),
            
            const SizedBox(height: 48),

            // AVC Espoir Logo (Decreased size) + URL
            Column(
              children: [
                Text(
                  "L'Application V.I.T.E produite par :",
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 12),
                Image.asset(
                  'assets/images/logo_avc_espoir.png',
                  height: 50, // Decreased by half
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 4),
                InkWell(
                  onTap: () async {
                    final uri = Uri.parse('https://avcespoir.org/');
                    if (await canLaunchUrl(uri)) {
                      await launchUrl(uri);
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "https://avcespoir.org/",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.primary,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
              ],
            ).animate().fadeIn(delay: 700.ms).moveY(begin: 20, end: 0),

            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    final isComplete = ref.read(onboardingControllerProvider).valueOrNull ?? false;
                    if (isComplete) {
                      context.go('/dashboard');
                    } else {
                      context.go('/onboarding/pledge');
                    }
                  },
                  child: const Text('Continuer'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
