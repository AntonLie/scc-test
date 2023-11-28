
import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:scc_web/helper/app_scale.dart';
import 'package:scc_web/theme/colors.dart';

class TitleFormCloseButton extends StatelessWidget {
  final String? formTitle;
  final Function() onClose;
  final TextStyle? titleStyle;
  const TitleFormCloseButton(
      {this.titleStyle, this.formTitle, required this.onClose, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: SelectableText(
            formTitle ?? "-",
            style: titleStyle ??
                TextStyle(
                  color: sccText3,
                  fontWeight: FontWeight.bold,
                  fontSize: context.scaleFont(18),
                  overflow: TextOverflow.clip,
                ),
          ),
        ),
        IconButton(
          onPressed: onClose,
          splashColor: Colors.transparent,
          icon: const HeroIcon(
            HeroIcons.xCircle,
            color: sccButtonPurple,
          ),
        ),
      ],
    );
  }
}
