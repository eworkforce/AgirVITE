import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/colors.dart';
import 'visage_screen.dart';
import 'incapacite_screen.dart';
import 'trouble_screen.dart';
import 'en_urgence_screen.dart';

class ViteGuideScreen extends ConsumerStatefulWidget {
  final int initialIndex;
  const ViteGuideScreen({super.key, this.initialIndex = 0});

  @override
  ConsumerState<ViteGuideScreen> createState() => _ViteGuideScreenState();
}

class _ViteGuideScreenState extends ConsumerState<ViteGuideScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 4,
      vsync: this,
      initialIndex: widget.initialIndex.clamp(0, 3),
    );
  }

  @override
  void didUpdateWidget(covariant ViteGuideScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialIndex != oldWidget.initialIndex) {
      _tabController.animateTo(widget.initialIndex.clamp(0, 3));
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_tabController.index < 3) {
      _tabController.animateTo(_tabController.index + 1);
    } else if (context.canPop()) {
      context.pop();
    } else {
      context.go('/dashboard');
    }
  }

  void _jumpToUrgenceTab() {
    _tabController.animateTo(3);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.home, color: AppColors.primary),
          onPressed: () => context.go('/dashboard'),
        ),
        title: Row(
          children: [
            Image.asset(
              'assets/images/logo_avc_espoir.png',
              height: 30,
              width: 30,
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 12),
            const Text('Guide V.I.T.E.'),
          ],
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.primary,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSecondary,
          tabs: const [
            Tab(text: 'V'),
            Tab(text: 'I'),
            Tab(text: 'T'),
            Tab(text: 'E'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          VisageScreen(
            onNext: _nextPage,
            onJumpToUrgence: _jumpToUrgenceTab,
          ),
          IncapaciteScreen(
            onNext: _nextPage,
            onJumpToUrgence: _jumpToUrgenceTab,
          ),
          TroubleScreen(
            onNext: _nextPage,
            onJumpToUrgence: _jumpToUrgenceTab,
          ),
          EnUrgenceScreen(onNext: _nextPage),
        ],
      ),
    );
  }
}
