import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../bloc/logic.dart';
import '../services/location_service.dart';
import '../services/error_handler.dart';
import 'cars/cars.dart';
import 'ev_home_page.dart';
import 'splash_screen.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  double _zoomLevel = 13.0;
  LatLng _mapCenter = const LatLng(30.0444, 31.2357);
  late MapController _mapController;
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _filteredStations = [];
  List<Map<String, dynamic>> _allStations = [];
  bool _isLocationLoading = false;
  LatLng? _userLocation;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    context.read<EVBloc>().add(FetchStationsEvent());
    _getUserLocation();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _getUserLocation() async {
    setState(() {
      _isLocationLoading = true;
    });

    try {
      LatLng? location = await LocationService.getCurrentLocation();
      if (location != null && mounted) {
        setState(() {
          _userLocation = location;
          _mapCenter = location;
        });
        _mapController.move(location, _zoomLevel);
        ErrorHandler.showSuccessSnackbar(context, 'Location found!');
      } else {
        ErrorHandler.showWarningSnackbar(
          context,
          'Could not get location. Using default location.',
        );
      }
    } catch (e) {
      ErrorHandler.showWarningSnackbar(
        context,
        'Location access denied. Using default location.',
      );
    } finally {
      setState(() {
        _isLocationLoading = false;
      });
    }
  }

  void _filterStations(String query) {
    if (query.isEmpty) {
      setState(() {
        _filteredStations = _allStations;
      });
      return;
    }

    setState(() {
      _filteredStations =
          _allStations.where((station) {
            final name = station['name']?.toString().toLowerCase() ?? '';
            final type = station['type']?.toString().toLowerCase() ?? '';
            final searchLower = query.toLowerCase();
            return name.contains(searchLower) || type.contains(searchLower);
          }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Stations Map',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const HomePage(username: 'User'),
              ),
            );
          },
        ),
        backgroundColor: Colors.deepPurple,
      ),
      body: BlocBuilder<EVBloc, EVState>(
        builder: (context, state) {
          if (state is EVLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is EVStationsLoaded) {
            final stations = state.stations;

            if (_allStations != stations) {
              _allStations = stations;
              _filteredStations = stations;
            }

            return Stack(
              children: [
                // Search bar
                Positioned(
                  top: 10,
                  left: 16,
                  right: 80,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _searchController,
                      onChanged: _filterStations,
                      decoration: const InputDecoration(
                        hintText: 'Search stations...',
                        prefixIcon: Icon(Icons.search),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 15,
                        ),
                      ),
                    ),
                  ),
                ),
                // My Location button
                Positioned(
                  top: 10,
                  right: 16,
                  child: FloatingActionButton(
                    heroTag: 'my_location',
                    mini: true,
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.deepPurple,
                    onPressed: _isLocationLoading ? null : _getUserLocation,
                    child:
                        _isLocationLoading
                            ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                            : const Icon(Icons.my_location),
                  ),
                ),
                // Map
                Positioned.fill(
                  top: 70,
                  child: FlutterMap(
                    mapController: _mapController,
                    options: MapOptions(
                      onTap: (tapPosition, latlng) {
                        _addStationDialog(context, latlng);
                      },
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                        subdomains: const ['a', 'b', 'c'],
                      ),
                      MarkerLayer(
                        markers: [
                          // User location marker
                          if (_userLocation != null)
                            Marker(
                              width: 80.0,
                              height: 80.0,
                              point: _userLocation!,
                              child: const Icon(
                                Icons.person_pin_circle,
                                color: Colors.blue,
                                size: 40.0,
                              ),
                            ),
                          // Station markers
                          ..._filteredStations.map((station) {
                            double lat = station['x'] ?? 0.0;
                            double lng = station['y'] ?? 0.0;
                            String stationName =
                                station['name'] ?? 'Unknown Station';
                            String stationType = station['type'] ?? 'Unknown';

                            return Marker(
                              width: 100.0,
                              height: 100.0,
                              point: LatLng(lat, lng),
                              child: GestureDetector(
                                onTap: () {
                                  _showStationDetailsDialog(
                                    context,
                                    stationName,
                                    lat,
                                    lng,
                                    stationType,
                                    station,
                                  );
                                },
                                child: Column(
                                  children: [
                                    Icon(
                                      stationType == "EV"
                                          ? Icons.ev_station
                                          : Icons.local_gas_station,
                                      color:
                                          stationType == "EV"
                                              ? Colors.green
                                              : Colors.red,
                                      size: 40.0,
                                    ),
                                    Text(
                                      stationName,
                                      style: const TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ],
                      ),
                    ],
                  ),
                ),
                // Zoom controls
                Positioned(
                  bottom: 140,
                  right: 16,
                  child: Column(
                    children: [
                      FloatingActionButton(
                        heroTag: 'zoom_in',
                        mini: true,
                        backgroundColor: Colors.deepPurple,
                        onPressed: () {
                          setState(() {
                            _zoomLevel = (_zoomLevel + 1).clamp(2.0, 18.0);
                            _mapController.move(_mapCenter, _zoomLevel);
                          });
                        },
                        child: const Icon(Icons.zoom_in),
                      ),
                      const SizedBox(height: 10),
                      FloatingActionButton(
                        heroTag: 'zoom_out',
                        mini: true,
                        backgroundColor: Colors.deepPurple,
                        onPressed: () {
                          setState(() {
                            _zoomLevel = (_zoomLevel - 1).clamp(2.0, 18.0);
                            _mapController.move(_mapCenter, _zoomLevel);
                          });
                        },
                        child: const Icon(Icons.zoom_out),
                      ),
                    ],
                  ),
                ),
                // Add station button
                Positioned(
                  bottom: 16,
                  right: 16,
                  child: FloatingActionButton(
                    heroTag: 'add_station',
                    backgroundColor: Colors.blueAccent,
                    onPressed: () {
                      _addStationDialog(context, _mapCenter);
                    },
                    child: const Icon(Icons.add),
                  ),
                ),
              ],
            );
          } else if (state is EVError) {
            return Center(child: Text('Error: ${state.message}'));
          }

          return const Center(child: Text('Unknown state'));
        },
      ),
    );
  }

  void _addStationDialog(BuildContext context, LatLng position) {
    TextEditingController nameController = TextEditingController();
    TextEditingController speedController = TextEditingController();
    String? selectedType;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Colors.grey[900],
              title: const Text(
                'Add Station',
                style: TextStyle(color: Colors.white),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameController,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: 'Station Name',
                        labelStyle: TextStyle(color: Colors.grey),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                      ),
                    ),
                    TextField(
                      controller: speedController,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: 'Charging Speed',
                        labelStyle: TextStyle(color: Colors.grey),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      dropdownColor: Colors.grey[800],
                      decoration: const InputDecoration(
                        labelText: 'Station Type',
                        labelStyle: TextStyle(color: Colors.grey),
                      ),
                      value: selectedType,
                      items: const [
                        DropdownMenuItem(
                          value: "EV",
                          child: Text(
                            "EV charging",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        DropdownMenuItem(
                          value: "Gas",
                          child: Text(
                            "Gas station",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                      onChanged: (String? value) {
                        setState(() {
                          selectedType = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    if (selectedType != null &&
                        nameController.text.isNotEmpty) {
                      context.read<EVBloc>().add(
                        AddStationEvent(
                          x: position.latitude,
                          y: position.longitude,
                          name: nameController.text,
                          speed: speedController.text,
                          type: selectedType!,
                          available: true,
                        ),
                      );
                      Navigator.of(context).pop();
                      ErrorHandler.showSuccessSnackbar(
                        context,
                        'Station added successfully!',
                      );
                    } else {
                      ErrorHandler.showWarningSnackbar(
                        context,
                        'Please fill in all required fields',
                      );
                    }
                  },
                  child: const Text(
                    'Add',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showStationDetailsDialog(
    BuildContext context,
    String name,
    double lat,
    double lng,
    String type,
    Map<String, dynamic> station,
  ) {
    double? distance;
    if (_userLocation != null) {
      distance = LocationService.calculateDistance(
        _userLocation!,
        LatLng(lat, lng),
      );
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[900],
          title: Text(name, style: const TextStyle(color: Colors.white)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Type: $type', style: const TextStyle(color: Colors.white)),
              if (station['speed'] != null &&
                  station['speed'].toString().isNotEmpty)
                Text(
                  'Speed: ${station['speed']}',
                  style: const TextStyle(color: Colors.white),
                ),
              Text(
                'Available: ${station['available'] == true ? 'Yes' : 'No'}',
                style: TextStyle(
                  color:
                      station['available'] == true ? Colors.green : Colors.red,
                ),
              ),
              if (distance != null)
                Text(
                  'Distance: ${distance.toStringAsFixed(1)} km',
                  style: const TextStyle(color: Colors.blueAccent),
                ),
              const SizedBox(height: 8),
              Text(
                'Latitude: ${lat.toStringAsFixed(6)}',
                style: const TextStyle(color: Colors.grey),
              ),
              Text(
                'Longitude: ${lng.toStringAsFixed(6)}',
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
}
