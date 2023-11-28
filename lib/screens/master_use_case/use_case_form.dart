import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:scc_web/helper/app_scale.dart';
import 'package:scc_web/helper/assisted_auto_route.dart';
import 'package:scc_web/helper/constant.dart';
import 'package:scc_web/helper/keyval.dart';
import 'package:scc_web/helper/utils.dart';
import 'package:scc_web/model/use_case.dart';
import 'package:scc_web/screens/inventory/scc_typeahead.dart';
import 'package:scc_web/shared_widgets/add_edit_confirm_dialog.dart';
import 'package:scc_web/shared_widgets/buttons.dart';
import 'package:scc_web/shared_widgets/custom_textfield.dart';

import 'package:scc_web/shared_widgets/snackbars.dart';
import 'package:scc_web/shared_widgets/src/calendar_portal.dart';
import 'package:scc_web/theme/colors.dart';
import 'package:styled_text/styled_text.dart';

import 'use_case_touchpoint.dart';

class FormUseCase extends StatefulWidget {
  final Function() onClose;
  final List<KeyVal> listAttr;
  final List<KeyVal> listPoint;
  final List<KeyVal> listTouchPoint;
  final ListUseCaseData? model;
  final String? formMode;
  final Function(ListUseCaseData?) onSubmit;
  final bool canPushBlock;

  const FormUseCase(
      {super.key,
      required this.onClose,
      required this.listAttr,
      required this.listPoint,
      required this.listTouchPoint,
      this.model,
      required this.onSubmit,
      required this.canPushBlock,
      this.formMode});

  @override
  State<FormUseCase> createState() => _FormUseCaseState();
}

class _FormUseCaseState extends State<FormUseCase> {
  List<ListTouchPoint> touchy = [];
  bool validateList = false;
  DateTime? endDtSelected, startDtSelected;
  late TextEditingController useName;
  late TextEditingController useDesc;
  List<String>? selectedListTouchPoint = [];
  List<KeyVal> listTouchPointDrop = [];
  List<KeyVal> selectedItems = [];
  List<String> listUnvalidated = [];
  bool checkConsume = false;
  bool lastSupplier = false;
  bool receiverPoint = false;
  bool pushBlock = false;
  bool visibCheck = false;
  String? selectedTouchPoint;
  List<KeyVal> listTouchPoint = [];
  late TextEditingController pointCd;
  late TextEditingController pointType;
  GlobalKey<FormState> key1 = GlobalKey<FormState>();

  ListUseCaseData submitModel = ListUseCaseData();

