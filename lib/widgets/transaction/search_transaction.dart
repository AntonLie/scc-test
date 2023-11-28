import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:scc_web/helper/app_scale.dart';
import 'package:scc_web/shared_widgets/buttons.dart';
import 'package:scc_web/theme/colors.dart';

class SearchTransaction extends StatefulWidget {
  const SearchTransaction({super.key});

  @override
  State<SearchTransaction> createState() => _SearchTransactionState();
}

class _SearchTransactionState extends State<SearchTransaction> {
  final List<String> items = [
    'PART NUMBER',
    'ITEM NAME',
    'ITEM ID',
    'ITEM CODE',
    'BOX ID',
    'PRODUCT',
  ];
  String? selectedValue;

  void handleSearch() async {
    print("Search");
  }

  //Calendar State
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
  void initState() {
    // searchBySelected = searchCat[0];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 10.0,
          direction: Axis.vertical,
          children: [
            Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                        color: sccTransactionSearchBackground,
                        border: Border.all(
                            color: sccTransactionTableHead, width: 0.2),
                        borderRadius: BorderRadius.circular(8)),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton2<String>(
                              isExpanded: true,
                              hint: const Text(
                                'Search By',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: sccTransactionSearchColorText,
                                ),
                              ),
                              items: items
                                  .map(
                                      (String item) => DropdownMenuItem<String>(
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
                                width: 150,
                              ),
                              iconStyleData: const IconStyleData(
                                icon: Icon(
                                  Icons.keyboard_arrow_down,
                                ),
                                iconSize: 14,
                                iconEnabledColor: sccTransactionSearchColorText,
                                iconDisabledColor:
                                    sccTransactionSearchColorText,
                              ),
                              menuItemStyleData: const MenuItemStyleData(
                                height: 40,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                            height: 20,
                            child: VerticalDivider(
                                color: sccMapZoomSeperator.withOpacity(0.5))),
                        Container(
                            width: 450.0,
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Theme(
                                data: ThemeData(
                                    textSelectionTheme:
                                        const TextSelectionThemeData(
                                            selectionColor: Colors.black)),
                                child: TextFormField(
                                  maxLines: 1,
                                  cursorColor: sccTransactionSearchColorText,
                                  style: const TextStyle(
                                      color: sccTransactionSearchColorText,
                                      fontSize: 14),
                                  decoration: const InputDecoration(
                                      isDense: true,
                                      contentPadding:
                                          EdgeInsets.only(bottom: 2.0),
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.never,
                                      border: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      errorBorder: InputBorder.none,
                                      disabledBorder: InputBorder.none,
                                      hintText:
                                          "Search Your Keyword (use comma ‘,’ for multiple keyword)",
                                      hintStyle: TextStyle(
                                          fontSize: 14.0,
                                          color:
                                              sccTransactionSearchColorText)),
                                )))
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 15.0,
                  ),
                  Row(
                    children: [
                      Visibility(
                        visible: true,
                        child: InkWell(
                          onTap: () => {print("Pressed")},
                          child: const Icon(
                            Icons.add_circle_outlined,
                            color: sccPrimaryDashboard,
                            size: 35.0,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 15.0,
                      ),
                      Visibility(
                        visible: true,
                        child: InkWell(
                          onTap: () => {print("Pressed")},
                          child: const Icon(
                            Icons.remove_circle,
                            color: sccDanger,
                            size: 35.0,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 15.0,
                      ),
                      Visibility(
                        visible: true,
                        child: Container(
                            margin: const EdgeInsets.only(left: 10.0),
                            child: ButtonConfirm(
                                colour: sccPrimaryDashboard,
                                text: "Search",
                                width: context.deviceWidth() * 0.06,
                                borderRadius: 5,
                                padding: 1,
                                boxShadowColor: sccWhite.withOpacity(0.3),
                                onTap: handleSearch)),
                      )
                    ],
                  ),
                ]),
          ],
        ),
      ],
    );
  }
}
