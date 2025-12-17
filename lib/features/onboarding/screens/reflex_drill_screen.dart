import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/colors.dart';

class ReflexDrillScreen extends ConsumerStatefulWidget {
  const ReflexDrillScreen({super.key});

  @override
  ConsumerState<ReflexDrillScreen> createState() => _ReflexDrillScreenState();
}

class _ReflexDrillScreenState extends ConsumerState<ReflexDrillScreen> {
  Timer? _timer;
  double _progress = 0.0;
  bool _isComplete = false;
  static const int _requiredDurationMs = 2000;
  static const int _updateIntervalMs = 50;

  void _startPress() {
    if (_isComplete) return;
    _timer = Timer.periodic(const Duration(milliseconds: _updateIntervalMs), (timer) {
      setState(() {
        _progress += _updateIntervalMs / _requiredDurationMs;
        if (_progress >= 1.0) {
          _completeDrill();
        }
      });
    });
  }

  void _cancelPress() {
    if (_isComplete) return;
    _timer?.cancel();
    setState(() {
      _progress = 0.0;
    });
  }

  Future<void> _completeDrill() async {
    _timer?.cancel();
    _isComplete = true;
    _progress = 1.0;
    
    // Haptic feedback
    HapticFeedback.heavyImpact();
    
    if (mounted) {
      // Navigate to Profile Setup
      context.go('/onboarding/profile');
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Text(
                "Le Réflexe V.I.T.E.",
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 16),
              Text(
                "En cas d'urgence, maintenez le bouton appuyé pendant 2 secondes.",
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              
              // SOS Button Simulation
              GestureDetector(
                onTapDown: (_) => _startPress(),
                onTapUp: (_) => _cancelPress(),
                onTapCancel: _cancelPress,
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.emergency,
                    boxShadow: [
                      BoxShadow(
                  color: AppColors.emergency.withValues(alpha: 0.3),
                        blurRadius: 20,
                        spreadRadius: 5,
                        offset: const Offset(0, 10),
                      )
                    ],
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Progress Circle
                      SizedBox(
                        width: 180,
                        height: 180,
                        child: CircularProgressIndicator(
                          value: _progress,
                          color: Colors.white,
                          backgroundColor: Colors.white24,
                          strokeWidth: 8,
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.touch_app, color: Colors.white, size: 48),
                          const SizedBox(height: 8),
                          Text(
                            "SOS",
                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              
              const Spacer(),
              // Disable "skip" behavior implicitly by not providing another button
              Text(
                "Appuyez longuement pour terminer",
                style: Theme.of(context).textTheme.labelSmall,
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
