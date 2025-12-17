import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'location_service.dart';

final emergencyServiceProvider = Provider((ref) => EmergencyService(ref.read(locationServiceProvider)));

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
    Position? position;
    try {
      position = await _locationService.getCurrentLocation();
    } catch (e) {
      // Proceed without location if fails
    }
    
    // Construct Message
    String message = "🚨 AIDEZ-MOI ! Je pense faire un AVC.";
    if (position != null) {
      // Use Google Maps link as Plus Code alternative for broad compatibility
      message += "\nMa position : https://maps.google.com/?q=${position.latitude},${position.longitude}";
    }

    // 2. Launch WhatsApp
    // If we have specific numbers, we could target them, but for now we use the generic share
    // which allows broadcasting to any contact/group.
    final Uri whatsappUri = Uri.parse("https://wa.me/?text=${Uri.encodeComponent(message)}");
    
    if (await canLaunchUrl(whatsappUri)) {
      await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
    } else {
       // Fallback to SMS if WhatsApp fails? Or just log
    }
  }
}
