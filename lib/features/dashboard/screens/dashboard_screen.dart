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
                          'Reconnaître les signes d\'un AVC',
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
              
              // Action Grid (V.I.T.E.)
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.95,
                  padding: const EdgeInsets.only(bottom: 24),
                  children: [
                    _ViteCard(
                      letter: 'V',
                      title: 'Visage\nParalysé',
                      color: AppColors.secondary,
                      icon: Icons.face,
                      onTap: () => _goToViteTab(context, 0),
                    ),
                    _ViteCard(
                      letter: 'I',
                      title: 'Incapacité\nMembre faible',
                      color: AppColors.primary, // Switched to primary since accentBlue doesn't exist
                      icon: Icons.accessible_forward,
                      onTap: () => _goToViteTab(context, 1),
                    ),
                    _ViteCard(
                      letter: 'T',
                      title: 'Trouble\nde la parole',
                      color: AppColors.warning, // Switched to warning since tertiary doesn't exist
                      icon: Icons.record_voice_over,
                      onTap: () => _goToViteTab(context, 2),
                    ),
                    _ViteCard(
                      letter: 'E',
                      title: 'En Urgence\nAgir vite!',
                      color: AppColors.emergency, // Switched to emergency since error doesn't exist
                      icon: Icons.timer,
                      onTap: () => _goToViteTab(context, 3),
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

  void _goToViteTab(BuildContext context, int index) {
    context.push('/vite-guide', extra: index); 
  }
}

class _ViteCard extends StatelessWidget {
  final String letter;
  final String title;
  final Color color;
  final IconData icon;
  final VoidCallback onTap;

  const _ViteCard({
    required this.letter,
    required this.title,
    required this.color,
    required this.icon,
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
          border: Border.all(color: color.withValues(alpha: 0.3), width: 2),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  letter,
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w900,
                    height: 1.0,
                  ),
                ),
                Icon(icon, color: color.withValues(alpha: 0.6), size: 32),
              ],
            ),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