  @override
  void initState() {
    listTouchPointDrop = widget.listAttr;
    if (widget.model != null) {
      submitModel = widget.model!;
      startDtSelected =
          convertStringToDateFormat(submitModel.startDt!, "dd MMM yyyy");
      endDtSelected =
          convertStringToDateFormat(submitModel.endDt!, "dd MMM yyyy");
      selectedListTouchPoint = submitModel.attrSerialNumber;
      if (selectedListTouchPoint != []) {
        selectedListTouchPoint?.forEach((val) {
          for (var element in listTouchPointDrop) {
            if (val == element.value) {
              selectedItems.add(KeyVal(element.label, element.value));
            }
          }
        });
      }
    }
    startDtSelected = DateTime.now();

    useName = TextEditingController(text: submitModel.useCaseName ?? "");
    useDesc = TextEditingController(text: submitModel.useCaseDesc ?? "");

    if (submitModel.listTouchPoint != null) {
      touchy = submitModel.listTouchPoint!;
    } else {
      touchy.add(ListTouchPoint());
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    removeItem(int index) {
      setState(() {
        touchy = List.from(touchy)..removeAt(index);
      });
    }

    return Form(
      key: key1,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 2,
                offset: const Offset(0, 1),
              ),
            ], color: Colors.white, borderRadius: BorderRadius.circular(8)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.formMode == Constant.addMode ? "Add New" : "Edit",
                  style: TextStyle(
                    fontSize: context.scaleFont(18),
                    fontWeight: FontWeight.w600,
                    color: const Color(0xff2B2B2B),
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                const Divider(
                  color: sccLightGrayDivider,
                  height: 25,
                  thickness: 2,
                ),
                SizedBox(
                  width: context.deviceWidth() * 0.42,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      StyledText(
                        text: 'Business Process Name'
                            ' <r>*</r>'
                            '',
                        style: TextStyle(
                            fontSize: context.scaleFont(14),
                            fontWeight: FontWeight.w400),
                        tags: {
                          'r': StyledTextTag(
                              style: TextStyle(
                                  fontSize: context.scaleFont(14),
                                  fontWeight: FontWeight.w400,
                                  color: sccDanger))
                        },
                      ),
                      const SizedBox(height: 10),
                      CustomFormTextField(
                        hint: 'Input Business Process Name',
                        controller: useName,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "This field is mandatory";
                          } else if (value.trim().length > 200) {
                            return "Only 200 characters for maximum allowed";
                          } else {
                            return null;
                          }
                        },
                        onChanged: (value) {
                          if (value != null) {
                            submitModel.useCaseName = value;
                          }
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                StyledText(
                  text: 'Business Process Description'
                      ' <r>*</r>'
                      '',
                  style: TextStyle(
                      fontSize: context.scaleFont(14),
                      fontWeight: FontWeight.w400),
                  tags: {
                    'r': StyledTextTag(
                        style: TextStyle(
                            fontSize: context.scaleFont(14),
                            fontWeight: FontWeight.w400,
                            color: sccDanger))
                  },
                ),
                const SizedBox(height: 10),
                CustomFormTextField(
                  hint: 'Input Business Process Description',
                  controller: useDesc,
                  maxLine: 5,
                  onChanged: (value) {
                    if (value != null) {
                      submitModel.useCaseDesc = value;
                    }
                  },
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    SizedBox(
                      width: context.deviceWidth() * 0.35,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          StyledText(
                            text: 'Starting Date'
                                ' <r>*</r>'
                                '',
                            style: TextStyle(
                                fontSize: context.scaleFont(14),
                                fontWeight: FontWeight.w400),
                            tags: {
                              'r': StyledTextTag(
                                  style: TextStyle(
                                      fontSize: context.scaleFont(14),
                                      fontWeight: FontWeight.w400,
                                      color: sccDanger))
                            },
                          ),
                          const SizedBox(height: 10),
                          SingleDateCalendarPortalForm(
                            isPopToTop: true,
                            selectedDt: startDtSelected,
                            onChanged: (value) {
                              if (value != null) {
                                setState(() {
                                  startDtSelected = value;
                                  submitModel.startDt =
                                      convertDateToStringFormat(
                                          startDtSelected, "dd MMM yyyy");
                                });
                              }
                            },
                            validator: (value) {
                              if (value == null) {
                                return "This field is mandatory";
                              } else {
                                return null;
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    SizedBox(
                      width: context.deviceWidth() * 0.35,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          StyledText(
                            text: 'End Date'
                                ' <r>*</r>'
                                '',
                            style: TextStyle(
                                fontSize: context.scaleFont(14),
                                fontWeight: FontWeight.w400),
                            tags: {
                              'r': StyledTextTag(
                                  style: TextStyle(
                                      fontSize: context.scaleFont(14),
                                      fontWeight: FontWeight.w400,
                                      color: sccDanger))
                            },
                          ),
                          const SizedBox(height: 10),
                          SingleDateCalendarPortalForm(
                            isPopToTop: true,
                            selectedDt: endDtSelected,
                            onChanged: (value) {
                              if (value != null) {
                                setState(() {
                                  endDtSelected = value;
                                  submitModel.endDt = convertDateToStringFormat(
                                      endDtSelected, "dd MMM yyyy");
                                });
                              }
                            },
                            validator: (value) {
                              if (value == null) {
                                return "This field is mandatory";
                              } else {
                                return null;
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                StyledText(
                  text: 'Format Serial Number'
                      ' <r>*</r>'
                      '',
                  style: TextStyle(
                      fontSize: context.scaleFont(14),
                      fontWeight: FontWeight.w400),
                  tags: {
                    'r': StyledTextTag(
                        style: TextStyle(
                            fontSize: context.scaleFont(14),
                            fontWeight: FontWeight.w400,
                            color: sccDanger))
                  },
                ),
                const SizedBox(height: 10),
                SccMultipleTypeAheadKeyVal(
                  selectedItems: selectedItems,
                  url: "${dotenv.get('sccMasterProduct')}/attribute/search",
                  apiKeyLabel: "attributeName",
                  apiKeyValue: "attributeCd",
                  hintText: "input Format Serial Number",
                  fillColor: sccWhite,
                  onLogout: () {},
                  onError: (value) {
                    showTopSnackBar(context,
                        UpperSnackBar.error(message: value ?? "Error occured"));
                  },
                  onSelectionChange: (value) {
                    setState(() {
                      selectedItems = List.from(value);
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "This field is mandatory";
                    } else {
                      return null;
                    }
                  },
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 2,
                offset: const Offset(0, 1),
              ),
            ], color: Colors.white, borderRadius: BorderRadius.circular(8)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Touch Point',
                  style: TextStyle(
                    fontSize: context.scaleFont(28),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                const Divider(
                  color: sccLightGrayDivider,
                  height: 25,
                  thickness: 2,
                ),
                Visibility(
                  visible: touchy.isNotEmpty,
                  child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: touchy.isNotEmpty ? touchy.length : 1,
                      itemBuilder: (context, index) {
                        if (touchy.isNotEmpty) {
                          return TouchPointCase(
                            canPushBlock: widget.canPushBlock,
                            index: index,
                            key: UniqueKey(),
                            listPoint: widget.listPoint,
                            listTouchPoint: widget.listTouchPoint,
                            touchy: touchy[index],
                            pointCd: (val) {
                              touchy[index].pointCd = val;
                            },
                            pointName: (val) {
                              touchy[index].pointType = val;
                            },
                            onCLose: (val) {
                              removeItem(index);
                            },
                            checkConsume: (val) {
                              touchy[index].checkParent = val ?? false;
                            },
                            lastSupp: (val) {
                              touchy[index].pointSupplierFlag = val ?? false;
                            },
                            receive: (val) {
                              touchy[index].pointreceiveFlag = val ?? false;
                            },
                            pushBlock: (val) {
                              touchy[index].blockchainFlag = val ?? false;
                              touchy[index].seq = index + 1;
                            },
                          );
                        } else {
                          return const SizedBox();
                        }
                      }),
                ),
                const SizedBox(height: 10),
                Visibility(
                  visible: validateList,
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.only(left: 24),
                        child: Text(
                          'Point list must not empty',
                          style: TextStyle(
                            fontSize: context.scaleFont(14),
                            fontWeight: FontWeight.w400,
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
                  child: DottedAddButton(
                    width: context.deviceWidth() * 0.13,
                    text: "Add Point Code",
                    onTap: () {
                      setState(() {
                        validateList = false;
                        touchy.add(ListTouchPoint());
                      });
                    },
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
          const SizedBox(
            height: 24,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment:
                  isMobile ? MainAxisAlignment.center : MainAxisAlignment.end,
              children: [
                ButtonCancel(
                  text: "Cancel",
                  width: context.deviceWidth() *
                      (context.isDesktop() ? 0.13 : 0.37),
                  borderRadius: 8,
                  onTap: () {
                    widget.onClose();
                  },
                ),
                SizedBox(
                  width: 8.wh,
                ),
                ButtonConfirm(
                  text:
                      widget.formMode == Constant.editMode ? "Save" : "Submit",
                  onTap: () {
                    listUnvalidated.clear();

                    for (var element in touchy) {
                      if (element.pointCd == null) {
                        listUnvalidated.add(element.pointCd ?? "Undefined");
                      }
                    }
                    setState(() {
                      submitModel.attrSerialNumber = [];
                      validateList = listUnvalidated.isNotEmpty;
                    });
                    if (key1.currentState!.validate() && !validateList) {
                      submitModel.listTouchPoint = touchy;
                      submitModel.startDt ??= convertDateToStringFormat(
                          startDtSelected, "dd MMM yyyy");

                      for (var element in selectedItems) {
                        submitModel.attrSerialNumber?.add(element.value);
                      }
                      showDialog(
                          context: context,
                          builder: (ctx) {
                            return ConfirmSaveDialog(
                              sTitle: "Attribute",
                              sValue: submitModel.useCaseName,
                              onSave: () {
                                context.closeDialog();
                                widget.onSubmit(submitModel);
                              },
                            );
                          });
                    }
                  },
                  width: context.deviceWidth() *
                      (context.isDesktop() ? 0.13 : 0.37),
                  borderRadius: 8,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
