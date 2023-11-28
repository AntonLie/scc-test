import 'package:flutter/material.dart';
import 'package:scc_web/helper/app_scale.dart';


class FinishedNotif extends StatelessWidget {
  const FinishedNotif({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Image.asset(
          //   'assets/finished_flag.png',
          //   width: 20,
          //   height: 20,
          // ),
          const SizedBox(
            height: 8,
          ),
          Text(
            "That’s all your notifications from the last 30 days.",
            style: TextStyle(
              color: Colors.grey.shade700,
              fontSize: context.scaleFont(12),
            ),
          ),
        ],
      ),
    );
  }
}
