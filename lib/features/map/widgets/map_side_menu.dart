import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../../../app/theme/colors.dart';
import '../../../core/models/stroke_center.dart';

/// Pulsing user location marker for the stroke centers map.
class UserLocationMarker extends StatefulWidget {
  const UserLocationMarker({super.key});

  @override
  State<UserLocationMarker> createState() => _UserLocationMarkerState();
}

class _UserLocationMarkerState extends State<UserLocationMarker>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 60 * _controller.value,
              height: 60 * _controller.value,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withValues(alpha: 0.3 * (1 - _controller.value)),
              ),
            ),
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary,
                border: Border.all(color: Colors.white, width: 2),
              ),
            ),
          ],
        );
      },
    );
  }
}

/// Slide-out drawer listing stroke centers sorted by distance.
class MapSideMenu extends StatelessWidget {
  final List<StrokeCenter> centers;
  final StrokeCenter? selectedCenter;
  final Position? currentPosition;
  final ValueChanged<StrokeCenter> onSelect;
  final VoidCallback onClose;

  const MapSideMenu({
    super.key,
    required this.centers,
    required this.selectedCenter,
    required this.currentPosition,
    required this.onSelect,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final sortedCenters = List<StrokeCenter>.from(centers);
    if (currentPosition != null) {
      sortedCenters.sort((a, b) {
        final distA = Geolocator.distanceBetween(
          currentPosition!.latitude,
          currentPosition!.longitude,
          a.latitude,
          a.longitude,
        );
        final distB = Geolocator.distanceBetween(
          currentPosition!.latitude,
          currentPosition!.longitude,
          b.latitude,
          b.longitude,
        );
        return distA.compareTo(distB);
      });
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(16, 50, 8, 16),
            color: AppColors.primary,
            child: Row(
              children: [
                Image.asset(
                  'assets/images/logo_avc_espoir.png',
                  height: 30,
                  width: 30,
                  fit: BoxFit.contain,
                ),
                const SizedBox(width: 8),
                const Icon(Icons.local_hospital, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'Centres AVC',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: onClose,
                ),
              ],
            ),
          ),
          if (currentPosition != null && sortedCenters.isNotEmpty)
            Builder(
              builder: (context) {
                final closest = sortedCenters.first;
                return Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.1),
                    border: Border.all(color: AppColors.success),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.recommend, color: AppColors.success),
                          SizedBox(width: 8),
                          Text(
                            "Recommandé",
                            style: TextStyle(
                              color: AppColors.success,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      const Text("Le centre le plus proche est :"),
                      const SizedBox(height: 4),
                      Text(
                        closest.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Tél : ${closest.phone}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.success,
                            foregroundColor: Colors.white,
                            elevation: 0,
                          ),
                          onPressed: () => onSelect(closest),
                          child: const Text("Voir"),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.zero,
              itemCount: sortedCenters.length,
              separatorBuilder: (_, _) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final center = sortedCenters[index];
                final isSelected = center == selectedCenter;
                final isClosest = index == 0 && currentPosition != null;

                String? distanceText;
                if (currentPosition != null) {
                  final dist = Geolocator.distanceBetween(
                    currentPosition!.latitude,
                    currentPosition!.longitude,
                    center.latitude,
                    center.longitude,
                  );
                  distanceText = "${(dist / 1000).toStringAsFixed(1)} km";
                }

                final serviceLine = center.address.split('•').first.trim();

                return ListTile(
                  tileColor: isClosest
                      ? Colors.green.withValues(alpha: 0.1)
                      : (isSelected ? AppColors.primary.withValues(alpha: 0.1) : null),
                  leading: Icon(
                    Icons.location_on,
                    color: isClosest
                        ? Colors.green
                        : (isSelected ? AppColors.primary : Colors.grey),
                  ),
                  title: Text(
                    center.name,
                    style: TextStyle(
                      fontWeight: isSelected || isClosest
                          ? FontWeight.bold
                          : FontWeight.normal,
                      fontSize: 14,
                      color: isClosest ? Colors.green.shade800 : Colors.black87,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$serviceLine : ${center.phone}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      if (distanceText != null)
                        Text(
                          "$distanceText${isClosest ? ' (Le plus proche)' : ''}",
                          style: TextStyle(
                            fontSize: 11.5,
                            color: isClosest ? Colors.green : Colors.black54,
                            fontWeight: isClosest
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                    ],
                  ),
                  onTap: () => onSelect(center),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
