import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import '../../../app/theme/colors.dart';
import '../../../core/models/stroke_center.dart';
import '../../../core/repositories/stroke_centers_repository.dart';
import '../../../core/services/location_service.dart';
import 'center_details_sheet.dart';

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  final MapController _mapController = MapController();
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
    ref.read(locationServiceProvider).getPositionStream().listen((position) {
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
              // 1. Tile Layer (OpenStreetMap for now, mock for offline)
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.ong.agir_vite',
                // For true offline, we would swap this with VectorTileLayer
              ),

              // 2. Trajectory Lines (To all centers)
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

              // 3. Markers Layer
              MarkerLayer(
                markers: [
                  // User Location Pulse
                  if (_currentPosition != null)
                    Marker(
                      point: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
                      width: 60,
                      height: 60,
                      child: const _UserLocationMarker(),
                    ),

                  // Stroke Centers
                  ...strokeCentersAsync.when(
                    data: (centers) {
                      // Find closest center
                      StrokeCenter? closest;
                      double minDistance = double.infinity;
                      
                      if (_currentPosition != null) {
                         for (var center in centers) {
                           final dist = Geolocator.distanceBetween(
                             _currentPosition!.latitude, _currentPosition!.longitude, 
                             center.latitude, center.longitude
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
                                  center.longitude)
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
                                        color: isClosest ? Colors.green : (isSelected ? AppColors.primary : Colors.grey.shade300), 
                                        width: isClosest || isSelected ? 2 : 1
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
                                            color: isClosest ? Colors.green.shade800 : Colors.black87
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          "$distKm km${isClosest ? ' (Closest)' : ''}",
                                          style: TextStyle(
                                            fontSize: 9, 
                                            fontWeight: isClosest ? FontWeight.w900 : FontWeight.normal,
                                            color: isClosest ? Colors.green : Colors.black54
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Icon(
                                    Icons.location_on, 
                                    color: isClosest ? Colors.green : (isSelected ? AppColors.primary : Colors.red), 
                                    size: isSelected || isClosest ? 35 : 30
                                  ),
                                ],
                              ),
                            ),
                          );
                        });
                    },
                    error: (_, _) => [],
                    loading: () => [],
                  ),
                ],
              ),
            ],
          ),

          // Recenter Button
          Positioned(
            right: 16,
            bottom: 150, // Above bottom sheet
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
              child: Icon(Icons.my_location, color: AppColors.primary),
            ),
          ),

          // Back Button
          Positioned(
            top: 50,
            left: 16,
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),

          // Menu Toggle Button
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

          // Side Menu
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            left: _isMenuOpen ? 0 : -300,
            top: 0,
            bottom: 0,
            width: 300,
            child: _SideMenu(
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

  void _selectCenter(StrokeCenter center) {
    setState(() {
      _selectedCenter = center;
      _isFollowingUser = false;
    });

    _mapController.move(
      LatLng(center.latitude, center.longitude),
      15.0,
    );
    
    // Show Details Sheet
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => CenterDetailsSheet(center: center),
    );
  }
}

class _UserLocationMarker extends StatefulWidget {
  const _UserLocationMarker();

  @override
  State<_UserLocationMarker> createState() => _UserLocationMarkerState();
}

class _UserLocationMarkerState extends State<_UserLocationMarker> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 60 * _controller.value,
              height: 60 * _controller.value,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withValues(alpha: 0.3 * (1 - _controller.value)),
              ),
            ),
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary,
                border: Border.all(color: Colors.white, width: 2),
              ),
            ),
          ],
        );
      },
    );
  }
}


// Simple provider wrapper for easier access in the widget
final strokeCentersProvider = FutureProvider<List<StrokeCenter>>((ref) async {
  return ref.read(strokeCenterRepositoryProvider).getStrokeCenters();
});

class _SideMenu extends StatelessWidget {
  final List<StrokeCenter> centers;
  final StrokeCenter? selectedCenter;
  final Position? currentPosition;
  final Function(StrokeCenter) onSelect;
  final VoidCallback onClose;

  const _SideMenu({
    required this.centers,
    required this.selectedCenter,
    required this.currentPosition,
    required this.onSelect,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    // Sort centers by distance if user position is known
    final sortedCenters = List<StrokeCenter>.from(centers);
    if (currentPosition != null) {
      sortedCenters.sort((a, b) {
        final distA = Geolocator.distanceBetween(
          currentPosition!.latitude, currentPosition!.longitude,
          a.latitude, a.longitude
        );
        final distB = Geolocator.distanceBetween(
          currentPosition!.latitude, currentPosition!.longitude,
          b.latitude, b.longitude
        );
        return distA.compareTo(distB);
      });
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(16, 50, 8, 16),
            color: AppColors.primary,
            child: Row(
              children: [
                const Icon(Icons.local_hospital, color: Colors.white),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'Centres AVC',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: onClose,
                ),
              ],
            ),
          ),
          
          // Recommendation Card (New)
          if (selectedCenter == null && currentPosition != null && sortedCenters.isNotEmpty)
            Builder(
              builder: (context) {
                // Find closest (list is already sorted by distance)
                final closest = sortedCenters.first;
                return Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.1),
                    border: Border.all(color: AppColors.success),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.recommend, color: AppColors.success),
                          SizedBox(width: 8),
                          Text("Recommandé", style: TextStyle(color: AppColors.success, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      const Text("Le centre le plus proche est :"),
                      const SizedBox(height: 4),
                      Text(closest.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.success,
                            foregroundColor: Colors.white,
                            elevation: 0,
                          ),
                          onPressed: () => onSelect(closest),
                          child: const Text("Voir"),
                        ),
                      ),
                    ],
                  ),
                );
              }
            ),

          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.zero,
              itemCount: sortedCenters.length,
              separatorBuilder: (_, _) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final center = sortedCenters[index];
                final isSelected = center == selectedCenter;
                final isClosest = index == 0 && currentPosition != null;
                
                String? distanceText;
                if (currentPosition != null) {
                   final dist = Geolocator.distanceBetween(
                     currentPosition!.latitude, currentPosition!.longitude, 
                     center.latitude, center.longitude
                   );
                   distanceText = "${(dist / 1000).toStringAsFixed(1)} km";
                }

                return ListTile(
                  tileColor: isClosest 
                      ? Colors.green.withValues(alpha: 0.1) 
                      : (isSelected ? AppColors.primary.withValues(alpha: 0.1) : null),
                  leading: Icon(
                    Icons.location_on,
                    color: isClosest ? Colors.green : (isSelected ? AppColors.primary : Colors.grey),
                  ),
                  title: Text(
                    center.name,
                    style: TextStyle(
                      fontWeight: isSelected || isClosest ? FontWeight.bold : FontWeight.normal,
                      fontSize: 14,
                      color: isClosest ? Colors.green.shade800 : Colors.black87,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: distanceText != null 
                    ? Text(
                        "$distanceText${isClosest ? ' (Le plus proche)' : ''}", 
                        style: TextStyle(
                          fontSize: 12,
                          color: isClosest ? Colors.green : Colors.black54,
                          fontWeight: isClosest ? FontWeight.bold : FontWeight.normal
                        )
                      ) 
                    : null,
                  onTap: () => onSelect(center),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
