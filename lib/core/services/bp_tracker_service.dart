import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/bp_repository.dart';
import '../models/bp_reading.dart';
import 'package:uuid/uuid.dart';

// Service provider
final bpTrackerServiceProvider = Provider<BPTrackerService>((ref) {
  final repository = ref.read(bpRepositoryProvider);
  return BPTrackerService(repository);
});

class BPTrackerService {
  final IBPRepository _repository;
  final _uuid = const Uuid();

  BPTrackerService(this._repository);

  Future<List<BPReading>> getHistory() {
    return _repository.getReadings();
  }

  Stream<List<BPReading>> watchHistory() {
    return _repository.watchReadings();
  }

  Future<void> addReading({
    required int systolic,
    required int diastolic,
    required int pulse,
    bool isManual = false,
  }) async {
    final reading = BPReading(
      id: _uuid.v4(),
      timestamp: DateTime.now(),
      systolic: systolic,
      diastolic: diastolic,
      pulse: pulse,
      isManual: isManual,
    );
    await _repository.saveReading(reading);
  }

  // WHO Categories
  String getStatus(int systolic, int diastolic) {
    if (systolic < 120 && diastolic < 80) return 'Normal';
    if (systolic < 130 && diastolic < 80) return 'Élevée';
    if (systolic < 140 || (diastolic >= 80 && diastolic < 90)) return 'Hypertension Stade 1';
    return 'Hypertension Stade 2';
  }
}
