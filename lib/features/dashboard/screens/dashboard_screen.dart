import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/colors.dart';
import '../../profile/providers/profile_provider.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  String _capitalizeFirst(String text) {
    if (text.isEmpty) return text;
    return '${text[0].toUpperCase()}${text.substring(1).toLowerCase()}';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfileAsync = ref.watch(userProfileProvider);
    final displayName = userProfileAsync.valueOrNull?.displayName ?? '';
    final firstName = _capitalizeFirst(displayName.split(' ').first);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20.0, 14.0, 20.0, 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // 1. Header with greeting and profile avatar
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/logo_avc_espoir.png',
                              height: 44,
                              width: 44,
                              fit: BoxFit.contain,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    firstName.isNotEmpty
                                        ? 'Bonjour, $firstName'
                                        : 'Bonjour,',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                  Text(
                                    'Reconnaître les signes d\'un AVC',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(
                                          color: AppColors.textSecondary,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              onPressed: () => context.push('/profile'),
                              icon: Container(
                                padding: const EdgeInsets.all(9),
                                decoration: BoxDecoration(
                                  color: AppColors.secondary
                                      .withValues(alpha: 0.3),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.person,
                                  color: AppColors.primary,
                                  size: 22,
                                ),
                              ),
                            ),
                          ],
                        ),

                        // Balanced top spacer so the title + 2x2 grid sit vertically centered
                        const Spacer(flex: 1),

                        // 2. Stylized Editorial Title + 2x2 V.I.T.E. Grid
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Stylized pill overline: "Chaque minute compte"
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.emergency.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(20),
                              ),
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
                                    'CHAQUE MINUTE COMPTE',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelSmall
                                        ?.copyWith(
                                          color: AppColors.emergency,
                                          fontWeight: FontWeight.w800,
                                          letterSpacing: 1.1,
                                          fontSize: 11,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            // Stylized headline: "Comprendre les signes d'alerte"
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                "Comprendre les signes d'alerte",
                                textAlign: TextAlign.center,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.primary,
                                      fontSize: 21,
                                      letterSpacing: -0.3,
                                    ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                "Un seul signe V, I ou T suffit → Urgence E",
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: AppColors.textSecondary,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                    ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            // Subtle centered accent bar
                            Container(
                              width: 36,
                              height: 3.5,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    AppColors.primary,
                                    AppColors.secondary,
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                            const SizedBox(height: 16),

                            // 2x2 Action Grid (V.I.T.E.)
                            Row(
                              children: [
                                Expanded(
                                  child: _ViteCard(
                                    letter: 'V',
                                    imagePath: 'assets/images/GuideVite1.jpeg',
                                    onTap: () => _goToViteTab(context, 0),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: _ViteCard(
                                    letter: 'I',
                                    imagePath:
                                        'assets/images/incapacite_arm_ci.jpg',
                                    onTap: () => _goToViteTab(context, 1),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: _ViteCard(
                                    letter: 'T',
                                    imagePath:
                                        'assets/images/trouble_parole_ci.jpg',
                                    onTap: () => _goToViteTab(context, 2),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: _ViteCard(
                                    letter: 'E',
                                    imagePath: 'assets/images/Centre1.jpeg',
                                    onTap: () => _goToViteTab(context, 3),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        // Balanced bottom spacer + offset for the docked SOS arch
                        const Spacer(flex: 1),
                        const SizedBox(height: 44),
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

  void _goToViteTab(BuildContext context, int index) {
    context.push('/vite-guide', extra: index);
  }
}

class _ViteCard extends StatelessWidget {
  final String letter;
  final String imagePath;
  final VoidCallback onTap;

  const _ViteCard({
    required this.letter,
    required this.imagePath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 0.96,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 12,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Background Image
              Positioned.fill(
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                ),
              ),
              // Subtle dark overlay to let the photo show through while highlighting the center letter
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.20),
                        Colors.black.withValues(alpha: 0.10),
                        Colors.black.withValues(alpha: 0.35),
                      ],
                    ),
                  ),
                ),
              ),
              // Large centered badge with prominent letter
              Center(
                child: Container(
                  width: 78,
                  height: 78,
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.48),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.88),
                      width: 2.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.35),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    letter,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 46,
                      height: 1.0,
                      letterSpacing: -0.5,
                    ),
                  ),
                ),
              ),
              // Interactive touch ripple
              Positioned.fill(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: onTap,
                    splashColor: Colors.white.withValues(alpha: 0.25),
                    highlightColor: Colors.white.withValues(alpha: 0.12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
