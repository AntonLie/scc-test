import 'package:flutter/material.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';
import 'package:scc_web/helper/app_scale.dart';
import 'package:scc_web/theme/colors.dart';

class OptionTrace extends StatefulWidget {
  final Function(String) handleSelectedTrace;
  const OptionTrace({super.key, required this.handleSelectedTrace});

  @override
  State<OptionTrace> createState() => _OptionTraceState();
}

class _OptionTraceState extends State<OptionTrace> {
  @override
  Widget build(BuildContext context) {
    return Positioned(
        left: context.deviceWidth() >= 1920
            ? context.deviceWidth() * 0.12
            : 180.0,
        bottom: 35.0,
        child: PointerInterceptor(
          child: Container(
              width: context.deviceWidth() * 0.11,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                        onTap: () => {widget.handleSelectedTrace("Inventory")},
                        child: Container(
                            padding: const EdgeInsets.fromLTRB(
                                10.0, 12.0, 10.0, 12.0),
                            child: Text(
                              "Inventory",
                              style: TextStyle(
                                  color: sccBlack,
                                  fontSize: context.scaleFont(12),
                                  fontWeight: FontWeight.w400),
                            ))),
                    Divider(
                        height: 1, color: sccMapZoomSeperator.withOpacity(0.1)),
                    InkWell(
                      onTap: () => {widget.handleSelectedTrace("Traceability")},
                      child: Container(
                          padding:
                              const EdgeInsets.fromLTRB(10.0, 12.0, 10.0, 12.0),
                          child: Text(
                            "Traceability",
                            style: TextStyle(
                                color: sccBlack,
                                fontSize: context.scaleFont(12),
                                fontWeight: FontWeight.w400),
                          )),
                    )
                  ],
                ),
              )),
        ));
  }
}
