import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'theme/app_palette.dart';
import 'theme/theme.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void _setDarkMode(bool enabled) {
    setState(() => _themeMode = enabled ? ThemeMode.dark : ThemeMode.light);
  }

  @override
  Widget build(BuildContext context) {
    final lightTheme = neutralLight.toApproximateMaterialTheme();
    final darkTheme = neutralDark.toApproximateMaterialTheme();

    return MaterialApp(
      title: 'Neighbourhood Crime Explorer',
      debugShowCheckedModeBanner: false,
      theme: lightTheme.copyWith(
        extensions: const <ThemeExtension<dynamic>>[AppPalette.light],
      ),
      darkTheme: darkTheme.copyWith(
        extensions: const <ThemeExtension<dynamic>>[AppPalette.dark],
      ),
      themeMode: _themeMode,
      builder: (context, child) => FTheme(
        data: Theme.brightnessOf(context) == Brightness.light
            ? neutralLight
            : neutralDark,
        child: FToaster(
          child: FTooltipGroup(child: child ?? const SizedBox.shrink()),
        ),
      ),
      home: HomeScreen(onThemeChanged: _setDarkMode),
    );
  }
}
