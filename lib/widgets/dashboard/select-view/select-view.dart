import 'package:flutter/material.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';
import 'package:scc_web/helper/app_scale.dart';
import 'package:scc_web/theme/colors.dart';

class SelectView extends StatefulWidget {
  final Function(String) handleOpenSelect;
  final String selectedView;
  const SelectView(
      {super.key, required this.handleOpenSelect, required this.selectedView});

  @override
  State<SelectView> createState() => _SelectViewState();
}

class _SelectViewState extends State<SelectView> {
  @override
  Widget build(BuildContext context) {
    return Positioned(
        left: 15.0,
        bottom: 35.0,
        child: PointerInterceptor(
          child: InkWell(
            onTap: () => {widget.handleOpenSelect("View")},
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
                          widget.selectedView,
                          style: TextStyle(
                              color: sccBlack,
                              fontSize: context.scaleFont(12),
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    Transform.rotate(
                        angle: 190.06,
                        child: Icon(Icons.arrow_forward_ios,
                            size: context.scaleFont(12))),
                  ],
                )),
          ),
        ));
  }
}
