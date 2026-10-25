import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/colors.dart';

/// Incremented each time the user completes the 2-second SOS hold gesture,
/// allowing [MapScreen] to react even when already visible.
final emergencyTriggerProvider = StateProvider<int>((ref) => 0);

class SOSButton extends ConsumerStatefulWidget {
  const SOSButton({super.key});

  @override
  ConsumerState<SOSButton> createState() => _SOSButtonState();
}

class _SOSButtonState extends ConsumerState<SOSButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2), // 2 seconds long press
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _triggerEmergency();
      }
    });
  }

  void _triggerEmergency() {
    setState(() => _isPressed = false);
    _controller.reset();
    HapticFeedback.heavyImpact();

    // Increment trigger state and navigate directly to the Map in emergency mode.
    // MapScreen zooms onto the closest stroke center, automatically initiates
    // the phone call to that center, and sends the background SMS + WhatsApp
    // alert to the First Contact in parallel.
    ref.read(emergencyTriggerProvider.notifier).state++;
    context.go('/map?emergency=true');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() => _isPressed = true);
        _controller.forward();
      },
      onTapUp: (_) {
        if (_controller.status != AnimationStatus.completed) {
          setState(() => _isPressed = false);
          _controller.reset();
        }
      },
      onTapCancel: () {
        setState(() => _isPressed = false);
        _controller.reset();
      },
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.emergency,
              boxShadow: [
                BoxShadow(
                  color: AppColors.emergency.withValues(alpha: 0.4),
                  blurRadius: 15 + (_controller.value * 15),
                  spreadRadius: 4 + (_controller.value * 6),
                ),
                BoxShadow(
                  color: AppColors.emergency.withValues(alpha: 0.2),
                  blurRadius: 25,
                  spreadRadius: 8,
                )
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                if (_isPressed)
                  SizedBox(
                    width: 70,
                    height: 70,
                    child: CircularProgressIndicator(
                      value: _controller.value,
                      color: Colors.white,
                      strokeWidth: 4,
                    ),
                  ),
                const Center(
                  child: Text(
                    'SOS',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
