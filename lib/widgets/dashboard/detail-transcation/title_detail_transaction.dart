import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:scc_web/helper/app_scale.dart';
import 'package:scc_web/helper/assisted_auto_route.dart';
import 'package:scc_web/theme/colors.dart';

class TitleDetailTransaction extends StatefulWidget {
  final String title;
  const TitleDetailTransaction({super.key, required this.title});

  @override
  State<TitleDetailTransaction> createState() => _TitleDetailTransactionState();
}

class _TitleDetailTransactionState extends State<TitleDetailTransaction> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.stop_circle_outlined,
                color: Colors.red, size: context.scaleFont(20)),
            const SizedBox(
              width: 15.0,
            ),
            Text(
              widget.title,
              style: TextStyle(
                  color: sccPrimaryDashboard,
                  fontSize: context.scaleFont(20),
                  overflow: TextOverflow.clip,
                  fontWeight: FontWeight.w600),
            )
          ],
        ),
        InkWell(
          onTap: () {
            context.closeDialog();
          },
          child: Container(
            height: 18,
            width: 18,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(16)),
              color: sccMapZoomSeperator.withOpacity(0.5),
            ),
            child: HeroIcon(
              HeroIcons.xMark,
              color: sccWhite,
              size: context.scaleFont(17),
            ),
          ),
        ),
      ],
    );
  }
}
