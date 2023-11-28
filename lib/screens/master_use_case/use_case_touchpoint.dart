import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:scc_web/helper/app_scale.dart';
import 'package:scc_web/helper/keyval.dart';
import 'package:scc_web/model/use_case.dart';
import 'package:scc_web/shared_widgets/custom_textfield.dart';
import 'package:scc_web/shared_widgets/ta_dropdown.dart';
import 'package:scc_web/theme/colors.dart';
import 'package:styled_text/styled_text.dart';

class TouchPointCase extends StatefulWidget {
  final ListTouchPoint touchy;
  final Function(Key?) onCLose;
  final List<KeyVal> listPoint;

  final List<KeyVal> listTouchPoint;
  final int index;
  final Function(String?) pointCd, pointName;
  final Function(bool?) checkConsume, lastSupp, receive, pushBlock;
  final bool canPushBlock;

  const TouchPointCase({
    super.key,
    required this.touchy,
    required this.onCLose,
    required this.listPoint,
    required this.listTouchPoint,
    required this.index,
    required this.checkConsume,
    required this.lastSupp,
    required this.receive,
    required this.pushBlock,
    required this.pointCd,
    required this.pointName,
    required this.canPushBlock,
  });

  @override
  State<TouchPointCase> createState() => _TouchPointCaseState();
}

class _TouchPointCaseState extends State<TouchPointCase> {
  String? selectedTouchPoint;
  List<KeyVal> listTouchPointDrop = [];
  List<KeyVal> listTouchPoint = [];
  ListTouchPoint? touchy;
  late TextEditingController pointCd;
  late TextEditingController pointType;
  bool checkConsume = false;
  bool lastSupplier = false;
  bool receiverPoint = false;
  bool pushBlock = false;
  bool visibCheck = false;

  @override
  void initState() {
    touchy = widget.touchy;
    listTouchPointDrop = widget.listPoint;
    listTouchPoint = widget.listTouchPoint;
    if (widget.touchy.pointCd != null) {
      selectedTouchPoint = touchy!.pointCd;
    }
    pointCd = TextEditingController(text: touchy!.pointCd ?? "");
    pointType = TextEditingController(text: touchy!.pointType ?? "");
    checkConsume = touchy!.checkParent ?? false;
    lastSupplier = touchy!.pointSupplierFlag ?? false;
    receiverPoint = touchy!.pointreceiveFlag ?? false;
    pushBlock = touchy!.blockchainFlag ?? false;
    if (touchy!.pointType == "CONSUME") {
      visibCheck = true;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.deviceWidth(),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
              border: Border.all(width: 0.1, color: sccBlack),
              color: Colors.white,
              borderRadius: BorderRadius.circular(8)),
          child: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Sequence Point ${widget.index + 1}',
                      style: TextStyle(
                        fontSize: context.scaleFont(18),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Visibility(
                      visible: widget.index >= 0,
                      child: TextButton(
                          onPressed: () => widget.onCLose(widget.key),
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                color: sccBackground,
                                borderRadius: BorderRadius.circular(10)),
                            child: Row(
                              children: [
                                Text(
                                  'Remove Point Code',
                                  style: TextStyle(
                                    color: sccRed,
                                    fontSize: context.scaleFont(14),
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                HeroIcon(
                                  HeroIcons.trash,
                                  color: sccRed,
                                  size: context.scaleFont(12),
                                )
                              ],
                            ),
                          )),
                    )
                  ],
                ),
                const SizedBox(
                  height: 12,
                ),
                const Divider(
                  color: sccLightGrayDivider,
                  height: 25,
                  thickness: 2,
                ),
                StyledText(
                  text: 'Touch Point'
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
                TAFormDropdown(
                  selectedTouchPoint,
                  listTouchPointDrop,
                  hideKeyboard: false,
                  hintText: 'Selected Product Type',
                  onStrChange: (val) {
                    if (val!.isEmpty) {
                      setState(() {
                        selectedTouchPoint = val;
                      });
                    }
                  },
                  onChange: (val) {
                    if (val != null) {
                      selectedTouchPoint = val;

                      widget.pointCd(selectedTouchPoint);
                      if (selectedTouchPoint != null) {
                        for (var element in listTouchPoint) {
                          if (selectedTouchPoint == element.value) {
                            pointType.text = element.label;
                            pointCd.text = element.value;
                            widget.pointName(element.label);
                            if (pointType.text.toUpperCase() == "CONSUME") {
                              setState(() {
                                checkConsume = true;
                                visibCheck = true;
                                if (widget.canPushBlock != false) {
                                  pushBlock = true;
                                }
                              });
                              widget.pushBlock(pushBlock);

                              widget.checkConsume(checkConsume);
                            } else {
                              setState(() {
                                visibCheck = false;
                              });
                            }
                          }
                        }
                      }
                    }
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                StyledText(
                  text: 'Point Code'
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
                  enabled: false,
                  controller: pointCd,
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
                      // submitModel.pointName = value;
                    }
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                StyledText(
                  text: 'Type'
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
                  enabled: false,
                  controller: pointType,
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
                      // submitModel.pointName = value;
                    }
                  },
                ),
                SizedBox(
                  width: context.deviceWidth(),
                  height: context.deviceHeight() * 0.05,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Visibility(
                        visible: visibCheck,
                        child: Row(
                          children: [
                            Checkbox(
                                value: checkConsume,
                                onChanged: (val) {
                                  setState(() {
                                    checkConsume = val!;
                                  });
                                  widget.checkConsume(checkConsume);
                                }),
                            const Text('Check Master Consume'),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Checkbox(
                              value: lastSupplier,
                              onChanged: (val) {
                                setState(() {
                                  lastSupplier = val!;
                                  if (lastSupplier == true) {
                                    receiverPoint = false;
                                  }
                                });
                                widget.lastSupp(lastSupplier);
                              }),
                          const Text('Last Supplier Point'),
                        ],
                      ),
                      Row(
                        children: [
                          Checkbox(
                              value: receiverPoint,
                              onChanged: (val) {
                                setState(() {
                                  receiverPoint = val!;
                                  if (receiverPoint == true) {
                                    lastSupplier = false;
                                  }
                                });
                                widget.receive(receiverPoint);
                              }),
                          const Text('Receiver Point'),
                        ],
                      ),
                      Visibility(
                        visible: widget.canPushBlock,
                        child: Row(
                          children: [
                            Checkbox(
                                value: pushBlock,
                                onChanged: (val) {
                                  setState(() {
                                    pushBlock = val!;
                                  });
                                  widget.pushBlock(pushBlock);
                                }),
                            const Text('Push Blockchain'),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
