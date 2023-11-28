import 'package:flutter/material.dart';
import 'package:scc_web/theme/colors.dart';

class FilterDivider extends StatefulWidget {
  const FilterDivider({super.key});

  @override
  State<FilterDivider> createState() => _FilterDividerState();
}

class _FilterDividerState extends State<FilterDivider> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 10.0,
        ),
        Divider(height: 1, color: sccMapZoomSeperator.withOpacity(0.1)),
        const SizedBox(
          height: 10.0,
        ),
      ],
    );
  }
}
