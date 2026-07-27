import 'dart:math' as math;

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import '../models/crime.dart';
import '../theme/app_spacing.dart';
import '../utils/crime_formatters.dart';
import 'field_prefix_icon.dart';
import 'section_card.dart';

class CrimeList extends StatefulWidget {
  final List<Crime> crimes;

  const CrimeList({required this.crimes, super.key});

  @override
  State<CrimeList> createState() => _CrimeListState();
}

class _CrimeListState extends State<CrimeList> {
  static const _pageSize = 50;

  final _filterController = TextEditingController();
  String _query = '';
  int _visibleLimit = _pageSize;

  void _handleFilter(TextEditingValue value) {
    setState(() {
      _query = value.text;
      _visibleLimit = _pageSize;
    });
  }

  @override
  void dispose() {
    _filterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final query = _query.trim().toLowerCase();
    final filtered = query.isEmpty
        ? widget.crimes
        : widget.crimes
              .where((crime) {
                return [
                  formatCrimeCategory(crime.category),
                  crime.streetName,
                  crime.outcomeStatus ?? '',
                  formatCrimeMonth(crime.month),
                ].any((value) => value.toLowerCase().contains(query));
              })
              .toList(growable: false);
    final visible = filtered.take(_visibleLimit).toList(growable: false);

    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Nearby incidents',
            style: theme.typography.lg.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Showing ${visible.length} of ${filtered.length} matching incidents',
            key: const Key('incident-count'),
            style: theme.typography.xs.copyWith(
              color: theme.colors.mutedForeground,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          FTextField(
            key: const Key('incident-filter'),
            control: .managed(
              controller: _filterController,
              onChange: _handleFilter,
            ),
            label: const Text('Filter incidents'),
            hint: 'Category, street, outcome or month',
            textInputAction: TextInputAction.search,
            prefixBuilder: (context, style, states) =>
                const FieldPrefixIcon(Iconsax.filter),
          ),
          const SizedBox(height: AppSpacing.lg),
          if (filtered.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
              child: Center(
                child: Column(
                  children: [
                    Icon(
                      Iconsax.search_status,
                      color: theme.colors.mutedForeground,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'No incidents match this filter.',
                      style: theme.typography.sm,
                    ),
                  ],
                ),
              ),
            )
          else ...[
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: visible.length,
              separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
              itemBuilder: (context, index) =>
                  _IncidentRow(crime: visible[index]),
            ),
            if (visible.length < filtered.length) ...[
              const SizedBox(height: AppSpacing.md),
              FButton(
                key: const Key('show-more-incidents'),
                variant: .outline,
                onPress: () => setState(() => _visibleLimit += _pageSize),
                prefix: const Icon(Iconsax.arrow_down_2),
                child: Text(
                  'Show ${math.min(_pageSize, filtered.length - visible.length)} more',
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }
}

class _IncidentRow extends StatelessWidget {
  final Crime crime;

  const _IncidentRow({required this.crime});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.colors.muted,
        borderRadius: theme.style.borderRadius.md,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    formatCrimeCategory(crime.category),
                    style: theme.typography.sm.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                FBadge(
                  variant: .outline,
                  child: Text(formatCrimeMonth(crime.month)),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                Icon(
                  Iconsax.location,
                  size: theme.typography.xs.fontSize,
                  color: theme.colors.mutedForeground,
                ),
                const SizedBox(width: AppSpacing.xs),
                Expanded(
                  child: Text(
                    crime.streetName,
                    style: theme.typography.xs.copyWith(
                      color: theme.colors.mutedForeground,
                    ),
                  ),
                ),
              ],
            ),
            if (crime.outcomeStatus case final outcome?) ...[
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Outcome: $outcome',
                style: theme.typography.xs.copyWith(
                  color: theme.colors.mutedForeground,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
