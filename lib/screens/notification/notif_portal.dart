// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

import 'package:flutter_portal/flutter_portal.dart';
import 'package:heroicons/heroicons.dart';
import 'package:scc_web/helper/app_scale.dart';
import 'package:scc_web/screens/notification/finished_notif.dart';
import 'package:scc_web/screens/notification/notif_items.dart';
import 'package:scc_web/shared_widgets/buttons.dart';
import 'package:scc_web/theme/colors.dart';

class NotifPortal extends StatefulWidget {
  const NotifPortal({Key? key}) : super(key: key);

  @override
  _NotifPortalState createState() => _NotifPortalState();
}

class _NotifPortalState extends State<NotifPortal> {
  bool visible = false;
  bool openedAll = false;
  @override
  Widget build(BuildContext context) {
    final controller = ScrollController();
    return PortalTarget(
      visible: visible,
      portalFollower: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          setState(() {
            visible = false;
          });
        },
      ),
      child: PortalTarget(
        visible: visible,
        anchor:  const Aligned(
                      follower:  Alignment.topCenter,
                      target:  Alignment.bottomCenter,
                    ),
        portalFollower: Material(
          elevation: 8,
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            // margin: const EdgeInsets.only(top: 8),
            padding: const EdgeInsets.only(top: 8),
            width: 325,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.white,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Notifications",
                        style: TextStyle(
                          color: Colors.grey.shade800,
                          fontSize: context.scaleFont(18),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Mark all as read",
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: context.scaleFont(16),
                          // fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: 0,
                    maxHeight: context.deviceHeight() * 0.6,
                  ),
                  child: Scrollbar(
                    controller: controller,
                    child: ListView.builder(
                      controller: controller,
                      shrinkWrap: true,
                      itemCount: 6,
                      itemBuilder: (context, index) {
                        if (index == 5 && openedAll) {
                          return const FinishedNotif();
                        } else if (index == 5 && !openedAll) {
                          return Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: SizedBox(
                              width: 100,
                              child: ButtonConfirm(
                                text: 'View Mode',
                                borderRadius: 50,
                                onTap: () {
                                  setState(() {
                                    openedAll = true;
                                  });
                                },
                              ),
                            ),
                          );
                        } else {
                          return const NotifItem();
                        }
                      },
                    ),
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
              ],
            ),
          ),
        ),
        child: IconButton(
          padding: const EdgeInsets.all(0),
          hoverColor: Colors.transparent,
          splashColor: Colors.transparent,
          icon: Stack(
            clipBehavior: Clip.none,
            children: [
              const HeroIcon(
                HeroIcons.bell,
                color: defaultElement,
              ),
              Visibility(
                visible: false,
                child: Positioned(
                  top: -4,
                  right: -4,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blue,
                    ),
                    child: Text(
                      "99+",
                      style: TextStyle(
                          color: Colors.white, fontSize: context.scaleFont(8)),
                    ),
                  ),
                ),
              )
            ],
          ),
          onPressed: () {
            setState(() {
              visible = !visible;
            });
          },
        ),
      ),
    );
  }
}
