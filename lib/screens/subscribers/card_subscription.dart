import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:scc_web/helper/app_scale.dart';
import 'package:scc_web/theme/colors.dart';

class CardScreenSubs extends StatefulWidget {
  final String? value, title;
  final String imgString, iconString;
  const CardScreenSubs(
      {super.key,
      // this.totalSubs,
      required this.imgString,
      required this.iconString,
      this.value,
      this.title});

  @override
  State<CardScreenSubs> createState() => _CardScreenSubsState();
}

class _CardScreenSubsState extends State<CardScreenSubs> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: context.deviceHeight() * 0.13,
      decoration: BoxDecoration(
        // color: sccRed,
        borderRadius: BorderRadius.circular(20),
        image: DecorationImage(
          image: AssetImage(widget.imgString), // Ganti dengan path gambar Anda
          fit: BoxFit.cover, // Fit gambar sesuai container
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Tooltip(
                message: widget.value ?? "-",
                child: Container(
                  color: Colors.transparent,
                  width: context.deviceWidth() * 0.18,
                  child: Text(
                    widget.value ?? '0',
                    // 'IDR. 2.345.678,567,324,345',
                    style: TextStyle(
                      fontSize: context.isFullScreen()
                          ? context.scaleFont(23)
                          : context.scaleFont(17),
                      fontWeight: FontWeight.w900,
                      color: sccWhite,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                // 'Number of Subscribers',
                widget.title ?? "[Undefined]",
                style: TextStyle(
                  fontSize: context.isFullScreen()
                      ? context.scaleFont(14)
                      : context.scaleFont(10),
                  fontWeight: FontWeight.w400,
                  color: sccWhite,
                ),
              ),
            ],
          ),
          const SizedBox(
            width: 12,
          ),
          Visibility(
            visible: context.isFullScreen(),
            child: Container(
              height: 52,
              width: 52,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: sccBackground,
              ),
              child: SvgPicture.asset(
                // Constant.inventoryValue,
                widget.iconString,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
