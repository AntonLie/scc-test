import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:scc_web/helper/app_scale.dart';
import 'package:scc_web/model/traceability_model.dart';
import 'package:scc_web/screens/Traceability/traceability_card.dart';
import 'package:scc_web/shared_widgets/custom_textfield.dart';
import 'package:scc_web/theme/colors.dart';

class TableConsume extends StatefulWidget {
  final bool? isHovered;
  final String? selectedTrace;
  final List<ListTraceability> listConsume;
  final Function(ListTraceability) onClick;
  final Function(String) onTap, onChanged;
  final Function() onSearch, onpress;

  const TableConsume({
    super.key,
    this.isHovered,
    required this.onClick,
    this.selectedTrace,
    required this.onTap,
    required this.onSearch,
    required this.onChanged,
    required this.onpress,
    required this.listConsume,
  });

  @override
  State<TableConsume> createState() => _TableConsumeState();
}

class _TableConsumeState extends State<TableConsume> {
  late TextEditingController searchCo;
  bool hover = false;

  @override
  void initState() {
    searchCo = TextEditingController();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          height: context.deviceHeight() * 0.06,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "Item Name",
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: context.scaleFont(18),
                    color: sccBlack),
              ),
              SizedBox(
                width: 5,
              ),
              SizedBox(
                // flex: 2,
                width: context.deviceWidth() * 0.17,
                child: PlainSearchField(
                  onChanged: (val) {
                    widget.onChanged(val ?? "");
                  },
                  onSearch: () {
                    widget.onSearch();
                  },
                  hint: 'Search here..',
                  fillColor: sccWhite,
                  controller: searchCo,
                  borderRadius: 8,
                  borderRadiusTopLeft: 8,
                  borderRadiusBotLeft: 8,
                  borderColor: sccBorder,
                  prefix: searchCo.text.isNotEmpty
                      ? IconButton(
                          // splashRadius: 0,
                          hoverColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          onPressed: () {
                            setState(() {
                              searchCo.clear();
                            });
                            widget.onpress();
                          },
                          icon: const HeroIcon(
                            HeroIcons.xCircle,
                            color: sccText4,
                          ),
                        )
                      : null,
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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: TraceabilityCard(
            trace: true,
            colorBg: sccBackground,
            listTrace: widget.listConsume,
            traceTouch: (value) {
              widget.onClick(value);
            },
          ),
        )
      ],
    );
  }
}
