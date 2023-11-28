import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';
import 'package:scc_web/helper/app_scale.dart';
import 'package:scc_web/theme/colors.dart';

class ZoomMap extends StatefulWidget {
  const ZoomMap({Key? key}) : super(key: key);
  @override
  State<ZoomMap> createState() => _ZoomMapState();
}

class _ZoomMapState extends State<ZoomMap> {
  @override
  Widget build(BuildContext context) {
    return Positioned(
        right: 15.0,
        bottom: 35.0,
        child: PointerInterceptor(
          child: Container(
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                )
              ],
            ),
            child: Row(
              children: [
                InkWell(
                    onTap: () => {print("Zoom")},
                    child: HeroIcon(HeroIcons.plus,
                        color: sccMapZoom, size: context.scaleFont(16))),
                const SizedBox(
                  width: 5.0,
                ),
                SizedBox(
                    height: 20,
                    child: VerticalDivider(
                        color: sccMapZoomSeperator.withOpacity(0.5))),
                InkWell(
                    onTap: () => {print("Zoom Out")},
                    child: HeroIcon(HeroIcons.minus,
                        color: sccMapZoom, size: context.scaleFont(16))),
              ],
            ),
          ),
        ));
  }
}
