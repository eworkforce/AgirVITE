import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/emergency/widgets/sos_button.dart';

class MainShell extends StatelessWidget {
  final Widget child;

  const MainShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final String location = GoRouterState.of(context).uri.path;
    int currentIndex = 0;

    if (location.startsWith('/dashboard')) {
      currentIndex = 0;
    } else if (location.startsWith('/map')) {
      currentIndex = 1;
    } else if (location.startsWith('/vite-guide')) {
      currentIndex = 2;
    } else if (location.startsWith('/stories')) {
      currentIndex = 3;
    } else {
      currentIndex = -1;
    }

    return Scaffold(
      body: child,
      // The docked SOS Button
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: const SOSButton(),
      // The notched BottomAppBar
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        color: Theme.of(context).colorScheme.surface,
        elevation: 8,
        child: SizedBox(
          height: 60.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              // Left side: Accueil & Centres
              _buildNavItem(
                context,
                icon: currentIndex == 0 ? Icons.home : Icons.home_outlined,
                label: 'Accueil',
                isSelected: currentIndex == 0,
                onTap: () => context.go('/dashboard'),
              ),
              _buildNavItem(
                context,
                icon: Icons.local_hospital_outlined,
                label: 'Centres',
                isSelected: currentIndex == 1,
                onTap: () => context.go('/map'),
              ),

              const SizedBox(width: 48.0), // Space for the docked FAB

              // Right side: Guide & Conseils
              _buildNavItem(
                context,
                icon: Icons.menu_book_outlined,
                label: 'Guide',
                isSelected: currentIndex == 2,
                onTap: () => context.go('/vite-guide'),
              ),
              _buildNavItem(
                context,
                icon: Icons.article_outlined,
                label: 'Conseils',
                isSelected: currentIndex == 3,
                onTap: () => context.go('/stories'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final color = isSelected
        ? theme.colorScheme.primary
        : theme.colorScheme.onSurface.withValues(alpha: 0.6);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 4),
            Text(
              label,
              style: theme.textTheme.labelSmall?.copyWith(
                color: color,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
