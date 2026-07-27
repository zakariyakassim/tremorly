import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import '../theme/app_palette.dart';
import '../theme/app_spacing.dart';
import 'section_card.dart';

class ExplorerIntro extends StatelessWidget {
  const ExplorerIntro({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final palette = AppPalette.of(context);

    return SectionCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: palette.infoSurface,
              borderRadius: theme.style.borderRadius.md,
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.sm),
              child: Icon(Iconsax.map, color: palette.info),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Explore reported crime near any UK postcode',
                  style: theme.typography.xl.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Validate a postcode, review the latest available monthly '
                  'totals, and filter incidents reported nearby.',
                  style: theme.typography.sm.copyWith(
                    color: theme.colors.mutedForeground,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
