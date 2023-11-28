import 'package:flutter/material.dart';

import 'package:scc_web/helper/app_scale.dart';
import 'package:scc_web/theme/colors.dart';

class MenuChild extends StatefulWidget {
  final Function() onPressed;
  final bool isSelected;
  final String titleStr;
  const MenuChild({
    required this.titleStr,
    required this.isSelected,
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  State<MenuChild> createState() => _MenuChildState();
}

class _MenuChildState extends State<MenuChild> {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
        padding: MaterialStateProperty.all(
            const EdgeInsets.only(right: 8, top: 8, bottom: 8, left: 8)),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      onPressed: widget.onPressed,
      child: Container(
        margin: const EdgeInsets.only(right: 2, left: 32),
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        decoration: const BoxDecoration(
          color: null,
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
        
            Icon(
              Icons.brightness_1_rounded,
              size: context.scaleFont(6),
              color: widget.isSelected ? sccNavText2 : sccNavText1,
            ),
            const SizedBox(
              width: 6,
            ),
            Expanded(
              child: Text(
                widget.titleStr,
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: context.scaleFont(14),
                  fontWeight:
                      widget.isSelected ? FontWeight.bold : FontWeight.normal,
                  color: widget.isSelected ? sccNavText2 : sccNavText1,
                  // color: menuTextColor,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
