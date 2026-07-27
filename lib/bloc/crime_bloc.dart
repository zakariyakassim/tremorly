import 'package:bloc/bloc.dart';
import '../services/crime_service.dart';
import 'crime_event.dart';
import 'crime_state.dart';

class CrimeBloc extends Bloc<CrimeEvent, CrimeState> {
  final CrimeService crimeService;

  CrimeBloc({required this.crimeService}) : super(const CrimeInitial()) {
    on<FetchCrimesEvent>(_onFetchCrimes);
  }

  Future<void> _onFetchCrimes(
    FetchCrimesEvent event,
    Emitter<CrimeState> emit,
  ) async {
    emit(const CrimeLoading());
    try {
      final crimes = await crimeService.getCrimesByCoordinates(
        event.latitude,
        event.longitude,
      );
      final summary = await crimeService.getCrimeSummary(
        event.latitude,
        event.longitude,
      );
      emit(CrimeLoaded(crimes, summary));
    } catch (e) {
      emit(CrimeError(e.toString()));
    }
  }
}
