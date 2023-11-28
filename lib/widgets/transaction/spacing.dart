import 'package:flutter/material.dart';
import 'package:scc_web/theme/colors.dart';

class Spacing extends StatefulWidget {
  const Spacing({super.key});

  @override
  State<Spacing> createState() => _SpacingState();
}

class _SpacingState extends State<Spacing> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 30.0,
        ),
        Divider(height: 1, color: sccMapZoomSeperator.withOpacity(0.1)),
        const SizedBox(
          height: 40.0,
        ),
      ],
    );
  }
}
