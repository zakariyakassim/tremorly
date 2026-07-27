import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import '../theme/app_spacing.dart';

class ThemeModeSwitch extends StatelessWidget {
  final ValueChanged<bool>? onChanged;

  const ThemeModeSwitch({required this.onChanged, super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.theme.colors.brightness == Brightness.dark;

    return FSwitch(
      key: const Key('theme-mode-switch'),
      leadingLabel: true,
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(isDark ? Iconsax.moon : Iconsax.sun),
          const SizedBox(width: AppSpacing.xs),
          const Text('Dark mode'),
        ],
      ),
      semanticsLabel: 'Dark mode',
      value: isDark,
      onChange: onChanged,
      enabled: onChanged != null,
    );
  }
}
