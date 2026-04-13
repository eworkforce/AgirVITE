import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/colors.dart';
import '../../profile/providers/profile_provider.dart';
import '../widgets/bp_status_card.dart';
import '../../emergency/widgets/sos_button.dart';

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
      floatingActionButton: const SOSButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Logo
                  Image.asset(
                    'assets/images/logo_avc_espoir.png',
                    height: 40,
                    width: 40,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          firstName.isNotEmpty ? 'Bonjour, $firstName' : 'Bonjour,',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        Text(
                          'Votre santé, notre priorité',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => context.push('/profile'),
                    icon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.secondary.withValues(alpha: 0.3),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.person, color: AppColors.primary),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              
              // Status Card
              const BPStatusCard(),
              
              const SizedBox(height: 16),
              
              // Action Grid
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.95,
                  padding: const EdgeInsets.only(bottom: 100), // Increased padding to avoid SOS overlap
                  children: [
                    _ActionCard(
                      icon: Icons.camera_alt,
                      title: 'Prendre ma\ntension',
                      imagePath: 'assets/images/PriseTension2.jpeg',
                      onTap: () => context.push('/bp-tracker/capture'),
                    ),
                    _ActionCard(
                      icon: Icons.menu_book,
                      title: 'Guide\nV.I.T.E.',
                      imagePath: 'assets/images/GuideVite3.jpeg',
                      onTap: () => context.push('/vite-guide'),
                    ),
                    _ActionCard(
                      icon: Icons.local_hospital,
                      title: 'Centre de\nPrise en Charge',
                      imagePath: 'assets/images/Centre1.jpeg',
                      onTap: () => context.push('/map'),
                    ),
                    _ActionCard(
                      icon: Icons.article,
                      title: 'News et\nConseils',
                      imagePath: 'assets/images/Blog1.jpeg',
                      onTap: () => context.push('/stories'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String imagePath;
  final VoidCallback onTap;

  const _ActionCard({
    required this.icon,
    required this.title,
    required this.imagePath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Background Image (without ColorFiltered)
            Image.asset(
              imagePath,
              fit: BoxFit.cover,
            ),
            
            // Gradient Overlay for Readability (Scrim)
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.center,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.0),
                    Colors.black.withValues(alpha: 0.8),
                  ],
                ),
              ),
            ),
            
            // Icon at Top Right
            Positioned(
              top: 12,
              right: 12,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.4), // Dark translucent background for contrast
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    )
                  ],
                ),
                child: Icon(icon, size: 24, color: Colors.white),
              ),
            ),
            
            // Content at Bottom Left
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: Text(
                title,
                textAlign: TextAlign.left,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    const Shadow(
                      offset: Offset(0, 1),
                      blurRadius: 4.0,
                      color: Colors.black54,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
