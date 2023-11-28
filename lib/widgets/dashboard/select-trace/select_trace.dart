import 'package:flutter/material.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';
import 'package:scc_web/helper/app_scale.dart';
import 'package:scc_web/theme/colors.dart';

class SelectTrace extends StatefulWidget {
  final Function(String) handleOpenSelect;
  final String selectedTrace;
  const SelectTrace(
      {super.key, required this.handleOpenSelect, required this.selectedTrace});

  @override
  State<SelectTrace> createState() => _SelectTraceState();
}

class _SelectTraceState extends State<SelectTrace> {
  @override
  Widget build(BuildContext context) {
    return Positioned(
        left: 15.0,
        bottom: 85.0,
        child: PointerInterceptor(
            child: InkWell(
          onTap: () => {widget.handleOpenSelect("Trace")},
          child: Container(
              width: context.deviceWidth() * 0.11,
              padding: const EdgeInsets.fromLTRB(10.0, 8.0, 10.0, 8.0),
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    widget.selectedTrace,
                    style: TextStyle(
                        color: sccBlack,
                        fontSize: context.scaleFont(12),
                        fontWeight: FontWeight.w400),
                  ),
                  Transform.rotate(
                      angle: 190.06,
                      child: Icon(Icons.arrow_forward_ios,
                          size: context.scaleFont(12))),
                ],
              )),
        )));
  }
}
