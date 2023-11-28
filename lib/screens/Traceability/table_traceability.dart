import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:scc_web/helper/app_scale.dart';
import 'package:scc_web/model/traceability_model.dart';
import 'package:scc_web/shared_widgets/custom_textfield.dart';
import 'package:scc_web/theme/colors.dart';

class TableTraceability extends StatefulWidget {
  final List<ListId>? listTrace;

  final bool? isHovered;
  final String? selectedTrace;
  final Function(String) onHover;
  final Function(String) onTap, onChanged;
  final Function() onSearch, onpress;

  const TableTraceability({
    super.key,
    this.listTrace,
    this.isHovered,
    required this.onHover,
    this.selectedTrace,
    required this.onTap,
    required this.onSearch,
    required this.onChanged,
    required this.onpress,
  });

  @override
  State<TableTraceability> createState() => _TableTraceabilityState();
}

class _TableTraceabilityState extends State<TableTraceability> {
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "ITEM ID (100)",
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: context.scaleFont(18),
                    color: sccBlack),
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
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          height: context.deviceHeight() * 0.07,
          child: Row(
            children: [
              Text(
                "No",
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: context.scaleFont(12),
                    color: sccNavText2),
              ),
              const SizedBox(
                width: 20,
              ),
              Text(
                "Item ID",
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: context.scaleFont(12),
                    color: sccNavText2),
              ),
            ],
          ),
        ),
        Column(
          children: widget.listTrace!
              .map((e) => MouseRegion(
                    onHover: (event) {
                      widget.onHover(e.itemId!);
                    },
                    child: InkWell(
                      onTap: () {
                        widget.onTap(e.itemId!);
                      },
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 200),
                        decoration: BoxDecoration(
                          color: widget.selectedTrace == e.itemId
                              ? sccChildTrackFilling
                              : sccWhite,
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              e.no.toString(),
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: context.scaleFont(12),
                                  color: widget.selectedTrace == e.itemId
                                      ? sccNavText2
                                      : sccBlack),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Text(
                              e.itemId ?? "-",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: context.scaleFont(12),
                                  color: widget.selectedTrace == e.itemId
                                      ? sccNavText2
                                      : sccBlack),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ))
              .toList(),
        ),
      ],
    );
  }
}
