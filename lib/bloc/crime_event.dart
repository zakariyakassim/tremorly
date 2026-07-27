import 'package:equatable/equatable.dart';

abstract class CrimeEvent extends Equatable {
  const CrimeEvent();

  @override
  List<Object> get props => [];
}

class FetchCrimesEvent extends CrimeEvent {
  final double latitude;
  final double longitude;

  const FetchCrimesEvent(this.latitude, this.longitude);

  @override
  List<Object> get props => [latitude, longitude];
}
