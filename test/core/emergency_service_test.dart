import 'package:flutter_test/flutter_test.dart';
import 'package:agir_vite/core/models/stroke_center.dart';
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
    const sampleCenters = [
      StrokeCenter(
        id: 'chu_cocody',
        name: 'CHU de Cocody',
        address: 'Cocody, Abidjan',
        latitude: 5.3561,
        longitude: -3.9878,
        phone: '+225 27 22 44 91 00',
        hasScanner: true,
        isOpen247: true,
      ),
      StrokeCenter(
        id: 'chu_bouake',
        name: 'CHU de Bouaké',
        address: 'Bouaké',
        latitude: 7.6939,
        longitude: -5.0308,
        phone: '+225 27 31 63 21 90',
        hasScanner: true,
        isOpen247: true,
      ),
    ];

    test('findClosestCenter returns closest center to user GPS position', () {
      final positionNearBouake = Position(
        longitude: -5.0300,
        latitude: 7.6900,
        timestamp: DateTime.now(),
        accuracy: 5.0,
        altitude: 10.0,
        altitudeAccuracy: 1.0,
        heading: 0.0,
        headingAccuracy: 1.0,
        speed: 0.0,
        speedAccuracy: 1.0,
      );

      final service = EmergencyService(MockLocationService());
      final closest = service.findClosestCenter(
        sampleCenters,
        position: positionNearBouake,
      );

      expect(closest, isNotNull);
      expect(closest!.id, equals('chu_bouake'));
    });

    test('buildEmergencyMessage includes userName, closestCenter, and GPS coordinates', () async {
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
      final message = await service.buildEmergencyMessage(
        userName: 'Kouadio',
        closestCenter: sampleCenters.first,
      );

      expect(message, contains('URGENCE VITALE - AVC SUSPECTÉ (Kouadio)'));
      expect(message, contains('CHU de Cocody'));
      expect(message, contains('+225 27 22 44 91 00'));
      expect(message, contains('5.340277,-4.013233'));
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
