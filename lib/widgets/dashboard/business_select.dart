import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:scc_web/helper/app_scale.dart';
import 'package:scc_web/helper/constant.dart';
import 'package:scc_web/shared_widgets/buttons.dart';
import 'package:scc_web/theme/colors.dart';

class BusinessSelect extends StatefulWidget {
  final Function(bool) handleShowMap;
  final Function() handleSearch;
  const BusinessSelect(
      {Key? key, required this.handleShowMap, required this.handleSearch})
      : super(key: key);
  @override
  State<BusinessSelect> createState() => _BusinessSelectState();
}

class _BusinessSelectState extends State<BusinessSelect> {
  final List<String> items = [
    'ALL',
    'INE_001 & Inventory Non Engine',
    'IE_001 & Inventory Engine',
    'TUC_001 & Test Use Case',
    'VPAD_001 & Vehicle Pairing And Delivery',
  ];

  String? selectedValue;
  final TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Row(children: [
        Container(
          margin: const EdgeInsets.only(left: 5.0),
          child: Visibility(
              visible: !isMobile,
              child: SizedBox(
                width: context.deviceWidth() * 0.25,
                child: DropdownButtonHideUnderline(
                  child: DropdownButton2<String>(
                    isExpanded: true,
                    hint: Text(
                      'Choose Your Business Process',
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).hintColor,
                      ),
                    ),
                    items: items
                        .map(
                          (item) => DropdownMenuItem(
                            value: item,
                            child: Text(
                              item,
                              style: const TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ),
                        )
                        .toList(),

                    value: selectedValue,
                    onChanged: (value) {
                      setState(() {
                        selectedValue = value;
                      });
                    },

                    buttonStyleData: ButtonStyleData(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        height: 40,
                        width: 200,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              blurRadius: 8,
                              offset: Offset(0, 3),
                            )
                          ],
                        )),
                    dropdownStyleData: DropdownStyleData(
                        maxHeight: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                        )),
                    menuItemStyleData: const MenuItemStyleData(
                      height: 40,
                    ),
                    dropdownSearchData: DropdownSearchData(
                      searchController: textEditingController,
                      searchInnerWidgetHeight: 50,
                      searchInnerWidget: Container(
                        height: 50,
                        padding: const EdgeInsets.only(
                          top: 8,
                          bottom: 4,
                          right: 8,
                          left: 8,
                        ),
                        child: TextFormField(
                          expands: true,
                          maxLines: null,
                          controller: textEditingController,
                          decoration: InputDecoration(
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 8,
                            ),
                            hintStyle: const TextStyle(fontSize: 12),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                  width: 1.0,
                                  color: Colors.grey.withOpacity(0.3)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                  width: 1.0,
                                  color: Colors.grey.withOpacity(0.3)),
                            ),
                            hintText: "search business proccess name",
                          ),
                        ),
                      ),
                      searchMatchFn: (item, searchValue) {
                        return item.value
                            .toString()
                            .toLowerCase()
                            .contains(searchValue.toLowerCase());
                      },
                    ),
                    //This to clear the search value when you close the menu
                    onMenuStateChange: (isOpen) {
                      if (!isOpen) {
                        textEditingController.clear();
                      }
                    },
                  ),
                ),
              )),
        ),
        Container(
            margin: const EdgeInsets.only(left: 10.0),
            child: ButtonConfirm(
                colour: sccPrimaryDashboard,
                text: "Search",
                width: context.deviceWidth() * 0.06,
                borderRadius: 5,
                padding: 1,
                boxShadowColor: sccWhite.withOpacity(0.3),
                onTap: widget.handleSearch)),
        const Spacer(),
      ]),
    );
  }
}
