import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/bp_tracker_service.dart';
import '../../../core/models/bp_reading.dart';

final latestBPProvider = FutureProvider<BPReading?>((ref) async {
  final service = ref.watch(bpTrackerServiceProvider);
  // We need to implement getLatestReading in the service first, or sort history
  final history = await service.getHistory();
  if (history.isEmpty) return null;
  return history.first; // Already sorted by timestamp desc in repo
});
