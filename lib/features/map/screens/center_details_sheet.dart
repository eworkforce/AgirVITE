import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../app/theme/colors.dart';
import '../../../core/models/stroke_center.dart';
import '../../../core/services/emergency_service.dart';
import '../../emergency/widgets/emergency_map_overlay.dart';
import '../../shared/widgets/calm_button.dart';

class CenterDetailsSheet extends ConsumerWidget {
  final StrokeCenter center;

  const CenterDetailsSheet({super.key, required this.center});

  Future<void> _launchNavigation(BuildContext context) async {
    final confirmed = await showExternalActionConfirmOverlay(
      context: context,
      title: 'Itinéraire vers ${center.name} ?',
      subtitle: 'Ouvrir Google Maps pour vous guider vers ${center.address}.',
      confirmLabel: 'Y Aller',
      icon: Icons.directions_car_rounded,
      accentColor: AppColors.primary,
    );
    if (!confirmed) return;

    final Uri googleMapsAppUri = Uri.parse(
      "google.navigation:q=${center.latitude},${center.longitude}&mode=d",
    );
    final Uri googleMapsWebUri = Uri.parse(
      "https://www.google.com/maps/dir/?api=1&destination=${center.latitude},${center.longitude}&travelmode=driving",
    );

    try {
      if (await canLaunchUrl(googleMapsAppUri)) {
        await launchUrl(googleMapsAppUri);
      } else {
        await launchUrl(
          googleMapsWebUri,
          mode: LaunchMode.externalApplication,
        );
      }
    } catch (e) {
      debugPrint('Could not launch maps: $e');
    }
  }

  Future<void> _callCenter(BuildContext context, WidgetRef ref) async {
    final confirmed = await showExternalActionConfirmOverlay(
      context: context,
      title: 'Appeler ${center.name} ?',
      subtitle: 'Lancer un appel téléphonique vers le ${center.phone}.',
      confirmLabel: 'Appeler',
      icon: Icons.phone_in_talk_rounded,
      accentColor: AppColors.emergency,
    );
    if (!confirmed) return;

    await ref.read(emergencyServiceProvider).callCenter(center.phone);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.95),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: const [BoxShadow(blurRadius: 10, color: Colors.black12)],
      ),
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: Text(
                  center.name,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                ),
              ),
              if (center.hasScanner)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.success),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.check_circle, size: 14, color: AppColors.success),
                      SizedBox(width: 4),
                      Text(
                        'Scanner',
                        style: TextStyle(
                          color: AppColors.success,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.location_on, size: 16, color: Colors.grey),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  '${center.address} • ${center.phone}',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: Colors.grey[700]),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: CalmButton(
                  text: 'Y Aller',
                  isPrimary: true,
                  onPressed: () => _launchNavigation(context),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: CalmButton(
                  text: 'Appeler',
                  isPrimary: false,
                  onPressed: () => _callCenter(context, ref),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
