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
import '../../../core/services/emergency_service.dart';
import '../../../core/services/location_service.dart';
import '../../emergency/widgets/emergency_map_overlay.dart';
import '../../emergency/widgets/sos_button.dart';
import '../widgets/center_map_marker.dart';
import '../widgets/map_side_menu.dart';
import 'center_details_sheet.dart';

final strokeCentersProvider = FutureProvider<List<StrokeCenter>>((ref) async {
  return ref.read(strokeCenterRepositoryProvider).getStrokeCenters();
});

class MapScreen extends ConsumerStatefulWidget {
  final bool autoTriggerEmergency;

  const MapScreen({
    super.key,
    this.autoTriggerEmergency = false,
  });

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  final MapController _mapController = MapController();
  StreamSubscription<Position>? _positionSub;
  StrokeCenter? _selectedCenter;
  StrokeCenter? _emergencyCenter;
  Position? _currentPosition;
  bool _isFollowingUser = true;
  bool _isMenuOpen = false;
  bool _didHandleInitialEmergency = false;

  @override
  void initState() {
    super.initState();
    _startLocationUpdates();
  }

  @override
  void didUpdateWidget(covariant MapScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.autoTriggerEmergency && !oldWidget.autoTriggerEmergency) {
      final centers = ref.read(strokeCentersProvider).valueOrNull;
      if (centers != null && centers.isNotEmpty) {
        _activateEmergencyZoom(centers);
      }
    }
  }

  void _startLocationUpdates() {
    _positionSub = ref
        .read(locationServiceProvider)
        .getPositionStream()
        .listen((position) {
      if (mounted) {
        setState(() => _currentPosition = position);
        if (_isFollowingUser && _emergencyCenter == null) {
          _mapController.move(
            LatLng(position.latitude, position.longitude),
            _mapController.camera.zoom,
          );
        }
      }
    });
  }

  void _activateEmergencyZoom(List<StrokeCenter> centers) {
    final closest = ref
        .read(emergencyServiceProvider)
        .findClosestCenter(centers, position: _currentPosition);
    if (closest == null || !mounted) return;

    setState(() {
      _selectedCenter = closest;
      _emergencyCenter = closest;
      _isFollowingUser = false;
      _isMenuOpen = false;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      try {
        _mapController.move(
          LatLng(closest.latitude, closest.longitude),
          16.0,
        );
      } catch (_) {}
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

    ref.listen<int>(emergencyTriggerProvider, (previous, next) {
      final centers = strokeCentersAsync.valueOrNull;
      if (centers != null && centers.isNotEmpty) {
        _activateEmergencyZoom(centers);
      }
    });

    if (widget.autoTriggerEmergency &&
        !_didHandleInitialEmergency &&
        strokeCentersAsync.hasValue &&
        strokeCentersAsync.value!.isNotEmpty) {
      _didHandleInitialEmergency = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _activateEmergencyZoom(strokeCentersAsync.value!);
        }
      });
    }

    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: const LatLng(
                EmergencyService.defaultLatitude,
                EmergencyService.defaultLongitude,
              ),
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
            bottom: _emergencyCenter != null ? 290 : 150,
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
          if (_emergencyCenter != null)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: EmergencyMapOverlay(
                key: ValueKey(_emergencyCenter!.id),
                closestCenter: _emergencyCenter!,
                currentPosition: _currentPosition,
                onClose: () => setState(() => _emergencyCenter = null),
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
    final closest = ref
        .read(emergencyServiceProvider)
        .findClosestCenter(centers, position: _currentPosition);

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

      return Marker(
        point: LatLng(center.latitude, center.longitude),
        width: 140,
        height: 90,
        child: CenterMapMarker(
          center: center,
          distKm: distKm,
          isSelected: center == _selectedCenter,
          isClosest: center == closest,
          onTap: () => _selectCenter(center),
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
