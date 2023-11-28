import 'package:flutter/material.dart';
import 'package:scc_web/helper/app_scale.dart';
import 'package:scc_web/theme/colors.dart';

class TimeUpdated extends StatefulWidget {
  const TimeUpdated({super.key});

  @override
  State<TimeUpdated> createState() => _TimeUpdatedState();
}

class _TimeUpdatedState extends State<TimeUpdated> {
  @override
  Widget build(BuildContext context) {
    return Positioned(
        right: 15.0,
        top: 25.0,
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                Icons.timer,
                color: sccMapZoom,
                size: 16.0,
              ),
              const SizedBox(
                width: 5.0,
              ),
              Text("Last Update 12 : 59 PM",
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: context.scaleFont(12)))
            ],
          ),
        ));
  }
}
