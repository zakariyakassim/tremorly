import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forui/forui.dart';
import '../services/crime_service.dart';
import '../services/postcode_service.dart';
import '../theme/app_spacing.dart';
import '../blocs/crime/crime_bloc.dart';
import '../blocs/crime/crime_event.dart';
import '../blocs/postcode/postcode_bloc.dart';
import '../blocs/postcode/postcode_state.dart';
import '../widgets/crime_results.dart';
import '../widgets/explorer_intro.dart';
import '../widgets/postcode_search.dart';
import '../widgets/theme_mode_switch.dart';

/// Home screen for the crime tracker app
class HomeScreen extends StatelessWidget {
  final PostcodeService? postcodeService;
  final CrimeService? crimeService;
  final ValueChanged<bool>? onThemeChanged;

  const HomeScreen({
    this.postcodeService,
    this.crimeService,
    this.onThemeChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => PostcodeBloc(
            postcodeService: postcodeService ?? PostcodeService(),
          ),
        ),
        BlocProvider(
          create: (context) =>
              CrimeBloc(crimeService: crimeService ?? CrimeService()),
        ),
      ],
      child: _HomeScreenView(onThemeChanged: onThemeChanged),
    );
  }
}

class _HomeScreenView extends StatelessWidget {
  final ValueChanged<bool>? onThemeChanged;

  const _HomeScreenView({this.onThemeChanged});

  @override
  Widget build(BuildContext context) {
    return FScaffold(
      childPad: false,
      header: FHeader(
        title: const SizedBox.shrink(),
        suffixes: [ThemeModeSwitch(onChanged: onThemeChanged)],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final horizontalPadding =
              constraints.maxWidth < context.theme.breakpoints.sm
              ? AppSpacing.md
              : AppSpacing.xl;

          return SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
              horizontalPadding,
              AppSpacing.lg,
              horizontalPadding,
              AppSpacing.xxl,
            ),
            child: Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: AppSpacing.contentMaxWidth,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const ExplorerIntro(),
                    const SizedBox(height: AppSpacing.lg),
                    const PostcodeSearch(),
                    BlocConsumer<PostcodeBloc, PostcodeState>(
                      listenWhen: (previous, current) =>
                          current is PostcodeValid,
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
                      builder: (context, state) {
                        if (state is! PostcodeValid) {
                          return const SizedBox.shrink();
                        }
                        return Padding(
                          padding: const EdgeInsets.only(top: AppSpacing.lg),
                          child: CrimeResults(postcode: state.postcode),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
