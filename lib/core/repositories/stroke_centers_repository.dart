import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import '../models/stroke_center.dart';

abstract class IStrokeCenterRepository {
  Future<List<StrokeCenter>> getStrokeCenters();
  List<StrokeCenter> sortByDistance(List<StrokeCenter> centers, Position userLocation);
}

class StrokeCenterRepository implements IStrokeCenterRepository {
  List<StrokeCenter>? _cachedCenters;

  @override
  Future<List<StrokeCenter>> getStrokeCenters() async {
    if (_cachedCenters != null) return _cachedCenters!;

    try {
      final String response = await rootBundle.loadString('assets/data/stroke_centers.json');
      final List<dynamic> data = json.decode(response);
      
      _cachedCenters = data.map((json) => StrokeCenter.fromJson(json)).toList();
      return _cachedCenters!;
    } catch (e) {
      debugPrint('Error loading stroke centers: $e');
      return [];
    }
  }

  @override
  List<StrokeCenter> sortByDistance(List<StrokeCenter> centers, Position userLocation) {
    // Create a copy to sort
    final sortedList = List<StrokeCenter>.from(centers);
    sortedList.sort((a, b) {
      final distanceA = Geolocator.distanceBetween(
        userLocation.latitude, userLocation.longitude, a.latitude, a.longitude);
      final distanceB = Geolocator.distanceBetween(
        userLocation.latitude, userLocation.longitude, b.latitude, b.longitude);
      return distanceA.compareTo(distanceB);
    });
    return sortedList;
  }
}

final strokeCenterRepositoryProvider = Provider<IStrokeCenterRepository>((ref) {
  return StrokeCenterRepository();
});
