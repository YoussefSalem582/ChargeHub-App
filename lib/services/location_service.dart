import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'error_handler.dart';

class LocationService {
  static const double _defaultLatitude = 30.0444; // Cairo
  static const double _defaultLongitude = 31.2357;

  /// Get the current location of the user
  static Future<LatLng?> getCurrentLocation() async {
    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw AppError(
          message:
              'Location services are disabled. Please enable location services.',
          type: ErrorType.location,
        );
      }

      // Check location permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw AppError(
            message: 'Location permissions are denied.',
            type: ErrorType.location,
          );
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw AppError(
          message:
              'Location permissions are permanently denied. Please enable them in app settings.',
          type: ErrorType.location,
        );
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );

      return LatLng(position.latitude, position.longitude);
    } catch (e) {
      // Return null on error, calling code can handle it
      return null;
    }
  }

  /// Get default location (Cairo)
  static LatLng getDefaultLocation() {
    return const LatLng(_defaultLatitude, _defaultLongitude);
  }

  /// Calculate distance between two points in kilometers
  static double calculateDistance(LatLng point1, LatLng point2) {
    return Geolocator.distanceBetween(
          point1.latitude,
          point1.longitude,
          point2.latitude,
          point2.longitude,
        ) /
        1000; // Convert meters to kilometers
  }

  /// Check if location services are available
  static Future<bool> isLocationServiceAvailable() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return false;

      LocationPermission permission = await Geolocator.checkPermission();
      return permission != LocationPermission.denied &&
          permission != LocationPermission.deniedForever;
    } catch (e) {
      return false;
    }
  }

  /// Request location permission
  static Future<bool> requestLocationPermission() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      return permission != LocationPermission.denied &&
          permission != LocationPermission.deniedForever;
    } catch (e) {
      return false;
    }
  }

  /// Get location with timeout and error handling
  static Future<LatLng> getCurrentLocationWithFallback() async {
    try {
      LatLng? location = await getCurrentLocation();
      return location ?? getDefaultLocation();
    } catch (e) {
      return getDefaultLocation();
    }
  }

  /// Open app settings for location permissions
  static Future<bool> openAppSettings() async {
    return await Geolocator.openAppSettings();
  }

  /// Open location settings
  static Future<bool> openLocationSettings() async {
    return await Geolocator.openLocationSettings();
  }
}
