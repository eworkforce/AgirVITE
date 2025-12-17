import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/bp_reading.dart';
import '../../data/local/boxes/hive_boxes.dart';

abstract class IBPRepository {
  Future<List<BPReading>> getReadings();
  Future<void> saveReading(BPReading reading);
  Future<void> deleteReading(String id);
}

class BPRepository implements IBPRepository {
  final Box<BPReading> _box;

  BPRepository(this._box);

  @override
  Future<List<BPReading>> getReadings() async {
    return _box.values.toList()..sort((a, b) => b.timestamp.compareTo(a.timestamp));
  }

  @override
  Future<void> saveReading(BPReading reading) async {
    await _box.put(reading.id, reading);
  }

  @override
  Future<void> deleteReading(String id) async {
    await _box.delete(id);
  }
}

final bpRepositoryProvider = Provider<IBPRepository>((ref) {
  return BPRepository(Hive.box<BPReading>(HiveBoxes.bpReadings));
});
