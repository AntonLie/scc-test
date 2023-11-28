import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heroicons/heroicons.dart';
import 'package:scc_web/bloc/mst_template_attribute/bloc/template_attribute_bloc.dart';
import 'package:scc_web/helper/app_scale.dart';
import 'package:scc_web/helper/assisted_auto_route.dart';
import 'package:scc_web/helper/constant.dart';
import 'package:scc_web/model/temp_attr.dart';
import 'package:scc_web/screens/master_template_attr/tmpl_attr_view_item.dart';
import 'package:scc_web/shared_widgets/buttons.dart';
import 'package:scc_web/theme/colors.dart';

class ViewDialogTempAttr extends StatefulWidget {
  final Function? onEdit;
  final String? point;
  final bool canUpdate;
  const ViewDialogTempAttr(
      {super.key, this.onEdit, this.point, required this.canUpdate});

  @override
  State<ViewDialogTempAttr> createState() => _ViewDialogTempAttrState();
}

class _ViewDialogTempAttrState extends State<ViewDialogTempAttr> {
  TempAttr? model;
  List<TempAttr> listAttr = [];
  List<TempAttDetail> listAttrDetail = [];
  final controller = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TemplateAttributeBloc, TemplateAttributeState>(
        listener: (context, state) {
      if (state is ViewTmplAttrLoaded) {
        model = state.model;
        if (model != null) {
          if (model!.templateDetail != null) {
            listAttrDetail.addAll(model!.templateDetail!);
          }
          if (listAttrDetail.every((element) => element.seq != null)) {
            listAttrDetail.sort((a, b) => a.seq!.compareTo(b.seq!));
          }
        }
      }
    }, child: BlocBuilder<TemplateAttributeBloc, TemplateAttributeState>(
      builder: (context, state) {
        if (state is! ViewTmplAttrLoaded) {
          return Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: const Center(child: CircularProgressIndicator()));
        } else {
          return Dialog(
            backgroundColor: sccWhite,
            insetPadding: context.isDesktop()
                ? EdgeInsets.symmetric(
                    horizontal: (context.deviceWidth() * 0.19),
                    vertical: (context.deviceHeight() * 0.1),
                  )
                : const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Container(
              width: context.deviceWidth(),
              // height: context.deviceHeight(),
              padding: isMobile
                  ? const EdgeInsets.only(
                      left: 8, right: 8, top: 28, bottom: 12)
                  : const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "View",
                        style: TextStyle(
                          fontSize: context.scaleFont(18),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          context.closeDialog();
                        },
                        child: Container(
                          height: 28,
                          width: 28,
                          // color: sccRed,
                          decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(16)),
                              color: sccWhite,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey,
                                  offset: Offset(
                                    5.0,
                                    5.0,
                                  ),
                                  blurRadius: 10.0,
                                  spreadRadius: 2.0,
                                ),
                              ]),
                          child: HeroIcon(
                            HeroIcons.xMark,
                            color: sccButtonPurple,
                            size: context.scaleFont(28),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(
                    color: sccLightGrayDivider,
                    height: 25,
                    thickness: 2,
                  ),
                  Expanded(
                    child: Scrollbar(
                      thumbVisibility: false,
                      controller: controller,
                      child: SingleChildScrollView(
                        controller: controller,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Template Attribute Code',
                                        style: TextStyle(
                                            color: sccBlack,
                                            fontSize: context.scaleFont(12),
                                            fontWeight: FontWeight.w400),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        model!.tempAttrCd ?? "-",
                                        style: TextStyle(
                                            color: sccBlack,
                                            fontSize: context.scaleFont(14),
                                            fontWeight: FontWeight.w600),
                                      ),
                                      const SizedBox(
                                        height: 12,
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Template Attribute Name',
                                        style: TextStyle(
                                            color: sccBlack,
                                            fontSize: context.scaleFont(12),
                                            fontWeight: FontWeight.w400),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        model!.tempAttrName ?? "-",
                                        style: TextStyle(
                                            color: sccBlack,
                                            fontSize: context.scaleFont(14),
                                            fontWeight: FontWeight.w600),
                                      ),
                                      const SizedBox(
                                        height: 12,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(),
                              ],
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: Row(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Template Attribute Description',
                                        style: TextStyle(
                                            color: sccBlack,
                                            fontSize: context.scaleFont(12),
                                            fontWeight: FontWeight.w400),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      SizedBox(
                                        width: context.deviceWidth() * 0.45,
                                        child: Text(
                                          model!.tempAttrDesc ?? "-",
                                          style: TextStyle(
                                              color: sccBlack,
                                              fontSize: context.scaleFont(14),
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                      // SizedBox(),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Visibility(
                              visible: listAttrDetail.isNotEmpty,
                              child:
                                  TmplAttrChildren(listDetail: listAttrDetail),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Visibility(
                              visible: widget.point == null,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: isMobile
                                      ? MainAxisAlignment.center
                                      : MainAxisAlignment.center,
                                  children: [
                                    Visibility(
                                      visible: widget.canUpdate,
                                      child: ButtonCancel(
                                        text: "Edit",
                                        width: context.deviceWidth() *
                                            (context.isDesktop() ? 0.11 : 0.35),
                                        onTap: () {
                                          widget.onEdit!();
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      width: 8.wh,
                                    ),
                                    ButtonConfirm(
                                      text: "OK",
                                      onTap: () {
                                        context.back();
                                      },
                                      width: context.deviceWidth() *
                                          (context.isDesktop() ? 0.1 : 0.35),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Visibility(
                              visible: widget.point != null,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: isMobile
                                      ? MainAxisAlignment.center
                                      : MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 8.wh,
                                    ),
                                    ButtonConfirm(
                                      text: "OK",
                                      onTap: () {
                                        context.back();
                                      },
                                      width: context.deviceWidth() *
                                          (context.isDesktop() ? 0.1 : 0.35),
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
                ],
              ),
            ),
          );
        }
      },
    ));
  }
}
