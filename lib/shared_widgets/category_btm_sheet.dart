import 'package:flutter/material.dart';
import 'package:scc_web/helper/app_scale.dart';
import 'package:scc_web/helper/keyval.dart';
import 'package:scc_web/shared_widgets/gradient_widgets.dart';
import 'package:scc_web/shared_widgets/outline_gradient_button.dart';
import 'package:scc_web/theme/colors.dart';

class BottomSheetOptions extends StatefulWidget {
  final List<KeyVal> options;
  final String title;
  final KeyVal? value;
  final Function(KeyVal?) onChanged;
  const BottomSheetOptions(
      {required this.value,
      required this.title,
      required this.options,
      required this.onChanged,
      Key? key})
      : super(key: key);

  @override
  State<BottomSheetOptions> createState() => _BottomSheetStateOptions();
}

class _BottomSheetStateOptions extends State<BottomSheetOptions> {
  List<KeyVal> options = [];
  KeyVal? value;
  @override
  void initState() {
    options.addAll(widget.options);
    value = widget.value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: context.deviceHeight() * 0.8,
      padding: const EdgeInsets.only(top: 12, left: 8, right: 8),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25.0),
          topRight: Radius.circular(25.0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          Text(
            "Filter",
            style: TextStyle(
              fontSize: context.scaleFont(18),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            widget.title,
            style: TextStyle(
              fontSize: context.scaleFont(18),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: AnimatedSize(
              duration: const Duration(
                milliseconds: 500,
              ),
              child: ListView.builder(
                itemCount: options.isNotEmpty ? options.length : 1,
                // shrinkWrap: true,
                itemBuilder: (context, index) {
                  if (options.isNotEmpty) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      child: ListTile(
                        dense: true,
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 8),
                        hoverColor: Colors.transparent,
                        horizontalTitleGap: 8,
                        minLeadingWidth: 10,
                        onTap: () {
                          setState(() {
                            value = options[index];
                          });
                          widget.onChanged(value);
                        },
                        leading: OutlineGradientButton(
                          onTap: () {
                            setState(() {
                              value = options[index];
                            });
                            widget.onChanged(value);
                          },
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: value != null &&
                                    value!.value == options[index].value
                                ? [
                                    sccButtonLightBlue,
                                    sccButtonBlue,
                                  ]
                                : [
                                    sccInfoGrey,
                                    sccInfoGrey,
                                  ],
                          ),
                          strokeWidth: value != null &&
                                  value!.value == options[index].value
                              ? 1
                              : 0.5,
                          padding: const EdgeInsets.all(1),
                          radius: const Radius.circular(125),
                          child: FittedBox(
                            // fit: ,
                            child: GradientWidget(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: value != null &&
                                        value!.value == options[index].value
                                    ? [
                                        sccButtonLightBlue,
                                        sccButtonBlue,
                                      ]
                                    : [
                                        Colors.transparent,
                                        Colors.transparent,
                                      ],
                              ),
                              child: const Icon(
                                Icons.circle,
                                // size: context.scaleFont(16),
                              ),
                            ),
                          ),
                        ),
                        title: Text(
                          options[index].label,
                          style: TextStyle(
                            color: sccBlack,
                            fontSize: context.scaleFont(12),
                            overflow: TextOverflow.clip,
                          ),
                        ),
                      ),
                    );
                  } else {
                    return Center(
                      child: Text(
                        "There is No Data",
                        style: TextStyle(
                          fontSize: context.scaleFont(16),
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
