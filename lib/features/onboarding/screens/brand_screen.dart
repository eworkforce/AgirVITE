import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../app/theme/colors.dart';
import '../providers/onboarding_provider.dart';
import '../../shared/widgets/vite_video_player.dart';

class BrandScreen extends ConsumerWidget {
  const BrandScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            children: [
              const Spacer(flex: 1),

              // 1. V.I.T.E Pulse Badge (compact & balanced)
              Center(
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 16,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14.0),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: ShaderMask(
                          shaderCallback: (bounds) => const LinearGradient(
                            colors: [
                              AppColors.primary,
                              Color(0xFF8BC34A),
                            ],
                            tileMode: TileMode.mirror,
                          ).createShader(bounds),
                          child: Text(
                            "V.I.T.E",
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 40,
                                  color: Colors.white,
                                  letterSpacing: 1.5,
                                ),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
                    .animate(
                      onPlay: (controller) => controller.repeat(reverse: true),
                    )
                    .scale(
                      begin: const Offset(1.0, 1.0),
                      end: const Offset(1.04, 1.04),
                      duration: 2.seconds,
                      curve: Curves.easeInOut,
                    ),
              ),

              const Spacer(flex: 1),

              // 2. Capsule 1 Intro Video (adapts to available height without overflowing)
              Flexible(
                flex: 6,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 440),
                  child: const ViteVideoPlayer(
                    assetPath: 'assets/videos/master_avc_espoir_vite.mp4',
                    autoPlay: false,
                    looping: false,
                    aspectRatio: 16 / 9,
                    borderRadius: 16,
                  ),
                ).animate().fadeIn(delay: 300.ms).scale(
                      begin: const Offset(0.96, 0.96),
                      end: const Offset(1.0, 1.0),
                      duration: 400.ms,
                    ),
              ),

              const Spacer(flex: 1),

              // 3. AVC Espoir Logo + Website Link
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/images/logo_avc_espoir.png',
                    height: 42,
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
                    borderRadius: BorderRadius.circular(8),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8.0,
                        vertical: 4.0,
                      ),
                      child: Text(
                        "https://avcespoir.org/",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.textSecondary,
                              decoration: TextDecoration.underline,
                            ),
                      ),
                    ),
                  ),
                ],
              ).animate().fadeIn(delay: 500.ms).moveY(begin: 12, end: 0),

              const Spacer(flex: 1),

              // 4. Prominent & Intuitive "Continuer" Call-to-Action Button (Always visible in viewport)
              SizedBox(
                width: double.infinity,
                height: 60,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    gradient: const LinearGradient(
                      colors: [
                        AppColors.primary,
                        Color(0xFF008B97),
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.35),
                        blurRadius: 16,
                        spreadRadius: 1,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      final isComplete =
                          ref.read(onboardingControllerProvider).valueOrNull ??
                              false;
                      if (isComplete) {
                        context.go('/dashboard');
                      } else {
                        context.go('/onboarding/pledge');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Continuer',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.6,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.arrow_forward_rounded,
                            color: Colors.white,
                            size: 20,
                          )
                              .animate(
                                onPlay: (controller) =>
                                    controller.repeat(reverse: true),
                              )
                              .moveX(
                                begin: -2,
                                end: 3,
                                duration: 800.ms,
                                curve: Curves.easeInOut,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
                  .animate()
                  .fadeIn(delay: 650.ms)
                  .slideY(begin: 0.2, end: 0, duration: 450.ms)
                  .then()
                  .animate(
                    onPlay: (controller) => controller.repeat(reverse: true),
                  )
                  .scale(
                    begin: const Offset(1.0, 1.0),
                    end: const Offset(1.02, 1.02),
                    duration: 1400.ms,
                    curve: Curves.easeInOut,
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
