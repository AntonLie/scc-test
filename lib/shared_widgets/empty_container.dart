import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:scc_web/helper/app_scale.dart';
import 'package:scc_web/helper/constant.dart';
import 'package:scc_web/theme/colors.dart';

class EmptyContainer extends StatelessWidget {
  const EmptyContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: context.deviceWidth(),
      height: context.deviceHeight() * 0.45,
      padding:
          EdgeInsets.symmetric(horizontal: (isMobile ? 0 : 24), vertical: 12),
      color: white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(Constant.noresult),
          const SizedBox(
            height: 8,
          ),
          const Text(
            'No results found',
            style: TextStyle(
              color: text1,
            ),
          ),
        ],
      ),
    );
  }
}

class SimpleEmptyContainer extends StatelessWidget {
  const SimpleEmptyContainer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.deviceWidth(),
      padding: const EdgeInsets.all(8),
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: childTrackFilling,
        border: Border(
          bottom: BorderSide(color: lightGrayDivider, width: 1),
        ),
      ),
      child: Text(
        "There is No Data",
        textAlign: TextAlign.left,
        style: TextStyle(
          overflow: TextOverflow.ellipsis,
          fontSize: context.scaleFont(14),
        ),
      ),
    );
  }
}

class EmptyData extends StatelessWidget {
  const EmptyData({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: context.deviceWidth(),
      height: context.deviceHeight() * 0.6,
      padding:
          EdgeInsets.symmetric(horizontal: (isMobile ? 0 : 24), vertical: 12),
      color: white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            Constant.emptyData,
            height: context.deviceWidth() * (isMobile ? 0.1 : 0.2),
            width: context.deviceWidth() * (isMobile ? 0.1 : 0.2),
          ),
          const SizedBox(
            height: 8,
          ),
        ],
      ),
    );
  }
}
