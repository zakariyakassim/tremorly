import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/crime_bloc.dart';
import '../bloc/crime_state.dart';

/// Widget displaying crime statistics summary
class CrimeSummary extends StatelessWidget {
  const CrimeSummary({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CrimeBloc, CrimeState>(
      builder: (context, state) {
        if (state is CrimeLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is CrimeError) {
          return Center(child: Text('Error: ${state.message}'));
        }

        if (state is CrimeLoaded) {
          final summary = state.summary;

          return Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Crime Summary',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  if (summary.isEmpty)
                    const Text('No crime data available')
                  else
                    ...summary.entries.map(
                      (entry) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(entry.key),
                            Text(
                              '${entry.value}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
