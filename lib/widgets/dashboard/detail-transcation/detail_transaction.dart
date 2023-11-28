import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';
import 'package:scc_web/helper/app_scale.dart';
import 'package:scc_web/shared_widgets/custom_textfield.dart';
import 'package:scc_web/theme/colors.dart';
import 'package:scc_web/widgets/dashboard/detail-transcation/detail_table.dart';
import 'package:scc_web/widgets/dashboard/detail-transcation/title_detail_transaction.dart';

class DetailTransaction extends StatefulWidget {
  final String type;
  const DetailTransaction({super.key, required this.type});

  @override
  State<DetailTransaction> createState() => _DetailTransactionState();
}

class _DetailTransactionState extends State<DetailTransaction> {
  late TextEditingController searchCo;
  String? searchVal;
  final ScrollController scrollController = ScrollController();
  @override
  void initState() {
    searchCo = TextEditingController();
    super.initState();
  }

  onSearch(String? value) {
    print(value);
  }

  @override
  Widget build(BuildContext context) {
    return PointerInterceptor(
        child: Dialog(
            backgroundColor: Colors.transparent,
            child: Scrollbar(
              thumbVisibility: false,
              controller: scrollController,
              child: Container(
                  width: context.deviceWidth() * 0.85,
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: sccWhite,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ListView(
                    controller: scrollController,
                    shrinkWrap: true,
                    children: [
                      Column(
                        children: [
                          Container(
                              padding: const EdgeInsets.only(right: 15.0),
                              child: const TitleDetailTransaction(
                                  title: "Toyota Plant 3, Karawang")),
                          const SizedBox(
                            height: 30.0,
                          ),
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text("Transaction Time",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontSize: 14.0,
                                    color: sccBlack,
                                    fontWeight: FontWeight.w600)),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text("Last Update 12:59 PM",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontSize: 14.0,
                                    color: sccMapZoomSeperator.withOpacity(0.5),
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.w400)),
                          ),
                          const Divider(
                            color: sccLightGrayDivider,
                            height: 25,
                            thickness: 2,
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text("Transaction List",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontSize: 14.0,
                                    color: sccBlack,
                                    fontWeight: FontWeight.w600)),
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: context.deviceWidth() * 0.25,
                                child: PlainSearchField(
                                  controller: searchCo,
                                  fillColor: sccFieldColor,
                                  hint: 'Search Transaction By Item Name or ID',
                                  prefix: searchCo.text.isNotEmpty
                                      ? IconButton(
                                          hoverColor: Colors.transparent,
                                          splashColor: Colors.transparent,
                                          onPressed: () {
                                            setState(() {
                                              searchCo.clear();
                                              searchVal = '';
                                            });
                                            onSearch(searchVal);
                                          },
                                          icon: const HeroIcon(
                                            HeroIcons.xCircle,
                                            color: sccText4,
                                          ),
                                        )
                                      : null,
                                  onChanged: (value) {
                                    setState(() {
                                      searchVal = value ?? "";
                                    });
                                  },
                                  borderRadius: 8,
                                  borderRadiusTopLeft: 0,
                                  borderRadiusBotLeft: 0,
                                  suffixSize: 48,
                                  onAction: (value) {
                                    onSearch(value);
                                  },
                                  onSearch: () {
                                    onSearch(searchVal);
                                  },
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Text("Dead Stock Supply",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          fontSize: 14.0,
                                          color: sccBlack,
                                          fontWeight: FontWeight.w600)),
                                  const SizedBox(
                                    width: 10.0,
                                  ),
                                  Icon(Icons.warning,
                                      color: Colors.red,
                                      size: context.scaleFont(14)),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          const DetailTable(title: "Outbound")
                        ],
                      )
                    ],
                  )),
            )));
  }
}
