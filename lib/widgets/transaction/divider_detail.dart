import 'package:flutter/material.dart';
import 'package:scc_web/theme/colors.dart';

class DividerDetail extends StatefulWidget {
  const DividerDetail({super.key});

  @override
  State<DividerDetail> createState() => _DividerDetailState();
}

class _DividerDetailState extends State<DividerDetail> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 50.0,
        ),
        Divider(height: 1, color: sccMapZoomSeperator.withOpacity(0.1)),
        const SizedBox(
          height: 50.0,
        ),
      ],
    );
  }
}
