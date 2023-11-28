// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scc_web/bloc/subs/bloc/subs_bloc.dart';
import 'package:scc_web/helper/app_scale.dart';
import 'package:scc_web/helper/assisted_auto_route.dart';
import 'package:scc_web/helper/constant.dart';

import 'package:scc_web/helper/keyval.dart';
import 'package:scc_web/helper/utils.dart';
import 'package:scc_web/model/subscribers.dart';
import 'package:scc_web/shared_widgets/add_edit_confirm_dialog.dart';
import 'package:scc_web/shared_widgets/buttons.dart';
import 'package:scc_web/shared_widgets/custom_textfield.dart';
import 'package:scc_web/shared_widgets/portal_dropdown.dart';
import 'package:scc_web/shared_widgets/src/calendar_portal.dart';
import 'package:scc_web/theme/colors.dart';

class AddEditSubscribers extends StatefulWidget {
  final ListSubsTable model;
  final List<KeyVal> pkgName, numofPeriods;
  final String formMode;
  final Function(ListSubsTable) onSubmitEdit;
  const AddEditSubscribers({
    Key? key,
    required this.model,
    required this.formMode,
    required this.numofPeriods,
    required this.onSubmitEdit,
    required this.pkgName,
  }) : super(key: key);

  @override
  State<AddEditSubscribers> createState() => _AddEditSubscribersState();
}

class _AddEditSubscribersState extends State<AddEditSubscribers> {
  final controller = ScrollController();
  ListSubsTable submitModel = ListSubsTable();
  DateTime? startDtSelected;
  KeyVal? selectedPkg;
  KeyVal? selectedNoP;
  final brand = TextEditingController();
  List<KeyVal> pkgNm = [];
  List<KeyVal> numOf = [];
  GlobalKey<FormState> key = GlobalKey<FormState>();
  @override
  void initState() {
    widget.pkgName.removeWhere((element) => element.label == "All");
    pkgNm = widget.pkgName;
    numOf = widget.numofPeriods;
    startDtSelected = DateTime.now();

    super.initState();
  }

