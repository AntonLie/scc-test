import 'package:flutter/material.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';
import 'package:scc_web/helper/app_scale.dart';
import 'package:scc_web/theme/colors.dart';

class OptionView extends StatefulWidget {
  final Function(String) handleSelectedView;
  const OptionView({super.key, required this.handleSelectedView});

  @override
  State<OptionView> createState() => _OptionViewState();
}

class _OptionViewState extends State<OptionView> {
  @override
  Widget build(BuildContext context) {
    return Positioned(
        left: context.deviceWidth() >= 1920
            ? context.deviceWidth() * 0.12
            : 180.0,
        bottom: -15.0,
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
                      onTap: () => widget.handleSelectedView("Area"),
                      child: Container(
                          padding:
                              const EdgeInsets.fromLTRB(10.0, 12.0, 10.0, 12.0),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "View by ",
                                      style: TextStyle(
                                          color: sccBlack,
                                          fontSize: context.scaleFont(12),
                                          fontWeight: FontWeight.w400),
                                    ),
                                    Text(
                                      "Area",
                                      style: TextStyle(
                                          color: sccBlack,
                                          fontSize: context.scaleFont(12),
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                )
                              ])),
                    ),
                    Divider(
                        height: 1, color: sccMapZoomSeperator.withOpacity(0.1)),
                    InkWell(
                      onTap: () => widget.handleSelectedView("Touchpoint"),
                      child: Container(
                          padding:
                              const EdgeInsets.fromLTRB(10.0, 12.0, 10.0, 12.0),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "View by ",
                                      style: TextStyle(
                                          color: sccBlack,
                                          fontSize: context.scaleFont(12),
                                          fontWeight: FontWeight.w400),
                                    ),
                                    Text(
                                      "Touchpoint",
                                      style: TextStyle(
                                          color: sccBlack,
                                          fontSize: context.scaleFont(12),
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                )
                              ])),
                    ),
                    Divider(
                        height: 1, color: sccMapZoomSeperator.withOpacity(0.1)),
                  ],
                ),
              )),
        ));
  }
}
