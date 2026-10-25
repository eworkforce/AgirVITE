import 'package:flutter/material.dart';
import '../../../app/theme/colors.dart';

/// Displays a consistent step progress indicator ("Étape X sur 3") and
/// back navigation button across the 3 interactive onboarding steps.
class OnboardingProgressHeader extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final VoidCallback? onBack;

  const OnboardingProgressHeader({
    super.key,
    required this.currentStep,
    this.totalSteps = 3,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            if (onBack != null)
              IconButton(
                key: const Key('onboarding_back_button'),
                onPressed: onBack,
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 20,
                  color: AppColors.textPrimary,
                ),
                tooltip: 'Retour',
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
              )
            else
              const SizedBox(width: 36, height: 36),
            Expanded(
              child: Text(
                'Étape $currentStep sur $totalSteps',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.4,
                    ),
              ),
            ),
            const SizedBox(width: 36, height: 36),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: List.generate(totalSteps, (index) {
            final isCompletedOrActive = (index + 1) <= currentStep;
            return Expanded(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                margin: EdgeInsets.only(right: index < totalSteps - 1 ? 8 : 0),
                height: 6,
                decoration: BoxDecoration(
                  color: isCompletedOrActive
                      ? AppColors.primary
                      : AppColors.primary.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}
