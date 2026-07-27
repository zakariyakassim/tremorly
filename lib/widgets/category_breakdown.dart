import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';
import '../theme/app_spacing.dart';
import '../utils/crime_formatters.dart';
import 'section_card.dart';

class CategoryBreakdown extends StatelessWidget {
  final Map<String, int> summary;

  const CategoryBreakdown({required this.summary, super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final entries = summary.entries.toList()
      ..sort((a, b) {
        final byCount = b.value.compareTo(a.value);
        return byCount == 0 ? a.key.compareTo(b.key) : byCount;
      });
    final maximum = entries.fold<int>(
      1,
      (value, entry) => math.max(value, entry.value),
    );

    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Category breakdown',
            style: theme.typography.lg.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Reported incidents grouped by Police API category.',
            style: theme.typography.xs.copyWith(
              color: theme.colors.mutedForeground,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          for (final entry in entries) ...[
            Row(
              children: [
                Expanded(
                  child: Text(
                    formatCrimeCategory(entry.key),
                    style: theme.typography.xs,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                FBadge(variant: .secondary, child: Text('${entry.value}')),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),
            FDeterminateProgress(
              value: entry.value / maximum,
              semanticsLabel:
                  '${formatCrimeCategory(entry.key)}: ${entry.value}',
            ),
            const SizedBox(height: AppSpacing.md),
          ],
        ],
      ),
    );
  }
}
