import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../bloc/logic.dart';
import 'cars/cars.dart';
import 'evHomePage.dart';
import 'splachScreen.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  double _zoomLevel = 13.0; // Initial zoom level for the map
  final LatLng _mapCenter =
      const LatLng(30.0444, 31.2357); // Initial map center (Cairo)
  late MapController _mapController; // For controlling the map programmatically

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    // Fetch stations when the screen is initialized
    context.read<EVBloc>().add(FetchStationsEvent());
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
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const HomePage(username: 'back to HomePage',)
                , // Navigate to CarGalleryPage
              ),
            ); // Go back to the previous page
          },
        ),
        backgroundColor: Colors.deepPurple,
        actions: [
          PopupMenuButton<String>(
            color: const Color.fromRGBO(31, 2, 75, 0.6),
            icon: const Icon(Icons.menu, color: Colors.white),
            onSelected: (value) {
              switch (value) {
                case 'Map':
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => MapScreen(),
                    ),
                  );
                  break;
                case 'Cars':
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => carGalleryPage(),
                    ),
                  );
                  break;
                case 'Log out':
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          SplashScreen(), // Replace with your actual SignupPage class
                    ),
                  );
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem<String>(
                value: 'Map',
                child: Text('Map',
                    style: TextStyle(color: Colors.white)), // Black text
              ),
              const PopupMenuItem<String>(
                value: 'Cars',
                child: Text('Cars',
                    style: TextStyle(color: Colors.white)), // Black text
              ),
              const PopupMenuItem<String>(
                value: 'Log out',
                child: Text('Log out ',
                    style: TextStyle(color: Colors.white)), // Black text
              ),
            ],
          ),
        ],
      ),
      body: BlocBuilder<EVBloc, EVState>(
        builder: (context, state) {
          if (state is EVLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is EVStationsLoaded) {
            final stations = state.stations;

            return Stack(
              children: [
                // Flutter map
                FlutterMap(
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
                      markers: stations.map((station) {
                        double lat =
                            station['x'] ?? 0.0; // Use 'x' for latitude
                        double lng =
                            station['y'] ?? 0.0; // Use 'y' for longitude
                        String stationName =
                            station['name'] ?? 'Unknown Station';
                        String stationType = station['type'] ?? 'Unknown';

                        // Refactored to use _StationMarkerWidget
                        return Marker(
                          width: 100.0, // Adjusted size for better visibility
                          height: 100.0,
                          point: LatLng(lat, lng),
                          child: _StationMarkerWidget(
                            icon: stationType == "EV"
                                ? Icons.ev_station
                                : Icons.local_gas_station,
                            color:
                                stationType == "EV" ? Colors.green : Colors.red,
                            stationName: stationName,
                            latitude: lat,
                            longitude: lng,
                            onTap: () {
                              _showStationDetailsDialog(
                                  context, stationName, lat, lng, stationType);
                            },
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
                // Zoom in/out buttons at the bottom right corner
                Positioned(
                  bottom: 80, // Place it above the add station button
                  right: 16, // Align to the right
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
                // Add Station button at the bottom right corner
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
    // Text editing controllers for additional fields
    TextEditingController nameController = TextEditingController();
    TextEditingController speedController = TextEditingController();

    // Initialize dropdown selection for station type
    String? selectedType;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[900], // Dark background
          title: const Text(
            'Add Station',
            style: TextStyle(color: Colors.white), // White text
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Text fields for station details
                TextField(
                  controller: nameController,
                  style: const TextStyle(color: Colors.white),
                  // White text input
                  decoration: const InputDecoration(
                    labelText: 'Station Name',
                    labelStyle: TextStyle(color: Colors.grey), // Label color
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
                  // White text input
                  decoration: const InputDecoration(
                    labelText: 'Charging Speed',
                    labelStyle: TextStyle(color: Colors.grey), // Label color
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                  ),
                ),
                // Dropdown for station type
                DropdownButtonFormField<String>(
                  dropdownColor: Colors.grey[800],
                  // Dark background for dropdown
                  decoration: const InputDecoration(
                    labelText: 'Station Type',
                    labelStyle: TextStyle(color: Colors.grey), // Label color
                  ),
                  value: selectedType,
                  items: const [
                    DropdownMenuItem(
                      value: "EV",
                      child: Text("EV charging",
                          style: TextStyle(color: Colors.white)),
                    ),
                    DropdownMenuItem(
                      value: "Gas",
                      child: Text("Gas station",
                          style: TextStyle(color: Colors.white)),
                    ),
                  ],
                  onChanged: (String? value) {
                    setState(() {
                      selectedType = value!;
                    });
                  },
                  validator: (value) =>
                      value == null ? 'Please select a type' : null,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child:
                  const Text('Cancel', style: TextStyle(color: Colors.white)),
            ),
            TextButton(
              onPressed: () {
                // Ensure station type is selected before proceeding
                if (selectedType != null) {
                  // Dispatch AddStationEvent with position from the map
                  context.read<EVBloc>().add(AddStationEvent(
                        x: position.latitude,
                        y: position.longitude,
                        name: nameController.text,
                        speed: speedController.text,
                        type: selectedType!,
                        available: true, // Set available to true by default
                      ));
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Add', style: TextStyle(color: Colors.blue)),
            ),
          ],
        );
      },
    );
  }

  // void _confirmDeleteStation(BuildContext context, String stationId,
  //     String stationName, double lat, double lng) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: const Text('Station Details'),
  //         content: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             Text('Name: $stationName'),
  //             const SizedBox(height: 8),
  //             Text('Latitude: $lat'),
  //             Text('Longitude: $lng'),
  //             const SizedBox(height: 16),
  //             const Text('Do you want to delete this station or visit?'),
  //           ],
  //         ),
  //         actions: [
  //           TextButton(
  //             onPressed: () {
  //               _launchUrl(lat, lng); // Open Google Maps
  //             },
  //             child: const Text('Visit'),
  //           ),
  //           TextButton(
  //             onPressed: () {
  //               context.read<EVBloc>().add(DeleteStationEvent(stationId));
  //               Navigator.of(context).pop(); // Close the dialog
  //             },
  //             child: const Text('Delete'),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  // Function to launch Google Maps for a specific location
  // void _launchUrl(double lat, double lng) async {
  //   final String googleMapsUrl =
  //       'https://www.google.com/maps/search/?api=1&query=$lat,$lng';
  //
  //   if (await canLaunch(googleMapsUrl)) {
  //     await launch(googleMapsUrl);
  //   } else {
  //     throw 'Could not launch $googleMapsUrl';
  //   }
  // }

  // Add the missing method here
  void _showStationDetailsDialog(
      BuildContext context, String name, double lat, double lng, String type) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[900], // Dark background
          title: Text(
            name,
            style: const TextStyle(color: Colors.white), // White text for title
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Type: $type', style: const TextStyle(color: Colors.white)),
              // White text
              Text('Latitude: $lat',
                  style: const TextStyle(color: Colors.white)),
              // White text
              Text('Longitude: $lng',
                  style: const TextStyle(color: Colors.white)),
              // White text
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

// Custom widget for displaying station markers
class _StationMarkerWidget extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String stationName;
  final double latitude;
  final double longitude;
  final VoidCallback onTap;

  const _StationMarkerWidget({
    required this.icon,
    required this.color,
    required this.stationName,
    required this.latitude,
    required this.longitude,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // Make the marker clickable
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: 50.0, // Adjusted size for better visibility
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 2,
                  offset: Offset(0, 1),
                ),
              ],
            ),
            child: Text(
              stationName,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
