import 'package:flutter/material.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:scc_web/helper/app_scale.dart';
import 'package:scc_web/shared_widgets/common_shimmer.dart';
import 'package:scc_web/shared_widgets/expandable_widget.dart';
import 'package:scc_web/shared_widgets/gradient_widgets.dart';
import 'package:scc_web/theme/colors.dart';

class SingleMenu extends StatefulWidget {
  final bool isActive, isLoading, isExpanded;
  final String title, menuCd;
  final Widget icon;
  final Function() onPressed;
  const SingleMenu({
    Key? key,
    required this.isExpanded,
    required this.isActive,
    required this.title,
    required this.menuCd,
    required this.icon,
    required this.onPressed,
    required this.isLoading,
  }) : super(key: key);

  @override
  State<SingleMenu> createState() => _SingleMenuState();
}

class _SingleMenuState extends State<SingleMenu> {
  bool onHover = false;
  @override
  Widget build(BuildContext context) {
    return PortalTarget(
      visible: onHover,
      anchor: Aligned(
        follower: onHover ? Alignment.topLeft : Alignment.centerLeft,
        target: onHover ? Alignment.bottomLeft : Alignment.centerRight,
      ),
      portalFollower: Container(
        padding: const EdgeInsets.all(8),
        // height: 100,
        decoration: BoxDecoration(
          color: sccWhite,
          borderRadius: const BorderRadius.all(
            Radius.circular(8),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Text(
          widget.title,
          textAlign: TextAlign.left,
          style: TextStyle(
            fontSize: context.scaleFont(14),
            fontWeight: FontWeight.w600,
            color: widget.isActive ? sccNavText2 : sccNavText1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
      child: MouseRegion(
        onHover: (val) {
          setState(() {
            if (!widget.isExpanded) {
              onHover = true;
            }
          });
        },
        onExit: (val) {
          setState(() {
            onHover = false;
          });
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 0),
          child: TextButton(
            style: ButtonStyle(
              padding: MaterialStateProperty.all(
                  const EdgeInsets.only(right: 8, top: 8, bottom: 8, left: 8)),
            ),
            onPressed: () => widget.onPressed(),
            child: CommonShimmer(
              isLoading: widget.isLoading,
              child: Container(
                // margin: EdgeInsets.only(right: 8.wh),
                padding: EdgeInsets.symmetric(horizontal: 4.wh, vertical: 4.wh),
                decoration: BoxDecoration(
                  color: widget.isActive ? sccNavLightGrey : null,
                  // gradient: widget.isActive
                  //     ? LinearGradient(
                  //         begin: Alignment.topCenter,
                  //         end: Alignment.bottomCenter,
                  //         colors: [
                  //           sccButtonLightBlue,
                  //           sccNavLightGrey,
                  //         ],
                  //       )
                  //     : null,
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  // BorderRadius.only(
                  //     topRight: Radius.circular(50),
                  //     bottomRight: Radius.circular(50)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GradientWidget(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          widget.isActive ? sccNavText2 : sccNavText1,
                          widget.isActive ? sccNavText2 : sccNavText1,
                        ],
                      ),
                      child: widget.icon,
                    ),
                    Flexible(
                      fit: FlexFit.loose,
                      child: ExpandableWidget(
                        expand: widget.isExpanded,
                        axisDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            SizedBox(
                              width: 4.wh,
                            ),
                            Expanded(
                              child: Text(
                                widget.title,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontSize: context.scaleFont(12),
                                  fontWeight: FontWeight.w600,
                                  color: widget.isActive
                                      ? sccNavText2
                                      : sccNavText1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
