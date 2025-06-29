import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

// Define the events
abstract class Event extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchStationsEvent extends Event {}

class AddStationEvent extends Event {
  final double x;
  final double y;
  final String name;
  final String speed;
  final bool available;
  final String type;

  AddStationEvent({
    required this.x,
    required this.y,
    required this.name,
    required this.speed,
    required this.available,
    required this.type,
  });

  @override
  List<Object> get props => [x, y, name, speed, available, type];
}

class DeleteStationEvent extends Event {
  final String stationId;

  DeleteStationEvent(this.stationId);

  @override
  List<Object> get props => [stationId];
}

// Define the states
abstract class EVState extends Equatable {
  @override
  List<Object> get props => [];
}

class EVLoading extends EVState {}

class EVStationsLoaded extends EVState {
  final List<Map<String, dynamic>> stations;

  EVStationsLoaded(this.stations);

  @override
  List<Object> get props => [stations];
}

class EVError extends EVState {
  final String message;

  EVError(this.message);

  @override
  List<Object> get props => [message];
}

// Define the BLoC
class EVBloc extends Bloc<Event, EVState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  EVBloc() : super(EVLoading()) {
    on<FetchStationsEvent>((event, emit) async {
      await _fetchStations(emit);
    });

    on<AddStationEvent>((event, emit) async {
      await _addStation(
        event.x,
        event.y,
        event.name,
        event.speed,
        event.available,
        event.type,
        emit,
      );
    });

    on<DeleteStationEvent>((event, emit) async {
      await _deleteStation(event.stationId, emit);
    });
  }

  // Sample data for when Firestore access is denied
  List<Map<String, dynamic>> _getSampleStations() {
    return [
      {
        'id': 'sample_1',
        'x': 30.0444, // Cairo latitude
        'y': 31.2357, // Cairo longitude
        'name': 'Cairo EV Station',
        'speed': 'Fast (50kW)',
        'available': true,
        'type': 'EV',
      },
      {
        'id': 'sample_2',
        'x': 30.0626,
        'y': 31.2497,
        'name': 'Downtown Gas Station',
        'speed': 'Standard',
        'available': true,
        'type': 'Gas',
      },
      {
        'id': 'sample_3',
        'x': 30.0330,
        'y': 31.2336,
        'name': 'Zamalek EV Hub',
        'speed': 'Ultra Fast (150kW)',
        'available': false,
        'type': 'EV',
      },
      {
        'id': 'sample_4',
        'x': 30.0254,
        'y': 31.2231,
        'name': 'Nile City Gas',
        'speed': 'Standard',
        'available': true,
        'type': 'Gas',
      },
      {
        'id': 'sample_5',
        'x': 30.0735,
        'y': 31.2805,
        'name': 'Heliopolis EV Center',
        'speed': 'Fast (75kW)',
        'available': true,
        'type': 'EV',
      },
    ];
  }

  Future<void> _fetchStations(Emitter<EVState> emit) async {
    try {
      emit(EVLoading());
      QuerySnapshot snapshot = await _firestore.collection('stations').get();
      List<Map<String, dynamic>> stations =
          snapshot.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return {
              'id': doc.id,
              'x': data['x'] ?? 0.0, // Latitude
              'y': data['y'] ?? 0.0, // Longitude
              'name': data['name'] ?? 'Unknown Station',
              'speed': data['speed'] ?? 'Unknown Speed',
              'available': data['available'] ?? false,
              'type': data['type'] ?? 'Unknown',
            };
          }).toList();
      emit(EVStationsLoaded(stations));
    } catch (e) {
      // If Firestore access is denied, use sample data
      print('Firestore access denied, using sample data: $e');
      final sampleStations = _getSampleStations();
      emit(EVStationsLoaded(sampleStations));
    }
  }

  Future<void> _addStation(
    double x,
    double y,
    String name,
    String speed,
    bool available,
    String type,
    Emitter<EVState> emit,
  ) async {
    try {
      await _firestore.collection('stations').add({
        'x': x, // Latitude
        'y': y, // Longitude
        'name': name,
        'speed': speed,
        'available': available,
        'type': type,
      });

      // Fetch updated stations
      await _fetchStations(emit);
    } catch (e) {
      emit(
        EVError(
          'Error adding station: $e. Note: Demo mode - changes won\'t persist.',
        ),
      );
    }
  }

  Future<void> _deleteStation(String stationId, Emitter<EVState> emit) async {
    try {
      await _firestore.collection('stations').doc(stationId).delete();
      // Fetch updated stations
      await _fetchStations(emit);
    } catch (e) {
      emit(
        EVError(
          'Error deleting station: $e. Note: Demo mode - changes won\'t persist.',
        ),
      );
    }
  }
}
