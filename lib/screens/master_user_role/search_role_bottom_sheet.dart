// import 'package:scc_web/helper/assisted_auto_route.dart';
import 'package:flutter/material.dart';
import 'package:scc_web/helper/app_scale.dart';
import 'package:scc_web/helper/assisted_auto_route.dart';
import 'package:scc_web/helper/keyval.dart';
import 'package:scc_web/shared_widgets/buttons.dart';
import 'package:scc_web/shared_widgets/gradient_widgets.dart';
import 'package:scc_web/shared_widgets/outline_gradient_button.dart';
import 'package:scc_web/theme/colors.dart';


class SearchRoleBottomSheet extends StatefulWidget {
  final KeyVal? selectedSearchBy, superAdminSelected;
  final List<KeyVal> searchByList, superAdminList;
  final Function(KeyVal? val) searchByChange, superAdminChange;
  const SearchRoleBottomSheet(
      {Key? key,
      required this.selectedSearchBy,
      required this.superAdminChange,
      required this.searchByList,
      required this.searchByChange,
      required this.superAdminList,
      required this.superAdminSelected})
      : super(key: key);

  @override
  State<SearchRoleBottomSheet> createState() => _SearchRoleBottomSheetState();
}

class _SearchRoleBottomSheetState extends State<SearchRoleBottomSheet> {
  KeyVal? selectedSearchBy;
  KeyVal? superAdminSelected;

  @override
  void initState() {
    selectedSearchBy = widget.selectedSearchBy;
    superAdminSelected = widget.superAdminSelected;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: context.deviceHeight() * 0.6,
      padding: const EdgeInsets.only(top: 12, left: 12, right: 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25.0),
          topRight: Radius.circular(25.0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          Text(
            'Search By',
            style: TextStyle(fontSize: context.scaleFont(18), fontWeight: FontWeight.bold),
          ),
          ListView.builder(
              itemCount: widget.searchByList.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: ListTile(
                    dense: true,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                    hoverColor: Colors.transparent,
                    horizontalTitleGap: 8,
                    minLeadingWidth: 10,
                    onTap: () {
                      setState(() {
                        selectedSearchBy = widget.searchByList[index];
                      });
                    },
                    leading: Padding(
                      padding: const EdgeInsets.only(right: 4),
                      child: OutlineGradientButton(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: selectedSearchBy != null && selectedSearchBy!.value == widget.searchByList[index].value
                              ? [
                                  sccButtonLightBlue,
                                  sccButtonBlue,
                                ]
                              : [
                                  sccInfoGrey,
                                  sccInfoGrey,
                                ],
                        ),
                        strokeWidth: selectedSearchBy != null && selectedSearchBy!.value == widget.searchByList[index].value ? 1 : 0.5,
                        padding: const EdgeInsets.all(1),
                        radius: const Radius.circular(125),
                        child: GradientWidget(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: selectedSearchBy != null && selectedSearchBy!.value == widget.searchByList[index].value
                                ? [
                                    sccButtonLightBlue,
                                    sccButtonBlue,
                                  ]
                                : [
                                    Colors.transparent,
                                    Colors.transparent,
                                  ],
                          ),
                          child: Icon(
                            Icons.circle,
                            size: context.scaleFont(16),
                          ),
                        ),
                      ),
                    ),
                    title: Text(
                      widget.searchByList[index].label,
                      style: TextStyle(
                        color: sccBlack,
                        fontSize: context.scaleFont(12),
                        overflow: TextOverflow.clip,
                      ),
                    ),
                  ),
                );
              }),
          const SizedBox(height: 12),
          Text(
            'Super Admin',
            style: TextStyle(fontSize: context.scaleFont(18), fontWeight: FontWeight.bold),
          ),
          ListView.builder(
              itemCount: widget.superAdminList.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: ListTile(
                    dense: true,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                    hoverColor: Colors.transparent,
                    horizontalTitleGap: 8,
                    minLeadingWidth: 10,
                    onTap: () {
                      setState(() {
                        superAdminSelected = widget.superAdminList[index];
                      });
                    },
                    leading: Padding(
                      padding: const EdgeInsets.only(right: 4),
                      child: OutlineGradientButton(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: superAdminSelected != null && superAdminSelected!.value == widget.superAdminList[index].value
                              ? [
                                  sccButtonLightBlue,
                                  sccButtonBlue,
                                ]
                              : [
                                  sccInfoGrey,
                                  sccInfoGrey,
                                ],
                        ),
                        strokeWidth: superAdminSelected != null && superAdminSelected!.value == widget.superAdminList[index].value ? 1 : 0.5,
                        padding: const EdgeInsets.all(1),
                        radius: const Radius.circular(125),
                        child: GradientWidget(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: superAdminSelected != null && superAdminSelected!.value == widget.superAdminList[index].value
                                ? [
                                    sccButtonLightBlue,
                                    sccButtonBlue,
                                  ]
                                : [
                                    Colors.transparent,
                                    Colors.transparent,
                                  ],
                          ),
                          child: Icon(
                            Icons.circle,
                            size: context.scaleFont(16),
                          ),
                        ),
                      ),
                    ),
                    title: Text(
                      widget.superAdminList[index].label,
                      style: TextStyle(
                        color: sccBlack,
                        fontSize: context.scaleFont(12),
                        overflow: TextOverflow.clip,
                      ),
                    ),
                  ),
                );
              }),
          const SizedBox(
            height: 10,
          ),
          ButtonConfirm(
            text: 'Apply',
            onTap: () {
              widget.searchByChange(selectedSearchBy);
              widget.superAdminChange(superAdminSelected);
              context.back();
            },
            borderRadius: 16,
            width: context.deviceWidth(),
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
