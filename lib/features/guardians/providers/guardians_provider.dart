import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/guardian.dart';
import '../../../data/local/boxes/hive_boxes.dart';

// Stream provider to listen to Hive Box changes automatically
final guardiansListProvider = StreamProvider<List<Guardian>>((ref) {
  final box = Hive.box<Guardian>(HiveBoxes.guardians);
  // Emit current values immediately
  // Return stream of values
  return box.watch().map((event) => box.values.toList()).startWith(box.values.toList());
});

extension StreamExtensions<T> on Stream<T> {
  Stream<T> startWith(T initial) async* {
    yield initial;
    yield* this;
  }
}