  onConfirm(ListSubsTable val) {
    showDialog(
        context: context,
        builder: (context) {
          return ConfirmSaveDialog(
            allTitle: widget.formMode == Constant.addMode
                ? "Create New Tenant?"
                : "Upgrade Package?",
            allValue: widget.formMode == Constant.addMode
                ? "Are you sure to create new tenant : ${val.companyName}?"
                : "Are you sure to upgrade package ${val.companyName}?",
            textBtn:
                "Yes, ${widget.formMode == Constant.addMode ? "Create" : "Upgrade"}",
            onSave: () {
              widget.onSubmitEdit(submitModel);
              context.closeDialog();
            },
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SubsBloc, SubsState>(
      listener: (context, state) {
        if (state is ViewSubs) {
          setState(() {
            submitModel = state.data!;
          });
          selectedPkg = widget.pkgName.firstWhere(
              (element) => element.label == submitModel.packageName);
          selectedNoP = widget.numofPeriods.firstWhere(
              (element) => element.value == submitModel.packageTime.toString());
          if (submitModel.brand != null) {
            brand.text = submitModel.brand!;
          }

          submitModel.companyCd = widget.model.companyCd;
        }
      },
      child: Dialog(
        insetPadding: kIsWeb && !isWebMobile
            ? EdgeInsets.symmetric(
                horizontal: (context.deviceWidth() * 0.15),
                vertical: (context.deviceHeight() * 0.1),
              )
            : const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Form(
          key: key,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      (widget.formMode == Constant.editMode)
                          ? 'Edit ${widget.model.companyName}'
                          : (widget.formMode == Constant.addMode)
                              ? 'Create ${widget.model.companyName}'
                              : Constant.viewNotif,
                      style: TextStyle(
                        fontSize: context.scaleFont(24),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Visibility(
                        visible: widget.formMode != Constant.addMode,
                        child: Container(
                          height: 40,
                          width: context.deviceWidth() * 0.08,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: (widget.model.status == 'Active')
                                  ? sccGreen
                                  : sccRed),
                          child: Center(
                              child: Text(
                            '${widget.model.status}',
                            style: TextStyle(
                                color: sccWhite,
                                fontSize: context.scaleFont(14),
                                fontWeight: FontWeight.bold),
                          )),
                        ))
                  ],
                ),
              ),
              const Divider(
                color: sccLightGrayDivider,
                height: 25,
                thickness: 2,
              ),
              // const SizedBox(
              //   height: 12,
              // ),
              Expanded(
                child: Scrollbar(
                  controller: controller,
                  child: SingleChildScrollView(
                    controller: controller,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Visibility(
                          visible: widget.formMode == Constant.addMode,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Brand',
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                CustomFormTextField(
                                  controller: brand,
                                  hint: "Input Brand",
                                  onChanged: (val) {
                                    setState(() {
                                      submitModel.brand = val;
                                    });
                                  },
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "This field is mandatory";
                                    } else if (value.trim().length > 25) {
                                      return "Only 100 characters for maximum allowed";
                                    } else {
                                      return null;
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: SelectableText('Package Name'),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: PortalFormDropdownKeyVal(
                            selectedPkg,
                            pkgNm,
                            hintText: 'Select Package',
                            onChange: (value) {
                              setState(() {
                                selectedPkg = value;
                                submitModel.newPackageCd =
                                    int.parse(value.value);
                              });
                            },
                            validator: (value) {
                              if (value == null || selectedPkg!.value.isEmpty) {
                                return "This field is mandatory";
                              } else {
                                return null;
                              }
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: SelectableText('Number of Periods'),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: PortalFormDropdownKeyVal(
                            selectedNoP,
                            numOf,
                            hintText: 'Select Periods',
                            onChange: (value) {
                              setState(() {
                                selectedNoP = value;
                                submitModel.packageTime =
                                    int.parse(value.value);
                              });
                            },
                            validator: (value) {
                              if (value == null || selectedNoP!.value.isEmpty) {
                                return "This field is mandatory";
                              } else {
                                return null;
                              }
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: SelectableText('Start Date'),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: SingleDateCalendarLov(
                            isPopToTop: true,
                            selectedDt: startDtSelected,
                            onChanged: (value) {
                              if (value != null) {
                                setState(() {
                                  startDtSelected = value;

                                  submitModel.startDt =
                                      convertDateToStringFormat(
                                          startDtSelected, "dd-MMM-yyyy");
                                });
                              }
                            },
                            validator: (value) {
                              if (value == null && startDtSelected == null) {
                                return "This field is mandatory";
                              } else {
                                return null;
                              }
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: isMobile
                                ? MainAxisAlignment.center
                                : MainAxisAlignment.end,
                            children: [
                              ButtonCancel(
                                text: "Cancel",
                                width: context.deviceWidth() *
                                    (context.isDesktop() ? 0.11 : 0.35),
                                onTap: () {
                                  context.back();
                                },
                              ),
                              SizedBox(
                                width: 8.wh,
                              ),
                              ButtonConfirm(
                                text: widget.formMode == Constant.addMode
                                    ? "Create"
                                    : "Upgrade",
                                onTap: () {
                                  if (key.currentState!.validate()) {
                                    context.back();
                                    submitModel.buttonStatus = true;
                                    submitModel.newPackageCd ??=
                                        submitModel.packageCd;
                                    submitModel.startDt =
                                        convertDateToStringFormat(
                                            startDtSelected, "dd-MMM-yyyy");
                                    onConfirm(submitModel);
                                    // return widget.onSubmitEdit(submitModel);
                                  }
                                },
                                width: context.deviceWidth() *
                                    (context.isDesktop() ? 0.1 : 0.35),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
