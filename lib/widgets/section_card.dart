import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';

class SectionCard extends StatelessWidget {
  final Widget child;

  const SectionCard({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return FCard(child: child);
  }
}
