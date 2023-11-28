import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heroicons/heroicons.dart';
import 'package:scc_web/bloc/mst_attr/bloc/mst_attr_bloc.dart';
import 'package:scc_web/helper/app_scale.dart';
import 'package:scc_web/helper/assisted_auto_route.dart';
import 'package:scc_web/helper/constant.dart';
import 'package:scc_web/model/master_attribute.dart';
import 'package:scc_web/model/system_master.dart';
import 'package:scc_web/shared_widgets/buttons.dart';
import 'package:scc_web/theme/colors.dart';

class ViewDialogAttribute extends StatefulWidget {
  final Function onEdit;
  final bool canUpdate;

  const ViewDialogAttribute(
      {super.key, required this.onEdit, required this.canUpdate});

  @override
  State<ViewDialogAttribute> createState() => _ViewDialogAttributeState();
}

class _ViewDialogAttributeState extends State<ViewDialogAttribute> {
  MstAttribute? model;
  List<SystemMaster> listAttrDataType = [];
  List<SystemMaster> listAttrType = [];
  @override
  Widget build(BuildContext context) {
    return BlocListener<MstAttrBloc, MstAttrState>(
      listener: (context, state) {
        if (state is LoadForm) {
          model = state.submitModel;
        }
      },
      child: BlocBuilder<MstAttrBloc, MstAttrState>(
        builder: (context, state) {
          if (state is! LoadForm) {
            return Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: const Center(child: CircularProgressIndicator()));
          } else {
            return Dialog(
              backgroundColor: sccWhite,
              insetPadding: context.isDesktop()
                  ? EdgeInsets.symmetric(
                      horizontal: (context.deviceWidth() * 0.25),
                      vertical: (context.deviceHeight() * 0.1),
                    )
                  : const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Container(
                width: context.deviceWidth(),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Attribute Code & Name',
                                style: TextStyle(
                                    color: sccBlack,
                                    fontSize: context.scaleFont(12),
                                    fontWeight: FontWeight.w400),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                "${model!.attributeCd} - ${model!.attributeName}",
                                style: TextStyle(
                                    color: sccBlack,
                                    fontSize: context.scaleFont(14),
                                    fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              Text(
                                'Attribute Type Code',
                                style: TextStyle(
                                    color: sccBlack,
                                    fontSize: context.scaleFont(12),
                                    fontWeight: FontWeight.w400),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                model!.attrTypeCd ?? "-",
                                style: TextStyle(
                                    color: sccBlack,
                                    fontSize: context.scaleFont(14),
                                    fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              Text(
                                'Data Type Length',
                                style: TextStyle(
                                    color: sccBlack,
                                    fontSize: context.scaleFont(12),
                                    fontWeight: FontWeight.w400),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                "For string : ${model!.attrDataTypeLen}",
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Attribute API Key',
                                style: TextStyle(
                                    color: sccBlack,
                                    fontSize: context.scaleFont(12),
                                    fontWeight: FontWeight.w400),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                model!.attrApiKey ?? "-",
                                style: TextStyle(
                                    color: sccBlack,
                                    fontSize: context.scaleFont(14),
                                    fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              Text(
                                'Attribute Data Type Code',
                                style: TextStyle(
                                    color: sccBlack,
                                    fontSize: context.scaleFont(12),
                                    fontWeight: FontWeight.w400),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                model!.attrDataTypeCd ?? "-",
                                style: TextStyle(
                                    color: sccBlack,
                                    fontSize: context.scaleFont(14),
                                    fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              Text(
                                'Data Type Precision',
                                style: TextStyle(
                                    color: sccBlack,
                                    fontSize: context.scaleFont(12),
                                    fontWeight: FontWeight.w400),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                model!.attrDataTypePrec.toString(),
                                style: TextStyle(
                                    color: sccBlack,
                                    fontSize: context.scaleFont(14),
                                    fontWeight: FontWeight.w600),
                              ),
                              // const SizedBox(
                              //   height: 12,
                              // ),
                            ],
                          ),
                        ),
                        const SizedBox(),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Attribute Description',
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
                                  model!.attrDesc ?? "-",
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
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
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
                                widget.onEdit();
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
                    )
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
