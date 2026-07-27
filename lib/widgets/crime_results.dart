import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forui/forui.dart';
import '../blocs/crime/crime_bloc.dart';
import '../blocs/crime/crime_event.dart';
import '../blocs/crime/crime_state.dart';
import '../models/postcode.dart';
import '../theme/app_spacing.dart';
import 'category_breakdown.dart';
import 'crime_list.dart';
import 'crime_state_panel.dart';
import 'crime_summary.dart';
import 'data_disclaimer.dart';

class CrimeResults extends StatelessWidget {
  final Postcode postcode;

  const CrimeResults({required this.postcode, super.key});

  void _retry(BuildContext context) {
    context.read<CrimeBloc>().add(
      FetchCrimesEvent(postcode.latitude, postcode.longitude),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CrimeBloc, CrimeState>(
      builder: (context, state) {
        if (state is CrimeLoading) {
          return const CrimeLoadingPanel();
        }
        if (state is CrimeError) {
          return CrimeErrorPanel(
            message: state.message,
            onRetry: () => _retry(context),
          );
        }
        if (state is CrimeLoaded) {
          if (state.crimes.isEmpty) {
            return CrimeEmptyPanel(onRetry: () => _retry(context));
          }
          return _LoadedResults(postcode: postcode, data: state);
        }
        return const SizedBox.shrink();
      },
    );
  }
}

class _LoadedResults extends StatelessWidget {
  final Postcode postcode;
  final CrimeLoaded data;

  const _LoadedResults({required this.postcode, required this.data});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CrimeSummary(postcode: postcode, data: data),
        const SizedBox(height: AppSpacing.lg),
        LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth < context.theme.breakpoints.lg) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CategoryBreakdown(summary: data.summary),
                  const SizedBox(height: AppSpacing.lg),
                  CrimeList(crimes: data.crimes),
                ],
              );
            }
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: constraints.maxWidth * 0.34,
                  child: CategoryBreakdown(summary: data.summary),
                ),
                const SizedBox(width: AppSpacing.lg),
                Expanded(child: CrimeList(crimes: data.crimes)),
              ],
            );
          },
        ),
        const SizedBox(height: AppSpacing.lg),
        const DataDisclaimer(),
      ],
    );
  }
}
