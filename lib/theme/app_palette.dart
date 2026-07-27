import 'package:flutter/material.dart';

/// App-specific semantic colours that complement the core ForUI theme.
@immutable
class AppPalette extends ThemeExtension<AppPalette> {
  final Color info;
  final Color infoSurface;
  final Color success;
  final Color successSurface;
  final Color warning;
  final Color warningSurface;
  final Color highlight;
  final Color highlightSurface;

  const AppPalette({
    required this.info,
    required this.infoSurface,
    required this.success,
    required this.successSurface,
    required this.warning,
    required this.warningSurface,
    required this.highlight,
    required this.highlightSurface,
  });

  static const light = AppPalette(
    info: Color(0xFF3157D5),
    infoSurface: Color(0xFFE8EEFF),
    success: Color(0xFF087F6D),
    successSurface: Color(0xFFDDF7F1),
    warning: Color(0xFFB54708),
    warningSurface: Color(0xFFFFEED6),
    highlight: Color(0xFF7546C8),
    highlightSurface: Color(0xFFF0E9FF),
  );

  static const dark = AppPalette(
    info: Color(0xFF8CA6FF),
    infoSurface: Color(0xFF1B2948),
    success: Color(0xFF65D6BF),
    successSurface: Color(0xFF12352F),
    warning: Color(0xFFFFBD66),
    warningSurface: Color(0xFF422A14),
    highlight: Color(0xFFC5A8FF),
    highlightSurface: Color(0xFF30234A),
  );

  static AppPalette of(BuildContext context) {
    return Theme.of(context).extension<AppPalette>() ??
        (Theme.brightnessOf(context) == Brightness.dark ? dark : light);
  }

  @override
  AppPalette copyWith({
    Color? info,
    Color? infoSurface,
    Color? success,
    Color? successSurface,
    Color? warning,
    Color? warningSurface,
    Color? highlight,
    Color? highlightSurface,
  }) {
    return AppPalette(
      info: info ?? this.info,
      infoSurface: infoSurface ?? this.infoSurface,
      success: success ?? this.success,
      successSurface: successSurface ?? this.successSurface,
      warning: warning ?? this.warning,
      warningSurface: warningSurface ?? this.warningSurface,
      highlight: highlight ?? this.highlight,
      highlightSurface: highlightSurface ?? this.highlightSurface,
    );
  }

  @override
  AppPalette lerp(covariant AppPalette? other, double t) {
    if (other == null) {
      return this;
    }
    return AppPalette(
      info: Color.lerp(info, other.info, t)!,
      infoSurface: Color.lerp(infoSurface, other.infoSurface, t)!,
      success: Color.lerp(success, other.success, t)!,
      successSurface: Color.lerp(successSurface, other.successSurface, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      warningSurface: Color.lerp(warningSurface, other.warningSurface, t)!,
      highlight: Color.lerp(highlight, other.highlight, t)!,
      highlightSurface: Color.lerp(
        highlightSurface,
        other.highlightSurface,
        t,
      )!,
    );
  }
}
