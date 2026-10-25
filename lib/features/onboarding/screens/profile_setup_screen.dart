import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import '../../../app/theme/colors.dart';
import '../../../core/models/user.dart';
import '../../../core/repositories/user_repository.dart';
import '../../../core/utils/phone_number_formatter.dart';
import '../../shared/widgets/calm_button.dart';
import '../providers/onboarding_provider.dart';
import '../widgets/onboarding_progress_header.dart';
import '../../guardians/models/guardian.dart';
import '../../guardians/repositories/guardians_repository.dart';

class ProfileSetupScreen extends ConsumerStatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  ConsumerState<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends ConsumerState<ProfileSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _contactNameController = TextEditingController();
  final _contactPhoneController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _contactNameController.dispose();
    _contactPhoneController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final name = _nameController.text.trim();
      final user = UserProfile(
        id: const Uuid().v4(),
        displayName: name,
        createdAt: DateTime.now(),
      );

      // Save Profile
      await ref.read(userRepositoryProvider).saveProfile(user);

      // Normalize phone number to E.164 (+225...) so automatic SMS & WhatsApp
      // target the exact recipient without manual selection.
      final normalizedPhone = PhoneNumberFormatter.normalize(
        _contactPhoneController.text.trim(),
        includePlus: true,
      );

      final firstContact = Guardian(
        id: const Uuid().v4(),
        name: _contactNameController.text.trim(),
        phoneNumber: normalizedPhone,
        relation: 'Premier contact',
      );
      await ref.read(guardiansRepositoryProvider).addGuardian(firstContact);

      // Complete Onboarding
      await ref.read(onboardingControllerProvider.notifier).completeOnboarding();

      if (mounted) {
        context.go('/dashboard');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 20),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight - 32,
                ),
                child: IntrinsicHeight(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        OnboardingProgressHeader(
                          currentStep: 3,
                          onBack: () => context.go('/onboarding/reflex'),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          "Faisons connaissance",
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Comment souhaitez-vous être appelé ?",
                          style: Theme.of(context).textTheme.bodyLarge,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 14),
                        TextFormField(
                          controller: _nameController,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            labelText: "Votre Prénom",
                            prefixIcon: const Icon(Icons.person_outline),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Veuillez entrer votre prénom';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),
                        Text(
                          "Ajoutez votre premier contact d'urgence",
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "Ce contact recevra automatiquement un SMS et un message WhatsApp avec votre position GPS en cas d'alerte SOS.",
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppColors.textSecondary,
                              ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 14),
                        TextFormField(
                          controller: _contactNameController,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            labelText: "Nom du contact",
                            prefixIcon: const Icon(Icons.contact_phone_outlined),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Veuillez entrer le nom du contact';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 14),
                        TextFormField(
                          controller: _contactPhoneController,
                          keyboardType: TextInputType.phone,
                          textInputAction: TextInputAction.done,
                          onFieldSubmitted: (_) => _submit(),
                          decoration: InputDecoration(
                            labelText: "Numéro de téléphone (SMS & WhatsApp)",
                            hintText: "Ex: 07 01 02 03 04",
                            prefixIcon: const Icon(Icons.phone_outlined),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Veuillez entrer le numéro du contact';
                            }
                            final digits = PhoneNumberFormatter.normalize(
                              value,
                              includePlus: false,
                            );
                            if (digits.length < 8) {
                              return 'Veuillez entrer un numéro de téléphone valide';
                            }
                            return null;
                          },
                        ),
                        const Spacer(),
                        const SizedBox(height: 20),
                        CalmButton(
                          text: "Terminer",
                          onPressed: _isLoading ? null : _submit,
                          isPrimary: true,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
