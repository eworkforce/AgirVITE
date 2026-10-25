import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/stroke_center.dart';
import 'location_service.dart';
import '../utils/phone_number_formatter.dart';

final emergencyServiceProvider = Provider(
  (ref) => EmergencyService(ref.read(locationServiceProvider)),
);

class EmergencyService {
  final LocationService _locationService;

  static const MethodChannel _nativeChannel = MethodChannel(
    'com.avcespoir.agir_vite/emergency',
  );

  EmergencyService(this._locationService);

  /// Fallback emergency number (SAMU Côte d'Ivoire).
  static const String samuNumber = '185';

  /// Default Abidjan coordinates used when GPS is disabled or unavailable.
  static const double defaultLatitude = 5.340277;
  static const double defaultLongitude = -4.013233;

  /// Finds the closest [StrokeCenter] to [position] (or to Abidjan center if null).
  StrokeCenter? findClosestCenter(
    List<StrokeCenter> centers, {
    Position? position,
  }) {
    if (centers.isEmpty) return null;

    final refLat = position?.latitude ?? defaultLatitude;
    final refLng = position?.longitude ?? defaultLongitude;

    StrokeCenter closest = centers.first;
    double minDistance = double.infinity;

    for (final center in centers) {
      final dist = Geolocator.distanceBetween(
        refLat,
        refLng,
        center.latitude,
        center.longitude,
      );
      if (dist < minDistance) {
        minDistance = dist;
        closest = center;
      }
    }
    return closest;
  }

  /// Triggers a direct native phone call to a specific stroke center's phone number.
  ///
  /// Uses Android native `ACTION_CALL` via MethodChannel first, falling back to `tel:` URI.
  Future<bool> callCenter(String phoneNumber) async {
    final cleanPhone = PhoneNumberFormatter.normalize(
      phoneNumber,
      includePlus: true,
    );
    if (cleanPhone.isEmpty) return false;

    try {
      final directSuccess = await _nativeChannel.invokeMethod<bool>(
        'callNumberDirectly',
        <String, dynamic>{'phone': cleanPhone},
      );
      if (directSuccess == true) {
        return true;
      }
    } catch (e) {
      debugPrint('Native direct call channel unavailable, using tel URI: $e');
    }

    final Uri launchUri = Uri(scheme: 'tel', path: cleanPhone);
    try {
      if (await canLaunchUrl(launchUri)) {
        return await launchUrl(launchUri);
      }
    } catch (e) {
      debugPrint('Error launching center phone call: $e');
    }
    return false;
  }

  /// Triggers a direct native dialer call to SAMU (185).
  Future<bool> callSAMU() async {
    return callCenter(samuNumber);
  }

  /// Builds the localized emergency distress message with user name, closest center,
  /// and GPS coordinates if available.
  Future<String> buildEmergencyMessage({
    String? userName,
    String? contactName,
    StrokeCenter? closestCenter,
    String? customNote,
    Position? knownPosition,
  }) async {
    Position? position = knownPosition;
    if (position == null) {
      try {
        position = await _locationService.getCurrentLocation();
      } catch (e) {
        debugPrint('Emergency location retrieval skipped or failed: $e');
      }
    }

    final headerName = (userName != null && userName.trim().isNotEmpty)
        ? ' (${userName.trim()})'
        : '';

    String message = "🚨 URGENCE VITALE - AVC SUSPECTÉ$headerName !\n"
        "Je présente des signes d'AVC (Visage, Incapacité bras, Trouble parole).";

    if (closestCenter != null) {
      message +=
          "\n🏥 Centre le plus proche : ${closestCenter.name} (${closestCenter.phone})";
    }

    if (customNote != null && customNote.trim().isNotEmpty) {
      message += "\nNote : $customNote";
    }

    if (position != null) {
      message +=
          "\n📍 Ma localisation précise : https://maps.google.com/?q=${position.latitude},${position.longitude}";
    }

    message +=
        "\nSAMU (185) / Centre d'urgence en cours d'appel. Veuillez intervenir ou m'assister au plus vite.";
    return message;
  }

  /// Sends an automatic, headless background SMS to the primary contact using
  /// Android's native `SmsManager` (`SEND_SMS`), without opening any SMS composer UI.
  ///
  /// Returns `true` if sent headlessly in the background, or `false` if fallback is needed.
  Future<bool> sendHeadlessSms(
    String phoneNumber, {
    String? message,
    String? userName,
    StrokeCenter? closestCenter,
    Position? knownPosition,
  }) async {
    final normalizedPhone = PhoneNumberFormatter.normalize(
      phoneNumber,
      includePlus: true,
    );
    if (normalizedPhone.isEmpty) return false;

    final alertMessage = message ??
        await buildEmergencyMessage(
          userName: userName,
          closestCenter: closestCenter,
          knownPosition: knownPosition,
        );

    try {
      final sent = await _nativeChannel.invokeMethod<bool>(
        'sendDirectSms',
        <String, dynamic>{
          'phone': normalizedPhone,
          'message': alertMessage,
        },
      );
      if (sent == true) {
        return true;
      }
    } catch (e) {
      debugPrint('Headless SMS MethodChannel error: $e');
    }
    return false;
  }

  /// Sends a pre-addressed WhatsApp alert directly to the first contact's chat thread
  /// (`whatsapp://send?phone=225...&text=...`) so the user never has to pick a recipient.
  Future<bool> sendWhatsAppAlert(
    List<String> phoneNumbers, {
    String? customNote,
    String? prebuiltMessage,
    String? userName,
    StrokeCenter? closestCenter,
    Position? knownPosition,
  }) async {
    final message = prebuiltMessage ??
        await buildEmergencyMessage(
          customNote: customNote,
          userName: userName,
          closestCenter: closestCenter,
          knownPosition: knownPosition,
        );

    if (phoneNumbers.isEmpty) {
      final Uri genericUri = Uri.parse(
        "https://wa.me/?text=${Uri.encodeComponent(message)}",
      );
      if (await canLaunchUrl(genericUri)) {
        return await launchUrl(
          genericUri,
          mode: LaunchMode.externalApplication,
        );
      }
      return false;
    }

    // Target the primary contact specifically with clean E.164 digits (no '+')
    final primaryNumber = PhoneNumberFormatter.normalize(
      phoneNumbers.first,
      includePlus: false,
    );

    // 1. Direct WhatsApp scheme opens directly inside the contact's conversation
    final Uri whatsappSchemeUri = Uri.parse(
      "whatsapp://send?phone=$primaryNumber&text=${Uri.encodeComponent(message)}",
    );

    // 2. Universal link fallback
    final Uri waMeUri = Uri.parse(
      "https://wa.me/$primaryNumber?text=${Uri.encodeComponent(message)}",
    );

    try {
      if (await canLaunchUrl(whatsappSchemeUri)) {
        return await launchUrl(
          whatsappSchemeUri,
          mode: LaunchMode.externalApplication,
        );
      } else if (await canLaunchUrl(waMeUri)) {
        return await launchUrl(
          waMeUri,
          mode: LaunchMode.externalApplication,
        );
      } else {
        debugPrint('WhatsApp unavailable. Triggering SMS fallback.');
        await sendSMSAlert(phoneNumbers, message: message);
        return false;
      }
    } catch (e) {
      debugPrint('WhatsApp launch failed: $e. Falling back to SMS.');
      await sendSMSAlert(phoneNumbers, message: message);
      return false;
    }
  }

  /// Fallback SMS composer broadcast if headless SMS permission was denied.
  Future<void> sendSMSAlert(
    List<String> phoneNumbers, {
    String? message,
  }) async {
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
