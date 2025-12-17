import 'package:flutter/material.dart';

class IncapaciteScreen extends StatelessWidget {
  final VoidCallback onNext;

  const IncapaciteScreen({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          const Spacer(),
          Text(
            'Incapacité (Arm)',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 16),
          // Placeholder for Rive Animation
          Container(
            height: 250,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Center(child: Text('Animation: Bras qui tombe')),
          ),
          const SizedBox(height: 24),
          Text(
            'Demandez à la personne de lever les deux bras.\nUn bras retombe-t-il ?',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onNext,
              child: const Text('Suivant'),
            ),
          ),
        ],
      ),
    );
  }
}
