// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:scc_web/theme/colors.dart';

class ToolI extends StatelessWidget {
  final String message;
  const ToolI({
    Key? key, required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Tooltip(
        verticalOffset: -10,
        margin: const EdgeInsets.only(left: 55),
        message:
            message,
        child: Stack(
          children: [
            Container(
                width: 20,
                height: 20,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: sccAmber,
                ),
                child: const Center(
                  child: Center(
                    child: Text(
                      'i',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                          fontStyle: FontStyle.italic),
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
