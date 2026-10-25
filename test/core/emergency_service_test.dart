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
  TestWidgetsFlutterBinding.ensureInitialized();

  group('EmergencyService', () {
    const sampleCenters = [
      StrokeCenter(
        id: 'chu_cocody',
        name: 'CHU de Cocody',
        address: 'Alerte Thrombolyse • Bd de l\'Université, Cocody, Abidjan',
        latitude: 5.347395,
        longitude: -3.995982,
        phone: '07 19 68 80 37',
        hasScanner: true,
        isOpen247: true,
      ),
      StrokeCenter(
        id: 'chr_bouake',
        name: 'CHR de Bouaké',
        address: 'Alerte Thrombolyse • Quartier Commerce, Bouaké',
        latitude: 7.685000,
        longitude: -5.025000,
        phone: '07 48 75 43 95',
        hasScanner: true,
        isOpen247: true,
      ),
    ];

    test('findClosestCenter returns closest center to user GPS position', () {
      final positionNearBouake = Position(
        longitude: -5.0250,
        latitude: 7.6850,
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
      expect(closest!.id, equals('chr_bouake'));
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
      expect(message, contains('07 19 68 80 37'));
      expect(message, contains('Le centre CHU de Cocody est en cours d\'appel'));
      expect(message.contains('185'), isFalse);
      expect(message, contains('5.340277,-4.013233'));
    });

    test('buildEmergencyMessage succeeds even if location service throws', () async {
      final service = EmergencyService(MockLocationService(shouldThrow: true));
      final message = await service.buildEmergencyMessage();

      expect(message, contains('URGENCE VITALE'));
      expect(message.contains('185'), isFalse);
      expect(message.contains('maps.google.com'), isFalse);
    });
  });
}
