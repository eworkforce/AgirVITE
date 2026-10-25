import 'package:flutter/material.dart';
import '../../../app/theme/colors.dart';

/// Stylized two-tier alert banner displayed right below the "Comment tester ?"
/// box on each V, I, and T guide screen.
///
/// Reinforces the core clinical rule: a single suspicious sign among V, I, or T
/// is enough to immediately trigger SOS within the 4h30 window.
class ViteSingleSignAlertBanner extends StatelessWidget {
  final VoidCallback? onJumpToUrgence;

  const ViteSingleSignAlertBanner({
    super.key,
    this.onJumpToUrgence,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onJumpToUrgence,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppColors.emergency.withValues(alpha: 0.28),
            width: 1.4,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.emergency.withValues(alpha: 0.08),
              blurRadius: 14,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Top pill badge: guaranteed single-line via FittedBox
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
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
                      '1 SEUL SIGNE SUFFIT • FENÊTRE 4H30',
                      maxLines: 1,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: AppColors.emergency,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.8,
                            fontSize: 11,
                          ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            // Stylized headline: guaranteed single-line so '!' never wraps alone
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                "Ce signe apparaît\u00A0? N'attendez pas\u00A0!",
                maxLines: 1,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                      fontSize: 18,
                      letterSpacing: -0.2,
                    ),
              ),
            ),
            const SizedBox(height: 6),
            // Subtle centered gradient bar
            Container(
              width: 32,
              height: 3,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.emergency, AppColors.primary],
                ),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 8),
            // Crisp call to action inside the same box
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.touch_app_rounded,
                  size: 16,
                  color: AppColors.emergency,
                ),
                const SizedBox(width: 5),
                Text(
                  'Cliquez sur SOS',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: AppColors.emergency,
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
                        letterSpacing: 0.2,
                      ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
