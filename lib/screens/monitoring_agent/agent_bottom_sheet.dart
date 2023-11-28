import 'package:flutter/material.dart';
import 'package:scc_web/helper/app_scale.dart';
import 'package:scc_web/helper/keyval.dart';
import 'package:scc_web/shared_widgets/gradient_widgets.dart';
import 'package:scc_web/shared_widgets/outline_gradient_button.dart';
import 'package:scc_web/theme/colors.dart';

class AgentBottomSheet extends StatefulWidget {
  final List<KeyVal> companyList;
  final Function(KeyVal?) onCompanyChanged;
  final KeyVal? companySelected;
  const AgentBottomSheet(
      {super.key,
      required this.companyList,
      required this.onCompanyChanged,
      this.companySelected});

  @override
  State<AgentBottomSheet> createState() => _AgentBottomSheetState();
}

class _AgentBottomSheetState extends State<AgentBottomSheet> {
  List<KeyVal> companyList = [];
  KeyVal? companySelected;
  @override
  void initState() {
    companyList.addAll(widget.companyList);
    companySelected = widget.companySelected;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        Text(
          "Filter",
          style: TextStyle(
            fontSize: context.scaleFont(18),
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          "Select Company",
          style: TextStyle(
            fontSize: context.scaleFont(18),
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: AnimatedSize(
            duration: const Duration(
              milliseconds: 500,
            ),
            child: ListView.builder(
              itemCount: companyList.isNotEmpty ? companyList.length : 1,
              // shrinkWrap: true,
              itemBuilder: (context, index) {
                if (companyList.isNotEmpty) {
                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: ListTile(
                      dense: true,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                      hoverColor: Colors.transparent,
                      horizontalTitleGap: 8,
                      minLeadingWidth: 10,
                      onTap: () {
                        setState(() {
                          companySelected = companyList[index];
                        });
                        widget.onCompanyChanged(companySelected);
                      },
                      leading: OutlineGradientButton(
                        onTap: () {
                          setState(() {
                            companySelected = companyList[index];
                          });
                          widget.onCompanyChanged(companySelected);
                        },
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: companySelected != null &&
                                  companySelected!.value ==
                                      companyList[index].value
                              ? [
                                  sccButtonLightBlue,
                                  sccButtonBlue,
                                ]
                              : [
                                  sccInfoGrey,
                                  sccInfoGrey,
                                ],
                        ),
                        strokeWidth: companySelected != null &&
                                companySelected!.value ==
                                    companyList[index].value
                            ? 1
                            : 0.5,
                        padding: const EdgeInsets.all(1),
                        radius: const Radius.circular(125),
                        child: GradientWidget(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: companySelected != null &&
                                    companySelected!.value ==
                                        companyList[index].value
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
                      title: Text(
                        companyList[index].label,
                        style: TextStyle(
                          color: sccBlack,
                          fontSize: context.scaleFont(12),
                          overflow: TextOverflow.clip,
                        ),
                      ),
                    ),
                  );
                } else {
                  return Center(
                    child: Text(
                      "There is No Data",
                      style: TextStyle(
                        fontSize: context.scaleFont(16),
                      ),
                    ),
                  );
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}
