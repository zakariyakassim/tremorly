import 'package:equatable/equatable.dart';
import '../../models/crime.dart';

abstract class CrimeState extends Equatable {
  const CrimeState();

  @override
  List<Object> get props => [];
}

class CrimeInitial extends CrimeState {
  const CrimeInitial();
}

class CrimeLoading extends CrimeState {
  const CrimeLoading();
}

class CrimeLoaded extends CrimeState {
  final List<Crime> crimes;
  final Map<String, int> summary;

  const CrimeLoaded(this.crimes, this.summary);

  String get month {
    final months =
        crimes
            .map((crime) => crime.month)
            .where((month) => month.isNotEmpty)
            .toList()
          ..sort();
    return months.isEmpty ? '' : months.last;
  }

  @override
  List<Object> get props => [crimes, summary];
}

class CrimeError extends CrimeState {
  final String message;

  const CrimeError(this.message);

  @override
  List<Object> get props => [message];
}
