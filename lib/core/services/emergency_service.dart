import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'location_service.dart';
import '../utils/phone_number_formatter.dart';

final emergencyServiceProvider = Provider((ref) => EmergencyService(ref.read(locationServiceProvider)));

class EmergencyService {
  final LocationService _locationService;
  
  EmergencyService(this._locationService);

  // SAMU number
  static const String samuNumber = '185';

  /// Triggers a direct native dialer call to SAMU (185).
  ///
  /// This must remain completely decoupled from network or location availability.
  Future<void> callSAMU() async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: samuNumber,
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      debugPrint('Could not launch SAMU phone call: $launchUri');
      throw 'Could not launch $launchUri';
    }
  }

  /// Builds the localized emergency distress message with GPS coordinates if available.
  Future<String> buildEmergencyMessage({String? customNote}) async {
    Position? position;
    try {
      position = await _locationService.getCurrentLocation();
    } catch (e) {
      debugPrint('Emergency location retrieval skipped or failed: $e');
    }

    String message = "🚨 URGENCE VITALE - AVC SUSPECTÉ !\n"
        "Je présente des signes d'AVC (Visage, Incapacité bras, Trouble parole).";

    if (customNote != null && customNote.trim().isNotEmpty) {
      message += "\nNote : $customNote";
    }

    if (position != null) {
      message += "\n📍 Ma localisation précise : https://maps.google.com/?q=${position.latitude},${position.longitude}";
    }

    message += "\nSAMU (185) en cours d'alerte. Veuillez intervenir ou m'assister au plus vite.";
    return message;
  }

  /// Sends a targeted WhatsApp alert to the primary guardian (first in list).
  ///
  /// If WhatsApp cannot be launched or fails, falls back automatically to native SMS broadcast.
  Future<void> sendWhatsAppAlert(List<String> phoneNumbers, {String? customNote}) async {
    final message = await buildEmergencyMessage(customNote: customNote);

    if (phoneNumbers.isEmpty) {
      // Fallback: generic WhatsApp share if no guardians registered
      final Uri genericUri = Uri.parse("https://wa.me/?text=${Uri.encodeComponent(message)}");
      if (await canLaunchUrl(genericUri)) {
        await launchUrl(genericUri, mode: LaunchMode.externalApplication);
      }
      return;
    }

    // Target the primary guardian specifically with clean E.164 without '+'
    final primaryNumber = PhoneNumberFormatter.normalize(phoneNumbers.first, includePlus: false);
    final Uri targetUri = Uri.parse("https://wa.me/$primaryNumber?text=${Uri.encodeComponent(message)}");

    try {
      if (await canLaunchUrl(targetUri)) {
        await launchUrl(targetUri, mode: LaunchMode.externalApplication);
      } else {
        debugPrint('WhatsApp unavailable. Triggering native SMS fallback.');
        await sendSMSAlert(phoneNumbers, message: message);
      }
    } catch (e) {
      debugPrint('WhatsApp launch failed: $e. Falling back to SMS.');
      await sendSMSAlert(phoneNumbers, message: message);
    }
  }

  /// Broadcasts emergency SMS to all registered guardian numbers.
  ///
  /// Works completely offline via native SMS application.
  Future<void> sendSMSAlert(List<String> phoneNumbers, {String? message}) async {
    if (phoneNumbers.isEmpty) return;

    final alertMessage = message ?? await buildEmergencyMessage();
    final formattedRecipients = PhoneNumberFormatter.formatForSms(phoneNumbers);

    final Uri smsUri = Uri(
      scheme: 'sms',
      path: formattedRecipients,
      queryParameters: <String, String>{
        'body': alertMessage,
      },
    );

    try {
      if (await canLaunchUrl(smsUri)) {
        await launchUrl(smsUri);
      } else {
        debugPrint('Could not launch SMS URI: $smsUri');
      }
    } catch (e) {
      debugPrint('SMS alert error: $e');
    }
  }
}
