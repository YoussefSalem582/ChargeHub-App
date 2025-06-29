// ev_state.dart
abstract class evState {}

class evInitial extends evState {}

class evLoading extends evState {}

class evFetchSuccess extends evState {
  final List<Map<String, dynamic>> stations;

  evFetchSuccess(this.stations);
}

class evError extends evState {
  final String error;

  evError(this.error);
}
