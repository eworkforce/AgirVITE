import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/bp_tracker_service.dart';
import '../../../core/models/bp_reading.dart';

final latestBPProvider = FutureProvider<BPReading?>((ref) async {
  final service = ref.watch(bpTrackerServiceProvider);
  final history = await service.getHistory();
  if (history.isEmpty) return null;
  return history.first; // Already sorted by timestamp desc in repo
});

final recentBPHistoryProvider = StreamProvider<List<BPReading>>((ref) {
  final service = ref.watch(bpTrackerServiceProvider);
  // Return last 7 readings for the graph, reversed to be chronological (oldest to newest)
  return service.watchHistory().map((history) => history.take(7).toList().reversed.toList());
});
