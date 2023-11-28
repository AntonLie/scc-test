import 'package:flutter/material.dart';

import 'package:heroicons/heroicons.dart';
import 'package:scc_web/helper/app_scale.dart';
import 'package:scc_web/shared_widgets/expandable_widget.dart';
import 'package:scc_web/shared_widgets/gradient_widgets.dart';
import 'package:scc_web/theme/colors.dart';

class ParentMenu extends StatefulWidget {
  final bool? isActive;
  final String title;
  final List<Widget> children;
  final Widget? icon;
  const ParentMenu({
    required this.title,
    required this.children,
    this.isActive,
    Key? key,
    this.icon,
  }) : super(key: key);

  @override
  State<ParentMenu> createState() => _ParentMenuState();
}

class _ParentMenuState extends State<ParentMenu> {
  bool expand = true;

  @override
  void initState() {
    super.initState();
    expand = widget.isActive ?? true;
    WidgetsBinding.instance.addPostFrameCallback((_) {});
  }

  @override
  void didUpdateWidget(ParentMenu oldWidget) {
    super.didUpdateWidget(oldWidget);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        expand = widget.isActive ?? true;
      });
    });
  }

  Widget parentButton() {
    return TextButton(
      style: TextButton.styleFrom(
        padding: const EdgeInsets.all(12),
        backgroundColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(4)),
        ),
      ),
      onPressed: () {
        setState(() {
          expand = !expand;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4.wh, vertical: 4.wh),
        decoration: BoxDecoration(
          color: widget.isActive! ? sccNavLightGrey : null,
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
                  widget.isActive! ? sccNavText2 : sccNavText1,
                  widget.isActive! ? sccNavText2 : sccNavText1,
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
                      fontWeight: widget.isActive!
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: widget.isActive! ? sccNavText2 : sccNavText1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            HeroIcon(
              HeroIcons.chevronDown,
              color: widget.isActive! ? sccNavText2 : sccNavText1,
              size: context.scaleFont(16),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        parentButton(),
        ExpandableWidget(
          expand: expand,
          child: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: widget.children,
            ),
          ),
        ),
      ],
    );
  }
}
