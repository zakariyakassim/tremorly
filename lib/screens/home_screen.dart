import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/postcode_search.dart';
import '../widgets/crime_summary.dart';
import '../widgets/crime_list.dart';
import '../services/crime_service.dart';
import '../services/postcode_service.dart';
import '../bloc/crime_bloc.dart';
import '../bloc/crime_event.dart';
import '../bloc/postcode_bloc.dart';
import '../bloc/postcode_state.dart';

/// Home screen for the crime tracker app
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => PostcodeBloc(postcodeService: PostcodeService()),
        ),
        BlocProvider(
          create: (context) => CrimeBloc(crimeService: CrimeService()),
        ),
      ],
      child: const _HomeScreenView(),
    );
  }
}

class _HomeScreenView extends StatelessWidget {
  const _HomeScreenView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Crime Tracker')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const PostcodeSearch(),
              BlocListener<PostcodeBloc, PostcodeState>(
                listener: (context, state) {
                  if (state is PostcodeValid) {
                    context.read<CrimeBloc>().add(
                      FetchCrimesEvent(
                        state.postcode.latitude,
                        state.postcode.longitude,
                      ),
                    );
                  }
                },
                child: BlocBuilder<PostcodeBloc, PostcodeState>(
                  builder: (context, state) {
                    if (state is PostcodeValid) {
                      return Column(
                        children: [
                          const SizedBox(height: 24),
                          const CrimeSummary(),
                          const SizedBox(height: 24),
                          const CrimeList(),
                        ],
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
