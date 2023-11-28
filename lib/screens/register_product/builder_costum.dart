import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:scc_web/helper/app_scale.dart';
import 'package:scc_web/helper/utils.dart';
import 'package:scc_web/shared_widgets/table_content.dart';
import 'package:scc_web/theme/colors.dart';

class BuilderText extends StatelessWidget {
  final String? text;
  const BuilderText({super.key, this.text});

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return Padding(
        padding: const EdgeInsets.only(left: 10),
        child: PackageContent(
          value: text,
          color: sccNavText1,
          fontSize: 16,
        ),
      );
    });
  }
}

class BuilderIcon extends StatelessWidget {
  final String? colour;
  final bool? builder;
  const BuilderIcon({super.key, this.colour, this.builder});

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      if (builder == true) {
        return Padding(
          padding: const EdgeInsets.only(left: 10),
          child: HeroIcon(
            HeroIcons.check,
            color: stringToColor(colour),
            size: context.scaleFont(18),
          ),
        );
      } else {
        return const SizedBox();
      }
    });
  }
}
