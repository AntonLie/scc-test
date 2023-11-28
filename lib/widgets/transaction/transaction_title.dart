import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:scc_web/helper/app_scale.dart';
import 'package:scc_web/theme/colors.dart';
import 'package:scc_web/widgets/transaction/custom_filter.dart';

class TransactionTitle extends StatefulWidget {
  const TransactionTitle({super.key});

  @override
  State<TransactionTitle> createState() => _TransactionTitleState();
}

class _TransactionTitleState extends State<TransactionTitle> {
  final List<String> items = [
    'ITEM NAME',
    'ITEM ID',
    'ITEM CODE',
    'BOX ID',
  ];
  String? selectedValue;

  DateTime? startDtSelected;
  DateTime? endDtSelected;
  bool reset = false;

  void handleResetDate(bool value) {
    reset = value;
  }

  void handleDateSelected(DateTime? startDate, DateTime? endDate) {
    startDtSelected = startDate;
    endDtSelected = endDate;
  }

  void handleEndDate(DateTime value) {
    endDtSelected = value;
  }

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      SizedBox(
          width: context.deviceWidth() * 0.43,
          child: SelectableText('Trace and Track Part Position',
              style: TextStyle(
                  fontSize: context.scaleFont(24),
                  fontWeight: FontWeight.w600,
                  color: sccPrimaryDashboard))),
      const Spacer(),
      Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          const CustomFilter(
            width: 200.0,
          ),
          const SizedBox(
            width: 10.0,
          ),
          Container(
            decoration: BoxDecoration(
                color: sccTransactionSearchBackground,
                border: Border.all(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(8)),
            child: Wrap(
              spacing: 10.0,
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(10.0, 5.0, 5.0, 5.0),
                  color: sccTransactionSearchBackground,
                  child: const Text("Copy all selected"),
                ),
                Container(
                  width: 200.0,
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(8),
                          bottomRight: Radius.circular(8))),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton2<String>(
                      isExpanded: true,
                      hint: const Text(
                        'Select Column',
                        style: TextStyle(
                          fontSize: 14,
                          color: sccTransactionSearchColorText,
                        ),
                      ),
                      items: items
                          .map((String item) => DropdownMenuItem<String>(
                                value: item,
                                child: Text(
                                  item,
                                  style: const TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              ))
                          .toList(),
                      value: selectedValue,
                      onChanged: (String? value) {
                        setState(() {
                          selectedValue = value;
                        });
                      },
                      buttonStyleData: const ButtonStyleData(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        height: 40,
                        width: 140,
                      ),
                      iconStyleData: const IconStyleData(
                        icon: Icon(
                          Icons.keyboard_arrow_down,
                        ),
                        iconSize: 14,
                        iconEnabledColor: sccTransactionSearchColorText,
                        iconDisabledColor: sccTransactionSearchColorText,
                      ),
                      menuItemStyleData: const MenuItemStyleData(
                        height: 40,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      )
    ]);
  }
}
