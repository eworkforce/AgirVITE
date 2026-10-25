import 'package:flutter/material.dart';
import '../../../app/theme/colors.dart';
import '../../../core/models/stroke_center.dart';

/// Renders a stroke center marker pin and distance badge on the map.
class CenterMapMarker extends StatelessWidget {
  final StrokeCenter center;
  final String distKm;
  final bool isSelected;
  final bool isClosest;
  final VoidCallback onTap;

  const CenterMapMarker({
    super.key,
    required this.center,
    required this.distKm,
    required this.isSelected,
    required this.isClosest,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
            decoration: BoxDecoration(
              color: isClosest ? Colors.green.shade50 : Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isClosest
                    ? Colors.green
                    : (isSelected ? AppColors.primary : Colors.grey.shade300),
                width: isClosest || isSelected ? 2 : 1,
              ),
              boxShadow: const [
                BoxShadow(blurRadius: 2, color: Colors.black12),
              ],
            ),
            child: Column(
              children: [
                Text(
                  center.name,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: isClosest ? Colors.green.shade800 : Colors.black87,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  "$distKm km${isClosest ? ' (Proche)' : ''}",
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: isClosest ? FontWeight.w900 : FontWeight.normal,
                    color: isClosest ? Colors.green : Colors.black54,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 2),
          Icon(
            Icons.location_on,
            color: isClosest
                ? Colors.green
                : (isSelected ? AppColors.primary : Colors.red),
            size: isSelected || isClosest ? 35 : 30,
          ),
        ],
      ),
    );
  }
}
