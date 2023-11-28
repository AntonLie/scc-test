import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:scc_web/theme/colors.dart';

class OverlayContentMap extends StatefulWidget {
  const OverlayContentMap({super.key});

  @override
  State<OverlayContentMap> createState() => _OverlayContentMapState();
}

class _OverlayContentMapState extends State<OverlayContentMap> {
  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
        child: Align(
      alignment: Alignment.center,
      child: Container(
        width: 220.0,
        height: 200.0,
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 8,
              offset: const Offset(0, 3),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              MdiIcons.fromString("truckAlert"),
              color: sccPrimaryDashboard,
              size: 80,
            ),
            const Text(
              "Choose Your",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: sccPrimaryDashboard,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600),
            ),
            const Text("Business Process!",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: sccPrimaryDashboard,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    ));
  }
}
