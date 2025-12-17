import 'package:flutter/material.dart';

class TroubleScreen extends StatelessWidget {
  final VoidCallback onNext;

  const TroubleScreen({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          const Spacer(),
          Text(
            'Trouble de la parole',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 16),
          // Placeholder for Audio/Animation
          Container(
            height: 250,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Center(child: Icon(Icons.volume_up, size: 64)),
          ),
          const SizedBox(height: 24),
          Text(
            'Faites répéter une phrase simple.\nLa voix est-elle bizarre ou les mots incompréhensibles ?',
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
