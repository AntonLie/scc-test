import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:scc_web/helper/app_scale.dart';
import 'package:scc_web/helper/keyval.dart';
import 'package:scc_web/model/assign_mst_item.dart';
import 'package:scc_web/shared_widgets/buttons.dart';
import 'package:scc_web/shared_widgets/ta_dropdown.dart';
import 'package:scc_web/theme/colors.dart';
import 'package:styled_text/styled_text.dart';

class UseCaseWidget extends StatefulWidget {
  final List<KeyVal> listUseCase;
  final bool showUseCase;
  final Function(Key?) onClose;
  final int index;
  final ListUseCase? useCase;
  final Function(String?) useCaseCd;
  final Function(bool?)? showDetail;

  const UseCaseWidget({
    super.key,
    required this.listUseCase,
    required this.showUseCase,
    required this.onClose,
    required this.index,
    this.useCase,
    required this.useCaseCd,
    this.showDetail,
  });

  @override
  State<UseCaseWidget> createState() => _UseCaseWidgetState();
}

class _UseCaseWidgetState extends State<UseCaseWidget> {
  String? selectedUseCase;
  bool validateList = false;
  List<KeyVal> listUseCase = [];
  bool showUseCase = false;

  @override
  void initState() {
    // TODO: implement initState
    listUseCase = widget.listUseCase;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          // color: sccAmber,
          width: showUseCase == true
              ? context.deviceWidth() * 0.38
              : context.deviceWidth() * 0.6,
          child: StyledText(
            text: 'Business Case  ${widget.index + 1}<r>*</r>',
            style: TextStyle(
                fontSize: context.scaleFont(14), fontWeight: FontWeight.w400),
            tags: {
              'r': StyledTextTag(
                style: TextStyle(
                    fontSize: context.scaleFont(16), color: sccDanger),
              )
            },
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        SizedBox(
          width: showUseCase == true
              ? context.deviceWidth() * 0.38
              : context.deviceWidth() * 0.6,
          child: TAFormDropdown(
            selectedUseCase,
            listUseCase,
            hideKeyboard: false,
            hintText: "Choose the business process",
            onStrChange: (val) {
              if (val!.isNotEmpty) {
                setState(() {
                  selectedUseCase = val;
                });
              }
            },
            onChange: (value) {
              setState(() {
                selectedUseCase = value;
                widget.useCaseCd(selectedUseCase);
              });
              // submitModel.useCaseCd =
              //     value;
              // submitModel.useCaseName = listUseCase
              //     .firstWhere((e) => e.value == selectedUseCase)
              //     .label;
            },
            validator: (value) {
              if (selectedUseCase == null) {
                return "This field is mandatory";
              } else {
                return null;
              }
            },
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        Container(
          // color: sccAmber,
          width: showUseCase == true
              ? context.deviceWidth() * 0.38
              : context.deviceWidth() * 0.6,
          child: Row(
            mainAxisAlignment: showUseCase == true
                ? MainAxisAlignment.end
                : MainAxisAlignment.spaceBetween,
            children: [
              Visibility(
                visible: selectedUseCase != null,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: DottedAddButton(
                    width: context.deviceWidth() * 0.25,
                    icon: HeroIcons.magnifyingGlassCircle,
                    textsize: context.dynamicFont(14),
                    text: "View the business flow of the use case",
                    onTap: () {
                      setState(() {
                        showUseCase = !widget.showUseCase;
                        widget.showDetail!(showUseCase);
                        // widget.showUseCase = !showUseCase;
                      });
                    },
                  ),
                ),
              ),
              Visibility(
                visible: widget.index >= 0,
                child: TextButton(
                    onPressed: () {
                      widget.onClose(widget.key);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          color: sccBackground,
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        children: [
                          Text(
                            'Remove Use Case',
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
                            size: context.scaleFont(14),
                          )
                        ],
                      ),
                    )),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
