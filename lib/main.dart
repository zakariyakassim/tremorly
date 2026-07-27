import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'theme/theme.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: neutralLight.toApproximateMaterialTheme(),
      darkTheme: neutralDark.toApproximateMaterialTheme(),
      builder: (context, child) => FTheme(
        data: Theme.brightnessOf(context) == Brightness.light
            ? neutralLight
            : neutralDark,
        child: FToaster(child: FTooltipGroup(child: child!)),
      ),
      home: const HomeScreen(),
    );
  }
}
