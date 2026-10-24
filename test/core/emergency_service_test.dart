import 'package:flutter_test/flutter_test.dart';
import 'package:agir_vite/core/services/emergency_service.dart';
import 'package:agir_vite/core/services/location_service.dart';
import 'package:geolocator/geolocator.dart';

class MockLocationService implements LocationService {
  final Position? mockPosition;
  final bool shouldThrow;

  MockLocationService({this.mockPosition, this.shouldThrow = false});

  @override
  Future<Position> getCurrentLocation() async {
    if (shouldThrow) {
      throw Exception('GPS disabled');
    }
    if (mockPosition != null) {
      return mockPosition!;
    }
    return Future.error('No position');
  }

  @override
  Stream<Position> getPositionStream() {
    return const Stream.empty();
  }
}

void main() {
  group('EmergencyService', () {
    test('buildEmergencyMessage includes GPS coordinates when location available', () async {
      final position = Position(
        longitude: -4.013233,
        latitude: 5.340277,
        timestamp: DateTime.now(),
        accuracy: 5.0,
        altitude: 10.0,
        altitudeAccuracy: 1.0,
        heading: 0.0,
        headingAccuracy: 1.0,
        speed: 0.0,
        speedAccuracy: 1.0,
      );

      final service = EmergencyService(MockLocationService(mockPosition: position));
      final message = await service.buildEmergencyMessage();

      expect(message, contains('URGENCE VITALE'));
      expect(message, contains('5.340277,-4.013233'));
      expect(message, contains('185'));
    });

    test('buildEmergencyMessage succeeds even if location service throws', () async {
      final service = EmergencyService(MockLocationService(shouldThrow: true));
      final message = await service.buildEmergencyMessage();

      expect(message, contains('URGENCE VITALE'));
      expect(message, contains('185'));
      expect(message.contains('maps.google.com'), isFalse);
    });
  });
}
