import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import '../../../app/theme/colors.dart';
import '../../../core/models/user.dart';
import '../../../core/utils/phone_number_formatter.dart';
import '../providers/profile_provider.dart';
import '../../guardians/models/guardian.dart';
import '../../guardians/repositories/guardians_repository.dart';
import '../../guardians/providers/guardians_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userProfileProvider);
    final contactsAsync = ref.watch(guardiansListProvider);

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

            // Emergency Contacts Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    "Mes contacts en cas d'urgence",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                  ),
                ),
                IconButton(
                  onPressed: () => _showAddContactDialog(context, ref),
                  icon: const Icon(Icons.add_circle, color: AppColors.primary, size: 30),
                  tooltip: 'Ajouter un contact',
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              "Votre premier contact reçoit automatiquement un SMS en arrière-plan et un message WhatsApp avec votre position GPS en cas d'urgence.",
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
            const SizedBox(height: 16),

            contactsAsync.when(
              data: (contacts) {
                if (contacts.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Text("Aucun contact ajouté."),
                    ),
                  );
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: contacts.length,
                  itemBuilder: (context, index) {
                    final contact = contacts[index];
                    final isPrimary = index == 0;
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 2,
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: isPrimary ? AppColors.primary : AppColors.secondary,
                          child: Icon(
                            isPrimary ? Icons.star_rounded : Icons.contact_phone_rounded,
                            color: Colors.white,
                          ),
                        ),
                        title: Text(
                          contact.name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(contact.phoneNumber),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline, color: Colors.red),
                          onPressed: () => _confirmDeleteContact(context, ref, contact),
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

            // App Info
            const Divider(),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('À propos de Agir V.I.T.E.'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.privacy_tip_outlined),
              title: const Text('Confidentialité & Données'),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }

  void _showAddContactDialog(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController();
    final phoneController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Ajouter un contact"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Nom du contact"),
            ),
            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: "Téléphone (SMS & WhatsApp)",
                hintText: "Ex: 07 01 02 03 04",
              ),
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
              if (nameController.text.trim().isNotEmpty &&
                  phoneController.text.trim().isNotEmpty) {
                final normalizedPhone = PhoneNumberFormatter.normalize(
                  phoneController.text.trim(),
                  includePlus: true,
                );
                final contact = Guardian(
                  id: const Uuid().v4(),
                  name: nameController.text.trim(),
                  phoneNumber: normalizedPhone,
                  relation: "Contact d'urgence",
                );
                ref.read(guardiansRepositoryProvider).addGuardian(contact);
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

  void _confirmDeleteContact(BuildContext context, WidgetRef ref, Guardian contact) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Supprimer ?"),
        content: Text("Voulez-vous retirer ${contact.name} de vos contacts d'urgence ?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Non"),
          ),
          TextButton(
            onPressed: () {
              ref.read(guardiansRepositoryProvider).removeGuardian(contact.id);
              Navigator.pop(context);
            },
            child: const Text("Oui, supprimer", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
