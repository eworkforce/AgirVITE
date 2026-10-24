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
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Spacer(),

                        // V.I.T.E Pulse Animation (Circle containing V.I.T.E)
                        Center(
                          child: Container(
                            width: 150,
                            height: 150,
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
                                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: ShaderMask(
                                    shaderCallback: (bounds) =>
                                        const LinearGradient(
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
                                            fontSize: 44,
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

                        const SizedBox(height: 20),

                        // Capsule 1 Intro Video (replaces central text "agir..")
                        Flexible(
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

                        const SizedBox(height: 20),

                        // AVC Espoir Logo + URL
                        Column(
                          children: [
                            Image.asset(
                              'assets/images/logo_avc_espoir.png',
                              height: 48,
                              fit: BoxFit.contain,
                            ),
                            const SizedBox(height: 6),
                            InkWell(
                              onTap: () async {
                                final uri = Uri.parse('https://avcespoir.org/');
                                if (await canLaunchUrl(uri)) {
                                  await launchUrl(uri);
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(6.0),
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
                        ).animate().fadeIn(delay: 600.ms).moveY(begin: 16, end: 0),

                        const Spacer(),

                        // Action Button
                        Padding(
                          padding: const EdgeInsets.only(bottom: 24.0, top: 16.0),
                          child: SizedBox(
                            width: double.infinity,
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
                              child: const Text('Continuer'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
