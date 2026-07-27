import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import '../theme/app_spacing.dart';
import 'section_card.dart';

class CrimeLoadingPanel extends StatelessWidget {
  const CrimeLoadingPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return SectionCard(
      child: Column(
        children: [
          const FCircularProgress(
            size: FCircularProgressSizeVariant.lg,
            semanticsLabel: 'Loading nearby crime data',
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Loading nearby incidents…',
            style: theme.typography.sm.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: AppSpacing.sm),
          const FProgress(semanticsLabel: 'Loading crime data'),
        ],
      ),
    );
  }
}

class CrimeErrorPanel extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const CrimeErrorPanel({
    required this.message,
    required this.onRetry,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FAlert(
          variant: .destructive,
          icon: const Icon(Iconsax.danger),
          title: const Text('Crime data could not be loaded'),
          subtitle: Text(message),
        ),
        const SizedBox(height: AppSpacing.md),
        Align(
          alignment: Alignment.centerLeft,
          child: FButton(
            key: const Key('crime-retry-button'),
            variant: .outline,
            mainAxisSize: MainAxisSize.min,
            onPress: onRetry,
            prefix: const Icon(Iconsax.refresh_2),
            child: const Text('Try again'),
          ),
        ),
      ],
    );
  }
}

class CrimeEmptyPanel extends StatelessWidget {
  final VoidCallback onRetry;

  const CrimeEmptyPanel({required this.onRetry, super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return SectionCard(
      child: Center(
        child: Column(
          children: [
            Icon(
              Iconsax.direct_inbox,
              size: theme.typography.xl3.fontSize,
              color: theme.colors.mutedForeground,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'No incidents were returned',
              style: theme.typography.lg.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'The latest dataset may contain no records for this area.',
              textAlign: TextAlign.center,
              style: theme.typography.xs.copyWith(
                color: theme.colors.mutedForeground,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            FButton(
              variant: .outline,
              mainAxisSize: MainAxisSize.min,
              onPress: onRetry,
              prefix: const Icon(Iconsax.refresh_2),
              child: const Text('Refresh data'),
            ),
          ],
        ),
      ),
    );
  }
}
