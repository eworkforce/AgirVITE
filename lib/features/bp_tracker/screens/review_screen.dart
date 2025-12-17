import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/colors.dart';
import '../../../core/services/bp_tracker_service.dart';
import '../../dashboard/providers/dashboard_provider.dart';

class ReviewScreen extends ConsumerStatefulWidget {
  final Map<String, int> extractedData;

  const ReviewScreen({super.key, required this.extractedData});

  @override
  ConsumerState<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends ConsumerState<ReviewScreen> {
  late TextEditingController _sysController;
  late TextEditingController _diaController;
  late TextEditingController _pulseController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _sysController = TextEditingController(text: widget.extractedData['systolic']?.toString());
    _diaController = TextEditingController(text: widget.extractedData['diastolic']?.toString());
    _pulseController = TextEditingController(text: widget.extractedData['pulse']?.toString());
  }

  @override
  void dispose() {
    _sysController.dispose();
    _diaController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _saveReading() async {
    if (_formKey.currentState!.validate()) {
      final sys = int.parse(_sysController.text);
      final dia = int.parse(_diaController.text);
      final pulse = int.parse(_pulseController.text);

      await ref.read(bpTrackerServiceProvider).addReading(
        systolic: sys,
        diastolic: dia,
        pulse: pulse,
      );

      // Invalidate the dashboard provider to refresh the data
      ref.invalidate(latestBPProvider);

      if (mounted) {
        context.go('/dashboard'); // Go back to dashboard (or history)
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Mesure enregistrée avec succès'), backgroundColor: AppColors.success),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Valider la mesure')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Text(
                'Vérifiez les valeurs détectées',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 32),
              
              // Systolic
              TextFormField(
                controller: _sysController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Systolique (SYS)',
                  suffixText: 'mmHg',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => (value == null || value.isEmpty) ? 'Requis' : null,
              ),
              const SizedBox(height: 16),
              
              // Diastolic
              TextFormField(
                controller: _diaController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Diastolique (DIA)',
                  suffixText: 'mmHg',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => (value == null || value.isEmpty) ? 'Requis' : null,
              ),
              const SizedBox(height: 16),
              
              // Pulse
              TextFormField(
                controller: _pulseController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Pouls (PUL)',
                  suffixText: 'bpm',
                  border: OutlineInputBorder(),
                ),
              ),
              
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveReading,
                  child: const Text('Enregistrer'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
