import 'package:flutter/material.dart';
import 'package:scc_web/helper/app_scale.dart';
import 'package:scc_web/shared_widgets/gradient_widgets.dart';
import 'package:scc_web/theme/colors.dart';

class SingleMenu extends StatefulWidget {
  final Function() onRoute;
  final String title;
  final bool isSelected;
  final Widget? icon;
  const SingleMenu({
    required this.onRoute,
    required this.title,
    required this.isSelected,
    Key? key,
    this.icon, 
  }) : super(key: key);

  @override
  State<SingleMenu> createState() => _SingleMenuState();
}

class _SingleMenuState extends State<SingleMenu> {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        padding: const EdgeInsets.all(12),
        backgroundColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(4)),
        ),
      ),
      onPressed: widget.onRoute,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4.wh, vertical: 4.wh),
        decoration: BoxDecoration(
          color: widget.isSelected ? sccNavLightGrey : null,
          borderRadius: const BorderRadius.all(Radius.circular(8)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            GradientWidget(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  widget.isSelected ? sccNavText2 : sccNavText1,
                  widget.isSelected ? sccNavText2 : sccNavText1,
                ],
              ),
              child: widget.icon ?? const SizedBox(),
            ),
            Expanded(
              child: Row(
                children: [
                  SizedBox(
                    width: 4.wh,
                  ),
                  Text(
                    widget.title,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: context.scaleFont(14),
                      fontWeight: widget.isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: widget.isSelected ? sccNavText2 : sccNavText1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
