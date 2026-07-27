import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import '../theme/app_palette.dart';
import '../theme/app_spacing.dart';

class DataDisclaimer extends StatelessWidget {
  const DataDisclaimer({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final palette = AppPalette.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          Iconsax.shield_tick,
          size: theme.typography.sm.fontSize,
          color: palette.success,
        ),
        const SizedBox(width: AppSpacing.xs),
        Expanded(
          child: Text(
            'Data comes from Postcodes.io and the UK Police Data API. '
            'Locations are approximate, reporting can be delayed, and the '
            'figures should not be treated as a complete safety assessment. '
            'In Scotland, only British Transport Police data is available.',
            style: theme.typography.xs.copyWith(
              color: theme.colors.mutedForeground,
            ),
          ),
        ),
      ],
    );
  }
}
