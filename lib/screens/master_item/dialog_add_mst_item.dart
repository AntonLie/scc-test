import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:heroicons/heroicons.dart';
import 'package:scc_web/bloc/assign_mst_item/bloc/assign_mst_item_bloc.dart';
import 'package:scc_web/bloc/mst_use_case/bloc/use_case_bloc.dart';
import 'package:scc_web/helper/app_scale.dart';
import 'package:scc_web/helper/assisted_auto_route.dart';
import 'package:scc_web/helper/constant.dart';
import 'package:scc_web/helper/keyval.dart';
import 'package:scc_web/model/assign_mst_item.dart';
import 'package:scc_web/model/use_case.dart';
import 'package:scc_web/screens/master_item/review_history_detail.dart';
import 'package:scc_web/shared_widgets/add_edit_confirm_dialog.dart';
import 'package:scc_web/shared_widgets/buttons.dart';
import 'package:scc_web/shared_widgets/common_shimmer.dart';
import 'package:scc_web/shared_widgets/portal_dropdown.dart';
import 'package:scc_web/theme/colors.dart';
import 'package:styled_text/styled_text.dart';
import 'package:timelines/timelines.dart';

import '../../shared_widgets/snackbars.dart';

class DialogAddItem extends StatefulWidget {
  final List<ListUseCaseData> listUseCase;
  final Function(AssignMstItem) onSave;
  final String formMode;
  final String supplierCd;

  const DialogAddItem(
      {super.key,
      required this.listUseCase,
      required this.onSave,
      required this.formMode,
      required this.supplierCd});

  @override
  State<DialogAddItem> createState() => _DialogAddItemState();
}

class _DialogAddItemState extends State<DialogAddItem> {
  final controller = ScrollController();
  GlobalKey<FormState> key = GlobalKey<FormState>();
  String? selectedUseCase;
  List<KeyVal> listUseCase = [];
  bool validateList = false;
  bool showUseCase = false;
  AssignMstItem submitModel = AssignMstItem();
  late AssignMstItem? model;
  String? itemCd;
  List<ReviewHistory> listHistory = [];

  @override
  void initState() {
    for (var e in widget.listUseCase) {
      if (e.useCaseCd != null) {
        listUseCase.add(KeyVal(e.useCaseName ?? "[Undefined]", e.useCaseCd!));
      }
    }

    super.initState();
  }

