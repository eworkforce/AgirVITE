import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import '../../../app/theme/colors.dart';
import '../../../core/models/stroke_center.dart';
import '../../../core/repositories/stroke_centers_repository.dart';
import '../../../core/services/location_service.dart';
import '../widgets/map_side_menu.dart';
import 'center_details_sheet.dart';

final strokeCentersProvider = FutureProvider<List<StrokeCenter>>((ref) async {
  return ref.read(strokeCenterRepositoryProvider).getStrokeCenters();
});

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  final MapController _mapController = MapController();
  StreamSubscription<Position>? _positionSub;
  StrokeCenter? _selectedCenter;
  Position? _currentPosition;
  bool _isFollowingUser = true;
  bool _isMenuOpen = false;

  @override
  void initState() {
    super.initState();
    _startLocationUpdates();
  }

  void _startLocationUpdates() {
    _positionSub = ref
        .read(locationServiceProvider)
        .getPositionStream()
        .listen((position) {
      if (mounted) {
        setState(() => _currentPosition = position);
        if (_isFollowingUser) {
          _mapController.move(
            LatLng(position.latitude, position.longitude),
            _mapController.camera.zoom,
          );
        }
      }
    });
  }

  @override
  void dispose() {
    _positionSub?.cancel();
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final strokeCentersAsync = ref.watch(strokeCentersProvider);

    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: const LatLng(5.340277, -4.013233), // Abidjan default
              initialZoom: 13.0,
              minZoom: 1.0,
              onPositionChanged: (position, hasGesture) {
                if (hasGesture) {
                  setState(() => _isFollowingUser = false);
                }
              },
              interactionOptions: const InteractionOptions(
                flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
              ),
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.avcespoir.agir_vite',
              ),
              if (_currentPosition != null && strokeCentersAsync.hasValue)
                PolylineLayer(
                  polylines: strokeCentersAsync.value!.map((center) {
                    final isSelected = center == _selectedCenter;
                    return Polyline(
                      points: [
                        LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
                        LatLng(center.latitude, center.longitude),
                      ],
                      color: isSelected
                          ? AppColors.primary.withValues(alpha: 0.8)
                          : Colors.grey.withValues(alpha: 0.3),
                      strokeWidth: isSelected ? 3.0 : 1.0,
                      pattern: StrokePattern.dashed(segments: [10.0, 5.0]),
                    );
                  }).toList(),
                ),
              MarkerLayer(
                markers: [
                  if (_currentPosition != null)
                    Marker(
                      point: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
                      width: 60,
                      height: 60,
                      child: const UserLocationMarker(),
                    ),
                  ...strokeCentersAsync.when(
                    data: (centers) => _buildCenterMarkers(centers),
                    error: (_, _) => [],
                    loading: () => [],
                  ),
                ],
              ),
            ],
          ),
          Positioned(
            right: 16,
            bottom: 150,
            child: FloatingActionButton(
              mini: true,
              backgroundColor: Colors.white,
              onPressed: () {
                setState(() => _isFollowingUser = true);
                if (_currentPosition != null) {
                  _mapController.move(
                    LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
                    15.0,
                  );
                }
              },
              child: const Icon(Icons.my_location, color: AppColors.primary),
            ),
          ),
          Positioned(
            top: 50,
            left: 16,
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: IconButton(
                icon: const Icon(Icons.home, color: Colors.black),
                onPressed: () => context.go('/dashboard'),
              ),
            ),
          ),
          Positioned(
            top: 110,
            left: 16,
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: IconButton(
                icon: Icon(_isMenuOpen ? Icons.close : Icons.menu, color: Colors.black),
                onPressed: () => setState(() => _isMenuOpen = !_isMenuOpen),
              ),
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            left: _isMenuOpen ? 0 : -300,
            top: 0,
            bottom: 0,
            width: 300,
            child: MapSideMenu(
              centers: strokeCentersAsync.valueOrNull ?? [],
              selectedCenter: _selectedCenter,
              currentPosition: _currentPosition,
              onClose: () => setState(() => _isMenuOpen = false),
              onSelect: (center) {
                setState(() => _isMenuOpen = false);
                _selectCenter(center);
              },
            ),
          ),
        ],
      ),
    );
  }

  List<Marker> _buildCenterMarkers(List<StrokeCenter> centers) {
    StrokeCenter? closest;
    double minDistance = double.infinity;

    if (_currentPosition != null) {
      for (final center in centers) {
        final dist = Geolocator.distanceBetween(
          _currentPosition!.latitude,
          _currentPosition!.longitude,
          center.latitude,
          center.longitude,
        );
        if (dist < minDistance) {
          minDistance = dist;
          closest = center;
        }
      }
    }

    return centers.map((center) {
      final dist = _currentPosition != null
          ? Geolocator.distanceBetween(
              _currentPosition!.latitude,
              _currentPosition!.longitude,
              center.latitude,
              center.longitude,
            )
          : 0.0;
      final distKm = (dist / 1000).toStringAsFixed(1);
      final isSelected = center == _selectedCenter;
      final isClosest = center == closest;

      return Marker(
        point: LatLng(center.latitude, center.longitude),
        width: 140,
        height: 90,
        child: GestureDetector(
          onTap: () => _selectCenter(center),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                decoration: BoxDecoration(
                  color: isClosest ? Colors.green.shade50 : Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isClosest
                        ? Colors.green
                        : (isSelected ? AppColors.primary : Colors.grey.shade300),
                    width: isClosest || isSelected ? 2 : 1,
                  ),
                  boxShadow: const [BoxShadow(blurRadius: 2, color: Colors.black12)],
                ),
                child: Column(
                  children: [
                    Text(
                      center.name,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: isClosest ? Colors.green.shade800 : Colors.black87,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      "$distKm km${isClosest ? ' (Proche)' : ''}",
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: isClosest ? FontWeight.w900 : FontWeight.normal,
                        color: isClosest ? Colors.green : Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 2),
              Icon(
                Icons.location_on,
                color: isClosest
                    ? Colors.green
                    : (isSelected ? AppColors.primary : Colors.red),
                size: isSelected || isClosest ? 35 : 30,
              ),
            ],
          ),
        ),
      );
    }).toList();
  }

  void _selectCenter(StrokeCenter center) {
    setState(() {
      _selectedCenter = center;
      _isFollowingUser = false;
    });

    _mapController.move(
      LatLng(center.latitude, center.longitude),
      15.0,
    );

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => CenterDetailsSheet(center: center),
    );
  }
}
