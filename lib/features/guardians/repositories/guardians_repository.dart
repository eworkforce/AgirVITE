import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import '../models/guardian.dart';
import '../../../data/local/boxes/hive_boxes.dart';

abstract class IGuardiansRepository {
  Future<List<Guardian>> getGuardians();
  Future<void> addGuardian(Guardian guardian);
  Future<void> removeGuardian(String id);
  Future<void> updateGuardian(Guardian guardian);
}

class GuardiansRepository implements IGuardiansRepository {
  final Box<Guardian> _box;

  GuardiansRepository(this._box);

  @override
  Future<List<Guardian>> getGuardians() async {
    return _box.values.toList();
  }

  @override
  Future<void> addGuardian(Guardian guardian) async {
    await _box.put(guardian.id, guardian);
  }

  @override
  Future<void> removeGuardian(String id) async {
    await _box.delete(id);
  }

  @override
  Future<void> updateGuardian(Guardian guardian) async {
    await _box.put(guardian.id, guardian);
  }
}

final guardiansRepositoryProvider = Provider<IGuardiansRepository>((ref) {
  final box = Hive.box<Guardian>(HiveBoxes.guardians);
  return GuardiansRepository(box);
});