  onConfirm(AssignMstItem val) {
    showDialog(
        context: context,
        builder: (context) {
          return ConfirmSaveDialog(
            allTitle: "Assign A Business Process to Item?",
            allValue:
                "Are you sure to Assign the ${val.useCaseName} to ${val.itemName}?",
            textBtn: "Yes, Save",
            onSave: () {
              widget.onSave(submitModel);
              context.closeDialog();
            },
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AssignMstItemBloc, AssignMstItemState>(
      listener: (context, state) {
        if (state is MstItemFormLoaded) {
          model = state.model;
          if (model!.reviewHistory != null) {
            listHistory.addAll(model!.reviewHistory!);
          }
          if (model!.useCaseCd != null) {
            selectedUseCase = model!.useCaseCd;
          }
        }
        if (state is MstItemError) {
          showTopSnackBar(context, UpperSnackBar.error(message: state.error));
          context.closeDialog();
        }
      },
      child: BlocBuilder<AssignMstItemBloc, AssignMstItemState>(
        builder: (context, state) {
          if (state is! MstItemFormLoaded) {
            return Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else {
            return Dialog(
              backgroundColor: sccWhite,
              insetPadding: context.isDesktop()
                  ? EdgeInsets.symmetric(
                      horizontal: (context.deviceWidth() * 0.15),
                      vertical: (context.deviceHeight() * 0.2),
                    )
                  : const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Form(
                key: key,
                child: Row(
                  children: [
                    Container(
                      // color: sccBlue,
                      width: showUseCase == true
                          ? context.deviceWidth() * 0.48
                          : context.deviceWidth() * 0.7,
                      padding: isMobile
                          ? const EdgeInsets.only(
                              left: 8, right: 8, top: 28, bottom: 12)
                          : const EdgeInsets.all(16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Add Business Process",
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
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(16)),
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(20),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              StyledText(
                                                text:
                                                    'Item Name ' '<r>*</r>' '',
                                                style: TextStyle(
                                                    fontSize:
                                                        context.scaleFont(14),
                                                    fontWeight:
                                                        FontWeight.w400),
                                                tags: {
                                                  'r': StyledTextTag(
                                                      style: TextStyle(
                                                          fontSize: context
                                                              .scaleFont(16),
                                                          color: sccDanger))
                                                },
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              SizedBox(
                                                width: showUseCase == true
                                                    ? context.deviceWidth() *
                                                        0.33
                                                    : context.deviceWidth() *
                                                        0.55,
                                                child: SelectableText(
                                                  model!.itemName!,
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    fontSize:
                                                        context.scaleFont(14),
                                                    fontWeight: FontWeight.w600,
                                                    color: sccBlack,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 15,
                                              ),
                                              StyledText(
                                                text: 'Business Process '
                                                    '<r>*</r>'
                                                    '',
                                                style: TextStyle(
                                                    fontSize:
                                                        context.scaleFont(14),
                                                    fontWeight:
                                                        FontWeight.w400),
                                                tags: {
                                                  'r': StyledTextTag(
                                                      style: TextStyle(
                                                          fontSize: context
                                                              .scaleFont(16),
                                                          color: sccDanger))
                                                },
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              SizedBox(
                                                width: showUseCase == true
                                                    ? context.deviceWidth() *
                                                        0.38
                                                    : context.deviceWidth() *
                                                        0.6,
                                                child: PortalFormDropdown(
                                                  selectedUseCase,
                                                  listUseCase,
                                                  hintText:
                                                      "Choose the business process",
                                                  // enabled: widget.formMode != Constant.editMode,
                                                  onChange: (value) {
                                                    setState(() {
                                                      selectedUseCase = value;
                                                      showUseCase = false;
                                                    });
                                                    submitModel.useCaseCd =
                                                        value;
                                                    submitModel.useCaseName =
                                                        listUseCase
                                                            .firstWhere((e) =>
                                                                e.value ==
                                                                selectedUseCase)
                                                            .label;
                                                  },
                                                  validator: (value) {
                                                    if (selectedUseCase ==
                                                        null) {
                                                      return "This field is mandatory";
                                                    } else {
                                                      return null;
                                                    }
                                                  },
                                                ),
                                              ),
                                              Visibility(
                                                visible:
                                                    selectedUseCase != null,
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 6),
                                                  child: DottedAddButton(
                                                    width:
                                                        context.deviceWidth() *
                                                            0.25,
                                                    icon: HeroIcons
                                                        .magnifyingGlassCircle,
                                                    textsize:
                                                        context.dynamicFont(14),
                                                    text:
                                                        "View the flow of the business process",
                                                    onTap: () {
                                                      setState(() {
                                                        showUseCase =
                                                            !showUseCase;
                                                      });
                                                    },
                                                  ),
                                                ),
                                              ),
                                              Visibility(
                                                visible: widget.formMode !=
                                                    Constant.addMode,
                                                child: const SizedBox(
                                                  height: 15,
                                                ),
                                              ),
                                              Visibility(
                                                visible: widget.formMode !=
                                                    Constant.addMode,
                                                child: SizedBox(
                                                  // color: sccAmber,
                                                  width: showUseCase == true
                                                      ? context.deviceWidth() *
                                                          0.425
                                                      : context.deviceWidth() *
                                                          0.63,
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        'Review History ',
                                                        style: TextStyle(
                                                            fontSize: context
                                                                .scaleFont(18),
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                      ),
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                      ReviewHistoryTable(
                                                        listHistory:
                                                            listHistory,
                                                        minimizeStatus:
                                                            showUseCase,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(),
                                      ],
                                    ),
                                    Visibility(
                                        visible:
                                            widget.formMode != Constant.addMode,
                                        child: const SizedBox(height: 30)),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 25),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              ButtonCancel(
                                                text: "Cancel",
                                                width:
                                                    context.deviceWidth() * 0.1,
                                                marginVertical:
                                                    !isMobile ? 11 : 8,
                                                onTap: () {
                                                  context.closeDialog();
                                                },
                                              ),
                                              SizedBox(
                                                width: 8.wh,
                                              ),
                                              ButtonConfirm(
                                                text: "Submit",
                                                verticalMargin:
                                                    !isMobile ? 11 : 8,
                                                width:
                                                    context.deviceWidth() * 0.1,
                                                onTap: () {
                                                  if (key.currentState!
                                                      .validate()) {
                                                    if (submitModel.useCaseCd ==
                                                        null) {
                                                      submitModel.useCaseCd =
                                                          selectedUseCase;
                                                      submitModel.useCaseName =
                                                          listUseCase
                                                              .firstWhere((e) =>
                                                                  e.value ==
                                                                  selectedUseCase)
                                                              .label;
                                                    }
                                                    submitModel.itemCd =
                                                        model!.itemCd;
                                                    submitModel.supplierCd =
                                                        widget.supplierCd;
                                                    submitModel.itemName =
                                                        model!.itemName;
                                                    onConfirm(submitModel);
                                                    // widget.onSave(submitModel);
                                                    // context.closeDialog();
                                                  }
                                                },
                                              ),
                                            ],
                                          ),
                                        ],
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
                    Visibility(
                      visible: showUseCase,
                      child: Container(
                        decoration: const BoxDecoration(
                            color: sccBackground,
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(20),
                                bottomRight: Radius.circular(20))),
                        padding: isMobile
                            ? const EdgeInsets.only(
                                left: 8, right: 8, top: 28, bottom: 12)
                            : const EdgeInsets.all(16),
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            // mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                child: Text(
                                  "The Business Flow of The Business Process",
                                  style: TextStyle(
                                    fontSize: context.dynamicFont(16),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
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
                                    child: BlocProvider(
                                      create: (context) => UseCaseBloc()
                                        ..add(LoadFormUseCase(
                                            useCaseCd: selectedUseCase,
                                            formMode: Constant.editMode)),
                                      child: const UseCaseTouchPoint(),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
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

class UseCaseTouchPoint extends StatefulWidget {
  const UseCaseTouchPoint({super.key});

  @override
  State<UseCaseTouchPoint> createState() => _UseCaseTouchPointState();
}

class _UseCaseTouchPointState extends State<UseCaseTouchPoint> {
  List<ListTouchPoint>? model;
  List<ListTouchPoint> touchPoint = [];
  ScrollController scrollTp = ScrollController();

  @override
  Widget build(BuildContext context) {
    return BlocListener<UseCaseBloc, UseCaseState>(
      listener: (context, state) {
        if (state is UseCaseForm) {
          touchPoint.clear();
          model = state.model?.listTouchPoint;
          if (model != null) {
            touchPoint.addAll(model!);
          }
        }
      },
      child: BlocBuilder<UseCaseBloc, UseCaseState>(
        builder: (context, state) {
          return (touchPoint.isEmpty)
              ? //Text("Touch point is empty")
              SizedBox(
                  // color: sccGreen,
                  width: context.deviceWidth() * 0.19,
                  height: context.deviceHeight() * 0.47,
                  child: SvgPicture.asset(
                    Constant.emptyData,
                    height: context.deviceWidth() * (isMobile ? 0.1 : 0.2),
                    width: context.deviceWidth() * (isMobile ? 0.1 : 0.2),
                  ),
                )
              : CommonShimmer(
                  isLoading: state is UseCaseLoading,
                  child: Scrollbar(
                    controller: scrollTp,
                    child: SingleChildScrollView(
                      controller: scrollTp,
                      child: Container(
                        // color: sccAmber,
                        padding: const EdgeInsets.all(10),
                        width: context.deviceWidth() * 0.19,
                        child: Column(
                          children: [
                            FixedTimeline.tileBuilder(
                              theme: TimelineThemeData(
                                nodePosition: 0,
                                color: sccNavText2,
                                indicatorTheme: const IndicatorThemeData(
                                  position: 0.275,
                                ),
                                connectorTheme: const ConnectorThemeData(
                                  thickness: 2.5,
                                ),
                              ),
                              builder: TimelineTileBuilder.connected(
                                connectionDirection: ConnectionDirection.before,
                                itemCount: touchPoint.length,
                                contentsBuilder: ((context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                        bottom: 20, left: 4),
                                    child: Text(
                                      touchPoint[index].pointName ?? "-",
                                      style: TextStyle(
                                        fontSize: context.dynamicFont(14),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  );
                                }),
                                connectorBuilder: (_, index, ___) =>
                                    const DashedLineConnector(
                                  color: sccNavText2,
                                  dash: 5,
                                  gap: 2,
                                  thickness: 1.5,
                                ),
                                indicatorBuilder: (context, index) =>
                                    Indicator.dot(
                                  size: 20,
                                  color: sccNavText2,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                );
        },
      ),
    );
  }
}
