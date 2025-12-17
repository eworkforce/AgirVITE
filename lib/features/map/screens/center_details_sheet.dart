import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'package:latlong2/latlong.dart';
import '../../../app/theme/colors.dart';
import '../../../core/models/stroke_center.dart';
import '../../shared/widgets/calm_button.dart';

class CenterDetailsSheet extends StatelessWidget {
  final StrokeCenter center;

  const CenterDetailsSheet({super.key, required this.center});

  Future<void> _launchNavigation() async {
    // 1. Try Google Maps App Deep Link (Driving Mode)
    final Uri googleMapsAppUri = Uri.parse(
        "google.navigation:q=${center.latitude},${center.longitude}&mode=d");
    
    // 2. Fallback Web URL
    final Uri googleMapsWebUri = Uri.parse(
        "https://www.google.com/maps/dir/?api=1&destination=${center.latitude},${center.longitude}&travelmode=driving");

    try {
      if (await canLaunchUrl(googleMapsAppUri)) {
        await launchUrl(googleMapsAppUri);
      } else {
        await launchUrl(googleMapsWebUri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      debugPrint('Could not launch maps: $e');
    }
  }

  Future<void> _callCenter() async {
    final Uri telUri = Uri(scheme: 'tel', path: center.phone.replaceAll(' ', ''));
    if (await canLaunchUrl(telUri)) {
      await launchUrl(telUri);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [BoxShadow(blurRadius: 10, color: Colors.black12)],
      ),
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag Handle
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

          // Title & Badge
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

          // Address
          Row(
            children: [
              const Icon(Icons.location_on, size: 16, color: Colors.grey),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  center.address,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[700]),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Actions
          Row(
            children: [
              Expanded(
                child: CalmButton(
                  text: 'Y Aller',
                  isPrimary: true,
                  onPressed: _launchNavigation,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: CalmButton(
                  text: 'Appeler',
                  isPrimary: false,
                  onPressed: _callCenter,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
