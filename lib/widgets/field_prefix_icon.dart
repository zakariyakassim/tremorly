import 'package:flutter/widgets.dart';
import '../theme/app_spacing.dart';

class FieldPrefixIcon extends StatelessWidget {
  final IconData icon;
  final Color? color;

  const FieldPrefixIcon(this.icon, {this.color, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(
        start: AppSpacing.md,
        end: AppSpacing.xs,
      ),
      child: Icon(icon, color: color),
    );
  }
}
