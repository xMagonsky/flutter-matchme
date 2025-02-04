import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class LocationRangeData {
  final LatLng location;
  final double range;

  LocationRangeData({
    required this.location,
    required this.range,
  });
}

class LocationRangeMap extends StatefulWidget {
  final ValueChanged<LocationRangeData> onChanged;

  final LatLng initialLocation;
  final double initialRange;

  const LocationRangeMap({super.key, required this.onChanged, this.initialLocation = const LatLng(45.468, 9.182), this.initialRange = 1000});

  @override
  State<LocationRangeMap> createState() => _LocationRangeMapState();
}

class _LocationRangeMapState extends State<LocationRangeMap> {
  late LatLng _selectedLocation;
  late double _rangeInMeters;

  @override
  void initState() {
    super.initState();
    _selectedLocation = widget.initialLocation;
    _rangeInMeters = widget.initialRange;

    // Inform the parent of the initial state.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onChanged(
        LocationRangeData(location: _selectedLocation, range: _rangeInMeters),
      );
    });
  }

  void _updateLocation(LatLng newLocation) {
    setState(() {
      _selectedLocation = newLocation;
    });
    widget.onChanged(
      LocationRangeData(location: _selectedLocation, range: _rangeInMeters),
    );
  }

  void _updateRange(double newRange) {
    setState(() {
      _rangeInMeters = newRange;
    });
    widget.onChanged(
      LocationRangeData(location: _selectedLocation, range: _rangeInMeters),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // The map occupies most of the available space.
        Container(
          height: 250,
          width: 600,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: FlutterMap(
            options: MapOptions(
              initialCenter: _selectedLocation,
              initialZoom: 11,
              onTap: (tapPosition, point) {
                _updateLocation(point);
              },
            ),
            children: [
              // Base map layer using OpenStreetMap tiles.
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              ),
              // Circle layer to show the selected range around the location.
              CircleLayer(
                circles: [
                  CircleMarker(
                    point: _selectedLocation,
                    radius: _rangeInMeters,
                    useRadiusInMeter: true,
                    color: Colors.deepPurple.withOpacity(0.3),
                    borderColor: Colors.deepPurple,
                    borderStrokeWidth: 2,
                  ),
                ],
              ),
              // Marker layer to display the selected location.
              MarkerLayer(
                markers: [
                  Marker(
                    width: 100,
                    height: 100,
                    alignment: Alignment(0, -0.30),
                    point: _selectedLocation,
                    child: const Icon(
                      Icons.location_pin,
                      color: Colors.deepPurple,
                      size: 40,
                      shadows: [
                        Shadow(
                          color: Colors.black,
                          blurRadius: 15.0,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        // Slider for adjusting the range.
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text('Range: ${_rangeInMeters.toInt()} meters'),
              Slider(
                value: _rangeInMeters,
                min: 100,
                max: 10000,
                label: _rangeInMeters.toInt().toString(),
                onChanged: (value) {
                  _updateRange(value);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}