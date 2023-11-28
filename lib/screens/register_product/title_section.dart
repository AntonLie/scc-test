import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:scc_web/helper/app_scale.dart';
import 'package:scc_web/shared_widgets/expandable_widget.dart';
import 'package:scc_web/theme/colors.dart';

class TitleSection extends StatefulWidget {
  final String title;
  final String? selectedRow;
  final Map<String, dynamic> map;
  final bool isExpanded;
  final Function(String) onHover;
  final Function() onExitHover;
  final Function() onExpansionChange;
  const TitleSection({
    required this.selectedRow,
    required this.title,
    required this.onHover,
    required this.onExitHover,
    required this.isExpanded,
    required this.map,
    required this.onExpansionChange,
    Key? key,
  }) : super(key: key);

  @override
  State<TitleSection> createState() => _TitleSectionState();
}

class _TitleSectionState extends State<TitleSection>
    with SingleTickerProviderStateMixin {
  bool isExpanded = false;
  late AnimationController _controller;
  @override
  void initState() {
    isExpanded = widget.isExpanded;
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    super.initState();
  }

  @override
  void didUpdateWidget(TitleSection oldWidget) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (isExpanded != widget.isExpanded) {
        isExpanded = widget.isExpanded;
        if (isExpanded) {
          _controller.forward(from: 0.0);
        } else {
          _controller.reverse(from: 0.5);
        }
      }
    });
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onExit: (val) {
        widget.onExitHover();
      },
      child: SizedBox(
        width: context.deviceWidth() * 0.16,
        child: Column(
          children: [
            InkWell(
              onTap: () {
                widget.onExpansionChange();
                // setState(() {
                // isExpanded = !isExpanded;

                // });
              },
              child: MouseRegion(
                onHover: (val) {
                  widget.onHover(widget.title);
                },
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: widget.selectedRow == widget.title
                        ? sccFillField
                        : Colors.transparent,
                    border: Border.all(style: BorderStyle.none),
                  ),
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Text(
                          widget.title,
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: context.scaleFont(16),
                            color: sccNavText1,
                            overflow: TextOverflow.ellipsis,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      RotationTransition(
                        turns: Tween(begin: 0.0, end: 0.5).animate(_controller),
                        child: Container(
                          height: 20,
                          width: 20,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: sccButtonBlue,
                          ),
                          child: HeroIcon(
                            HeroIcons.chevronDown,
                            color: sccWhite,
                            size: context.scaleFont(18),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      )
                    ],
                  ),
                ),
              ),
            ),
            ExpandableWidget(
              expand: widget.isExpanded,
              // expand: isExpanded,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: widget.map.entries.isNotEmpty
                    ? widget.map.entries.map((e) {
                        //! onHover & color condition
                        return MouseRegion(
                          onHover: (val) {
                            widget.onHover(e.key);
                            // setState(() {
                            //   selectedRow = e.key;
                            // });
                          },
                          child: Container(
                            height: 40,
                            decoration: BoxDecoration(
                              color: widget.selectedRow == e.key
                                  ? sccFillField
                                  : Colors.transparent,
                              border: Border.all(style: BorderStyle.none),
                            ),
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.only(left: 12),
                            child: Builder(builder: (context) {
                              return Text(
                                (e.key).split("_").last,
                                maxLines: 1,
                                style: TextStyle(
                                  fontSize: context.scaleFont(16),
                                  color: sccNavText1,
                                  overflow: TextOverflow.ellipsis,
                                  fontWeight: FontWeight.normal,
                                ),
                              );
                            }),
                          ),
                        );
                      }).toList()
                    : [],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
