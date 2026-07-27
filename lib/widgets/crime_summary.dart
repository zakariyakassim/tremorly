import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import '../blocs/crime/crime_state.dart';
import '../models/postcode.dart';
import '../theme/app_palette.dart';
import '../theme/app_spacing.dart';
import '../utils/crime_formatters.dart';
import 'section_card.dart';

class CrimeSummary extends StatelessWidget {
  final Postcode postcode;
  final CrimeLoaded data;

  const CrimeSummary({required this.postcode, required this.data, super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      _SummaryItem(
        label: 'Postcode',
        value: postcode.postcode,
        icon: Iconsax.location,
        tone: _SummaryTone.info,
      ),
      _SummaryItem(
        label: 'Month',
        value: formatCrimeMonth(data.month),
        icon: Iconsax.calendar,
        tone: _SummaryTone.highlight,
      ),
      _SummaryItem(
        label: 'Total incidents',
        value: '${data.crimes.length}',
        icon: Iconsax.filter,
        tone: _SummaryTone.warning,
      ),
      _SummaryItem(
        label: 'Categories',
        value: '${data.summary.length}',
        icon: Iconsax.chart_2,
        tone: _SummaryTone.success,
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = switch (constraints.maxWidth) {
          >= 900 => 4,
          >= 560 => 2,
          _ => 1,
        };
        final itemWidth =
            (constraints.maxWidth - (AppSpacing.sm * (columns - 1))) / columns;

        return Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            for (final item in items)
              SizedBox(
                width: itemWidth,
                child: _SummaryCard(item: item),
              ),
          ],
        );
      },
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final _SummaryItem item;

  const _SummaryCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final palette = AppPalette.of(context);
    final (foreground, surface) = switch (item.tone) {
      _SummaryTone.info => (palette.info, palette.infoSurface),
      _SummaryTone.success => (palette.success, palette.successSurface),
      _SummaryTone.warning => (palette.warning, palette.warningSurface),
      _SummaryTone.highlight => (palette.highlight, palette.highlightSurface),
    };

    return SectionCard(
      child: Row(
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: surface,
              borderRadius: theme.style.borderRadius.md,
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.sm),
              child: Icon(item.icon, color: foreground),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.label,
                  style: theme.typography.xs.copyWith(
                    color: theme.colors.mutedForeground,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  item.value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.typography.lg.copyWith(
                    fontWeight: FontWeight.w700,
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

class _SummaryItem {
  final String label;
  final String value;
  final IconData icon;
  final _SummaryTone tone;

  const _SummaryItem({
    required this.label,
    required this.value,
    required this.icon,
    required this.tone,
  });
}

enum _SummaryTone { info, success, warning, highlight }
