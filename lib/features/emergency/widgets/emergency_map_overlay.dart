import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import '../../../app/theme/colors.dart';
import '../../../core/models/stroke_center.dart';
import '../../../core/services/emergency_service.dart';
import '../../guardians/models/guardian.dart';
import '../../guardians/providers/guardians_provider.dart';
import '../../profile/providers/profile_provider.dart';
import 'external_action_confirm_dialog.dart';

export 'external_action_confirm_dialog.dart';

/// Overlay card displayed on the Map when an emergency SOS is triggered.
///
/// Orchestrates the parallel emergency workflow:
/// 1. Map is zoomed onto [closestCenter].
/// 2. Headless background SMS is sent automatically to the First Contact.
/// 3. Phone call to [closestCenter] is launched automatically.
/// 4. Pre-addressed WhatsApp message to the First Contact is triggered / available in 1 tap.
class EmergencyMapOverlay extends ConsumerStatefulWidget {
  final StrokeCenter closestCenter;
  final Position? currentPosition;
  final VoidCallback onClose;

  const EmergencyMapOverlay({
    super.key,
    required this.closestCenter,
    required this.currentPosition,
    required this.onClose,
  });

  @override
  ConsumerState<EmergencyMapOverlay> createState() =>
      _EmergencyMapOverlayState();
}

class _EmergencyMapOverlayState extends ConsumerState<EmergencyMapOverlay> {
  bool _smsSent = false;
  bool _smsSending = false;
  bool _callLaunched = false;
  bool _whatsappLaunched = false;
  bool _hasDispatched = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _executeParallelEmergencyWorkflow();
    });
  }

  Future<void> _executeParallelEmergencyWorkflow() async {
    if (_hasDispatched || !mounted) return;
    _hasDispatched = true;

    final emergencyService = ref.read(emergencyServiceProvider);
    final user = await ref.read(userProfileProvider.future);
    final contacts = await ref.read(guardiansListProvider.future);
    final Guardian? firstContact = contacts.isNotEmpty ? contacts.first : null;

    final message = await emergencyService.buildEmergencyMessage(
      userName: user?.displayName,
      contactName: firstContact?.name,
      closestCenter: widget.closestCenter,
      knownPosition: widget.currentPosition,
    );

    // 1. In parallel: Send headless background SMS to the First Contact
    if (firstContact != null) {
      if (mounted) setState(() => _smsSending = true);
      unawaited(
        emergencyService
            .sendHeadlessSms(
              firstContact.phoneNumber,
              message: message,
              userName: user?.displayName,
              closestCenter: widget.closestCenter,
              knownPosition: widget.currentPosition,
            )
            .then((sent) {
          if (mounted) {
            setState(() {
              _smsSending = false;
              _smsSent = sent;
            });
          }
        }),
      );
    }

    // 2. Automatically open the phone call with the closest stroke center
    if (mounted) setState(() => _callLaunched = true);
    await emergencyService.callCenter(widget.closestCenter.phone);

    // 3. In parallel: Send pre-addressed WhatsApp message to the First Contact
    if (firstContact != null && mounted) {
      setState(() => _whatsappLaunched = true);
      await emergencyService.sendWhatsAppAlert(
        [firstContact.phoneNumber],
        prebuiltMessage: message,
        userName: user?.displayName,
        closestCenter: widget.closestCenter,
        knownPosition: widget.currentPosition,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final contactsAsync = ref.watch(guardiansListProvider);
    final contacts = contactsAsync.valueOrNull ?? [];
    final Guardian? firstContact = contacts.isNotEmpty ? contacts.first : null;

    final distanceKm = widget.currentPosition != null
        ? (Geolocator.distanceBetween(
                  widget.currentPosition!.latitude,
                  widget.currentPosition!.longitude,
                  widget.closestCenter.latitude,
                  widget.closestCenter.longitude,
                ) /
                1000)
            .toStringAsFixed(1)
        : null;

    return Container(
      key: const Key('emergency_map_overlay'),
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 108),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.emergency, width: 2),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 16,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.emergency.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.emergency_rounded,
                  color: AppColors.emergency,
                  size: 22,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'URGENCE SOS — CENTRE LE PLUS PROCHE',
                      style: TextStyle(
                        color: AppColors.emergency,
                        fontWeight: FontWeight.w800,
                        fontSize: 11,
                        letterSpacing: 0.5,
                      ),
                    ),
                    Text(
                      widget.closestCenter.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              IconButton(
                key: const Key('close_emergency_overlay_button'),
                onPressed: widget.onClose,
                icon: const Icon(Icons.close, size: 20),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '${widget.closestCenter.address}${distanceKm != null ? ' • $distanceKm km' : ''} • Tél: ${widget.closestCenter.phone}',
            style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Icon(
                  _smsSent
                      ? Icons.check_circle_rounded
                      : (_smsSending
                          ? Icons.sync_rounded
                          : Icons.contact_phone_rounded),
                  size: 18,
                  color: _smsSent ? AppColors.success : AppColors.primary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    firstContact != null
                        ? (_smsSent
                            ? 'SMS envoyé en arrière-plan à ${firstContact.name} (${firstContact.phoneNumber})'
                            : 'Alerte Premier contact : ${firstContact.name} (${firstContact.phoneNumber})')
                        : 'Aucun premier contact configuré dans votre profil.',
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  key: const Key('emergency_call_center_button'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.emergency,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                  onPressed: () async {
                    final confirmed = await showExternalActionConfirmOverlay(
                      context: context,
                      title: 'Appeler ${widget.closestCenter.name} ?',
                      subtitle:
                          'Lancer l\'appel d\'urgence vers le ${widget.closestCenter.phone}',
                      confirmLabel: 'Appeler',
                      icon: Icons.phone_in_talk_rounded,
                    );
                    if (confirmed && mounted) {
                      setState(() => _callLaunched = true);
                      await ref
                          .read(emergencyServiceProvider)
                          .callCenter(widget.closestCenter.phone);
                    }
                  },
                  icon: const Icon(Icons.phone_in_talk_rounded, size: 18),
                  label: Text(
                    _callLaunched ? 'Rappeler Centre' : 'Appeler Centre',
                    style: const TextStyle(fontSize: 13),
                  ),
                ),
              ),
              if (firstContact != null) ...[
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    key: const Key('emergency_whatsapp_contact_button'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.success,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                    onPressed: () async {
                      final confirmed = await showExternalActionConfirmOverlay(
                        context: context,
                        title: 'WhatsApp à ${firstContact.name} ?',
                        subtitle:
                            'Envoyer votre position GPS et le centre le plus proche au ${firstContact.phoneNumber}',
                        confirmLabel: 'Envoyer',
                        icon: Icons.chat_rounded,
                        accentColor: AppColors.success,
                      );
                      if (confirmed && mounted) {
                        final user = await ref.read(userProfileProvider.future);
                        await ref
                            .read(emergencyServiceProvider)
                            .sendWhatsAppAlert(
                              [firstContact.phoneNumber],
                              userName: user?.displayName,
                              closestCenter: widget.closestCenter,
                              knownPosition: widget.currentPosition,
                            );
                      }
                    },
                    icon: const Icon(Icons.chat_rounded, size: 18),
                    label: Text(
                      _whatsappLaunched ? 'WhatsApp Contact' : 'Alerter Contact',
                      style: const TextStyle(fontSize: 13),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
