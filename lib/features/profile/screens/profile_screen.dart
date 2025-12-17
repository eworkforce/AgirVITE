import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import '../../../app/theme/colors.dart';
import '../../../core/models/user.dart';
import '../providers/profile_provider.dart';
import '../../guardians/models/guardian.dart';
import '../../guardians/repositories/guardians_repository.dart';
import '../../guardians/providers/guardians_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userProfileProvider);
    final guardiansAsync = ref.watch(guardiansListProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Mon Profil'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Info
            userAsync.when(
              data: (UserProfile? user) {
                if (user == null) {
                  return Center(
                    child: Column(
                      children: [
                        const CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.grey,
                          child: Icon(Icons.person_outline, size: 40, color: Colors.white),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          "Profil Incomplet",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        TextButton(
                          onPressed: () => context.go('/onboarding/profile'),
                          child: const Text("Compléter mon profil"),
                        ),
                      ],
                    ),
                  );
                }
                return Center(
                  child: Column(
                    children: [
                      const CircleAvatar(
                        radius: 40,
                        backgroundColor: AppColors.primary,
                        child: Icon(Icons.person, size: 40, color: Colors.white),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        user.displayName,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Text('Erreur: $err'),
            ),
            
            const SizedBox(height: 32),
            
            // Guardians Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Cercle de Vie (Gardiens)",
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                ),
                IconButton(
                  onPressed: () => _showAddGuardianDialog(context, ref),
                  icon: const Icon(Icons.add_circle, color: AppColors.primary, size: 30),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              "Ces personnes recevront une alerte WhatsApp avec votre position en cas d'urgence.",
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
            const SizedBox(height: 16),
            
            guardiansAsync.when(
              data: (guardians) {
                if (guardians.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Text("Aucun gardien ajouté."),
                    ),
                  );
                }
                
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: guardians.length,
                  itemBuilder: (context, index) {
                    final guardian = guardians[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 2,
                      child: ListTile(
                        leading: const CircleAvatar(
                          backgroundColor: AppColors.secondary,
                          child: Icon(Icons.security, color: Colors.white),
                        ),
                        title: Text(guardian.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(guardian.phoneNumber),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline, color: Colors.red),
                          onPressed: () => _confirmDeleteGuardian(context, ref, guardian),
                        ),
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Text('Erreur: $err'),
            ),
            
            const SizedBox(height: 32),
            
            // App Info / Logout (Reset)
            const Divider(),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('À propos de Agir V.I.T.E.'),
              onTap: () {
                // Show license or version
              },
            ),
             ListTile(
              leading: const Icon(Icons.privacy_tip_outlined),
              title: const Text('Confidentialité & Données'),
              onTap: () {
                 // Show privacy policy
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showAddGuardianDialog(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController();
    final phoneController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Ajouter un Gardien"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Nom"),
            ),
            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(labelText: "Téléphone (WhatsApp)"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Annuler"),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty && phoneController.text.isNotEmpty) {
                final guardian = Guardian(
                  id: const Uuid().v4(),
                  name: nameController.text.trim(),
                  phoneNumber: phoneController.text.trim(),
                  relation: "Contact",
                );
                ref.read(guardiansRepositoryProvider).addGuardian(guardian);
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            child: const Text("Ajouter", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteGuardian(BuildContext context, WidgetRef ref, Guardian guardian) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Supprimer ?"),
        content: Text("Voulez-vous retirer ${guardian.name} de votre cercle de vie ?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Non"),
          ),
          TextButton(
            onPressed: () {
              ref.read(guardiansRepositoryProvider).removeGuardian(guardian.id);
              Navigator.pop(context);
            },
            child: const Text("Oui, supprimer", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
