import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/emergency/widgets/sos_button.dart';

class MainShell extends StatelessWidget {
  final Widget child;

  const MainShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    // Determine the current index based on the route
    final String location = GoRouterState.of(context).uri.path;
    int currentIndex = 0; // Default to Dashboard
    
    if (location.startsWith('/bp-tracker')) {
      currentIndex = 1;
    } else if (location.startsWith('/map')) {
      currentIndex = 2;
    } else if (location.startsWith('/vite-guide')) {
      currentIndex = 3;
    } else if (location.startsWith('/stories')) {
      currentIndex = 4;
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
              // Left side
              _buildNavItem(
                context,
                icon: Icons.favorite_border,
                label: 'Tension',
                isSelected: currentIndex == 1,
                onTap: () => context.go('/bp-tracker'),
              ),
              _buildNavItem(
                context,
                icon: Icons.local_hospital_outlined,
                label: 'Centres',
                isSelected: currentIndex == 2,
                onTap: () => context.go('/map'),
              ),
              
              const SizedBox(width: 48.0), // Space for the docked FAB
              
              // Right side
              _buildNavItem(
                context,
                icon: Icons.menu_book_outlined,
                label: 'Guide',
                isSelected: currentIndex == 3,
                onTap: () => context.go('/vite-guide'),
              ),
              _buildNavItem(
                context,
                icon: Icons.article_outlined,
                label: 'Conseils',
                isSelected: currentIndex == 4,
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
    );
  }
}
