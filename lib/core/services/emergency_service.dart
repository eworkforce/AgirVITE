import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'location_service.dart';

final emergencyServiceProvider = Provider((ref) => EmergencyService(LocationService()));

class EmergencyService {
  final LocationService _locationService;
  
  EmergencyService(this._locationService);

  // SAMU number
  static const String samuNumber = '185';

  Future<void> callSAMU() async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: samuNumber,
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      throw 'Could not launch $launchUri';
    }
  }

  Future<void> sendWhatsAppAlert(List<String> phoneNumbers) async {
    // 1. Get Location
    // Position? position;
    // try {
    //   position = await _locationService.getCurrentLocation();
    // } catch (e) {
    //   // Proceed without location if fails
    // }
    
    // For V1, we just open WhatsApp for the first contact or a general share
    // Implementing deep linking for specific numbers:
    
    // TODO: Loop through numbers and send or create a group link
    // For now, simpler implementation:
    // https://wa.me/?text=...
    
    String message = "🚨 AIDEZ-MOI ! Je pense faire un AVC.";
    // if (position != null) {
    //   message += "\nMa position : https://maps.google.com/?q=${position.latitude},${position.longitude}";
    // }

    final Uri whatsappUri = Uri.parse("https://wa.me/?text=${Uri.encodeComponent(message)}");
    
    if (await canLaunchUrl(whatsappUri)) {
      await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
    }
  }
}
