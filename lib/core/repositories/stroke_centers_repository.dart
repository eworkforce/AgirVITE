import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import '../models/stroke_center.dart';

final strokeCentersProvider = FutureProvider<List<StrokeCenter>>((ref) async {
  final repository = StrokeCentersRepository();
  return repository.loadCenters();
});

class StrokeCentersRepository {
  Future<List<StrokeCenter>> loadCenters() async {
    final String response = await rootBundle.loadString('assets/data/stroke_centers.json');
    final List<dynamic> data = json.decode(response);
    return data.map((json) => StrokeCenter.fromJson(json)).toList();
  }

  List<StrokeCenter> sortByDistance(List<StrokeCenter> centers, Position userLocation) {
    centers.sort((a, b) {
      final distanceA = Geolocator.distanceBetween(
        userLocation.latitude, userLocation.longitude, a.latitude, a.longitude);
      final distanceB = Geolocator.distanceBetween(
        userLocation.latitude, userLocation.longitude, b.latitude, b.longitude);
      return distanceA.compareTo(distanceB);
    });
    return centers;
  }
}
