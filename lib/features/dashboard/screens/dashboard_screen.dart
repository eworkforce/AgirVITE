import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/colors.dart';
import '../../emergency/widgets/sos_button.dart';
import '../providers/dashboard_provider.dart';
import '../../../core/services/bp_tracker_service.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final latestReadingAsync = ref.watch(latestBPProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Bonjour,',
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                            Text(
                              'Votre santé, notre priorité',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => context.push('/profile'),
                        icon: const CircleAvatar(
                          backgroundColor: AppColors.primary,
                          child: Icon(Icons.person, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  
                  // Status Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: latestReadingAsync.when(
                          data: (reading) {
                            if (reading == null) return Colors.grey;
                            final service = ref.read(bpTrackerServiceProvider);
                            final status = service.getStatus(reading.systolic, reading.diastolic);
                            return status.contains('Hypertension') ? AppColors.emergency : AppColors.success;
                          },
                          error: (error, stack) => Colors.grey,
                          loading: () => Colors.grey,
                        ),
                        width: 2,
                      ),
                    ),
                    child: latestReadingAsync.when(
                      data: (reading) {
                        if (reading == null) {
                          return Column(
                            children: [
                              Text('STATUT ACTUEL', style: Theme.of(context).textTheme.labelSmall),
                              const SizedBox(height: 8),
                              Text('--/--', style: Theme.of(context).textTheme.displayMedium),
                              const Text('Pas encore de mesure'),
                            ],
                          );
                        }
                        final service = ref.read(bpTrackerServiceProvider);
                        final status = service.getStatus(reading.systolic, reading.diastolic);
                        return Column(
                          children: [
                            Text('STATUT ACTUEL', style: Theme.of(context).textTheme.labelSmall),
                            const SizedBox(height: 8),
                            Text(
                              '${reading.systolic}/${reading.diastolic}',
                              style: Theme.of(context).textTheme.displayMedium,
                            ),
                            Text(
                              status,
                              style: TextStyle(
                                color: status.contains('Hypertension') 
                                    ? AppColors.emergency 
                                    : AppColors.success,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        );
                      },
                      loading: () => const Center(child: CircularProgressIndicator()),
                      error: (err, stack) => Text('Erreur: $err'),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Action Grid
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      children: [
                        _ActionCard(
                          icon: Icons.camera_alt,
                          title: 'Prendre ma\ntension',
                          onTap: () => context.push('/bp-tracker/capture'),
                        ),
                        _ActionCard(
                          icon: Icons.menu_book,
                          title: 'Guide\nV.I.T.E.',
                          onTap: () => context.push('/vite-guide'),
                        ),
                        _ActionCard(
                          icon: Icons.local_hospital,
                          title: 'Centres\nAVC',
                          onTap: () => context.push('/map'),
                        ),
                        _ActionCard(
                          icon: Icons.play_circle_fill,
                          title: 'Histoires\n(Vidéos)',
                          onTap: () => context.push('/stories'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Floating SOS Button
            const Positioned(
              bottom: 24,
              left: 0,
              right: 0,
              child: Center(child: SOSButton()),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _ActionCard({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 5,
              offset: Offset(0, 2),
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: AppColors.primary),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
