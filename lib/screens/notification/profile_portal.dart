import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:heroicons/heroicons.dart';
import 'package:scc_web/helper/app_route.gr.dart';
import 'package:scc_web/helper/app_scale.dart';
import 'package:scc_web/helper/assisted_auto_route.dart';
import 'package:scc_web/helper/constant.dart';
import 'package:scc_web/theme/colors.dart';

class ProfilePortal extends StatefulWidget {
  const ProfilePortal({super.key});

  @override
  State<ProfilePortal> createState() => _ProfilePortalState();
}

class _ProfilePortalState extends State<ProfilePortal> {
  bool visible = false;
  bool openedAll = false;
  @override
  Widget build(BuildContext context) {
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
        anchor: const Aligned(
          follower: Alignment.topCenter,
          target: Alignment.bottomCenter,
        ),
        portalFollower: Container(
          padding: const EdgeInsets.all(8),
          width: 280,
          // height: 100,
          decoration: BoxDecoration(
            color: sccWhite,
            borderRadius: const BorderRadius.all(
              Radius.circular(16),
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
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.memory(
                    // base64Decode(profile.base64 ?? Constant.profileBase64Img),
                    base64Decode(Constant.profileBase64Img),
                    height: context.scaleFont(80),
                    width: context.scaleFont(80),
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  // profile.fullName ?? "Name",
                  "name",
                  style: TextStyle(
                    color: sccBlack,
                    fontSize: context.scaleFont(14),
                    fontWeight: FontWeight.bold,
                    overflow: TextOverflow.ellipsis,
                  ),
                  maxLines: 1,
                ),
                const SizedBox(
                  height: 10,
                ),
                InkWell(
                  onTap: () {
                    context.push(const ProfileSettingsRoute());
                    // alertDialogLogout(context, () => homeBloc(DoLogout()));
                  },
                  child: Row(
                    children: [
                      HeroIcon(
                        HeroIcons.user,
                        color: sccNavText2,
                        size: context.scaleFont(16),
                      ),
                      const SizedBox(
                        width: 12,
                      ),
                      const Expanded(
                        child: Text(
                          "Account",
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: sccBlack),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                InkWell(
                  onTap: () {
                    // alertDialogLogout(context, () => homeBloc(DoLogout()));
                  },
                  child: Row(
                    children: [
                      HeroIcon(
                        HeroIcons.arrowRightOnRectangle,
                        color: sccNavText2,
                        size: context.scaleFont(16),
                      ),
                      const SizedBox(
                        width: 12,
                      ),
                      const Expanded(
                        child: Text(
                          "Log Out",
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: sccBlack),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        child: InkWell(
          // onHover: () {},
          onTap: () {
            setState(() {
              visible = !visible;
            });
          },
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.memory(
                  // base64Decode(profile.base64 ?? Constant.profileBase64Img),
                  base64Decode(Constant.profileBase64Img),
                  height: context.scaleFont(35),
                  width: context.scaleFont(35),
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 5.wh),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SelectableText(
                      // profile.fullName ?? "Person Name",
                      "Person Name",
                      style: TextStyle(
                        color: defaultElement,
                        fontSize: context.scaleFont(12),
                        overflow: TextOverflow.clip,
                      ),
                      maxLines: 1,
                    ),
                    SelectableText(
                      // profile.division ?? "Position",
                      "Position",
                      style: TextStyle(
                        color: defaultGrey,
                        fontSize: context.scaleFont(10),
                        overflow: TextOverflow.clip,
                      ),
                      maxLines: 1,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
