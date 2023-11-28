import 'package:flutter/material.dart';
import 'package:scc_web/helper/app_scale.dart';
import 'package:scc_web/helper/constant.dart';

class OverlayArrowMap extends StatefulWidget {
  const OverlayArrowMap({super.key});

  @override
  State<OverlayArrowMap> createState() => _OverlayArrowMapState();
}

class _OverlayArrowMapState extends State<OverlayArrowMap> {
  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
        top: 10.0,
        left: context.deviceWidth() >= 1920 ? 500.0 : 380.0,
        child: const Align(
          alignment: Alignment.topLeft,
          child: SizedBox(
            width: 150.0,
            height: 280.0,
            child: Image(image: AssetImage(Constant.arrowBusiness)),
          ),
        ));
  }
}
