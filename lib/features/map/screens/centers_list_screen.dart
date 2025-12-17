import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:geolocator/geolocator.dart';
import '../../../app/theme/colors.dart';
import '../../../core/models/stroke_center.dart';
import '../../../core/repositories/stroke_centers_repository.dart';
import '../../../core/services/location_service.dart';

final sortedCentersProvider = FutureProvider<List<StrokeCenter>>((ref) async {
  final centers = await ref.watch(strokeCentersProvider.future);
  final locationService = LocationService(); // Or inject via provider
  
  try {
    final position = await locationService.getCurrentLocation();
    final repo = StrokeCentersRepository();
    return repo.sortByDistance(centers, position);
  } catch (e) {
    // Return unsorted if location fails (offline or permission denied)
    return centers;
  }
});

class CentersListScreen extends ConsumerWidget {
  const CentersListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final centersAsync = ref.watch(sortedCentersProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Centres AVC')),
      body: centersAsync.when(
        data: (centers) => ListView.builder(
          itemCount: centers.length,
          padding: const EdgeInsets.all(16),
          itemBuilder: (context, index) {
            final center = centers[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 16),
              elevation: 2,
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: center.hasCTScanner ? AppColors.success : AppColors.warning,
                  child: const Icon(Icons.local_hospital, color: Colors.white),
                ),
                title: Text(center.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(center.address),
                    if (center.hasCTScanner)
                      const Text(
                        'Scanner CT Disponible',
                        style: TextStyle(color: AppColors.success, fontSize: 12),
                      ),
                  ],
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.directions, color: AppColors.primary),
                  onPressed: () async {
                    // Open Google Maps
                    final uri = Uri.parse("https://www.google.com/maps/search/?api=1&query=${center.latitude},${center.longitude}");
                    if (await canLaunchUrl(uri)) {
                      await launchUrl(uri, mode: LaunchMode.externalApplication);
                    }
                  },
                ),
                onTap: () async {
                   // Call functionality
                   final uri = Uri(scheme: 'tel', path: center.phone);
                   if (await canLaunchUrl(uri)) await launchUrl(uri);
                },
              ),
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Erreur: $err')),
      ),
    );
  }
}
