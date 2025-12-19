import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/colors.dart';
import 'visage_screen.dart';
import 'incapacite_screen.dart';
import 'trouble_screen.dart';
import 'en_urgence_screen.dart';

class ViteGuideScreen extends ConsumerStatefulWidget {
  const ViteGuideScreen({super.key});

  @override
  ConsumerState<ViteGuideScreen> createState() => _ViteGuideScreenState();
}

class _ViteGuideScreenState extends ConsumerState<ViteGuideScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_tabController.index < 3) {
      _tabController.animateTo(_tabController.index + 1);
    } else {
      context.pop(); // Return to dashboard
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
          VisageScreen(onNext: _nextPage),
          IncapaciteScreen(onNext: _nextPage),
          TroubleScreen(onNext: _nextPage),
          EnUrgenceScreen(onNext: _nextPage),
        ],
      ),
    );
  }
}
