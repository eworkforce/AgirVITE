import 'package:flutter/material.dart';
import '../../../app/theme/colors.dart';

class EnUrgenceScreen extends StatelessWidget {
  final VoidCallback onNext;

  const EnUrgenceScreen({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          const Spacer(),
          Text(
            'En Urgence (Time)',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: AppColors.emergency,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          // Placeholder for Animation
          Container(
            height: 250,
            width: double.infinity,
            decoration: BoxDecoration(
                        color: AppColors.emergency.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Center(
              child: Icon(Icons.warning_amber_rounded, size: 80, color: AppColors.emergency),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Si vous observez l\'un de ces signes,\nn\'attendez pas !',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          Text(
            'Appelez immédiatement le SAMU (185).',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onNext,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary, // Or keep primary to return to dashboard
              ),
              child: const Text('Terminer'),
            ),
          ),
        ],
      ),
    );
  }
}
