import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/crime_bloc.dart';
import '../bloc/crime_state.dart';

/// Widget displaying a list of crimes for a postcode
class CrimeList extends StatelessWidget {
  const CrimeList({super.key});

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
          final crimes = state.crimes;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Crimes (${crimes.length})',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              if (crimes.isEmpty)
                const Text('No crimes found')
              else
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: crimes.length,
                  separatorBuilder: (_, __) => const Divider(),
                  itemBuilder: (context, index) {
                    final crime = crimes[index];
                    return ListTile(
                      title: Text(crime.category),
                      subtitle: Text(crime.streetName),
                      trailing: Text(crime.month),
                    );
                  },
                ),
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
