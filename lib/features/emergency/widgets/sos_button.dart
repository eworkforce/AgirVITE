import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/theme/colors.dart';
import '../../../core/services/emergency_service.dart';
import '../../guardians/providers/guardians_provider.dart';

class SOSButton extends ConsumerStatefulWidget {
  const SOSButton({super.key});

  @override
  ConsumerState<SOSButton> createState() => _SOSButtonState();
}

class _SOSButtonState extends ConsumerState<SOSButton> with SingleTickerProviderStateMixin {
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
    
    // Trigger Service
    final guardiansAsync = ref.read(guardiansListProvider);
    final numbers = guardiansAsync.valueOrNull?.map((g) => g.phoneNumber).toList() ?? [];
    
    ref.read(emergencyServiceProvider).callSAMU();
    ref.read(emergencyServiceProvider).sendWhatsAppAlert(numbers);
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Appel d\'urgence déclenché !'),
        backgroundColor: AppColors.emergency,
        duration: Duration(seconds: 5),
      ),
    );
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
                  blurRadius: 10 + (_controller.value * 10),
                  spreadRadius: 2 + (_controller.value * 5),
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
