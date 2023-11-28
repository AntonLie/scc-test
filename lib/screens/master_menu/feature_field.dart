import 'package:flutter/material.dart';
import 'package:scc_web/helper/app_scale.dart';
import 'package:scc_web/helper/constant.dart';
import 'package:scc_web/screens/inventory/scc_typeahead.dart';
import 'package:scc_web/theme/colors.dart';
import 'package:styled_text/styled_text.dart';

class FeatureField extends StatefulWidget {
  final Function(String?) onChange;
  final Function() onPreview;
  final bool removable;
  final bool? fromDetail;
  final String? value;
  final Function(Key?) onClose;
  const FeatureField({
    required this.onClose,
    required this.value,
    this.fromDetail,
    required this.onChange,
    required this.removable,
    required this.onPreview,
    Key? key,
  }) : super(key: key);

  @override
  State<FeatureField> createState() => _FeatureFieldState();
}

class _FeatureFieldState extends State<FeatureField> {
  String? selectedItem;

  @override
  void initState() {
    selectedItem = widget.value;
    WidgetsBinding.instance.addPostFrameCallback((_) {});
    super.initState();
  }

  @override
  void didUpdateWidget(FeatureField oldWidget) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        selectedItem = widget.value;
      });
    });
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              StyledText(
                text:
                    'Feature${(widget.fromDetail == true && !widget.removable) ? ' <r>*</r>' : ''}',
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
              Visibility(
                visible: widget.removable,
                child: TextButton(
                  onPressed: () => widget.onClose(widget.key),
                  child: Text(
                    "Remove",
                    style: TextStyle(
                      color: sccRed,
                      fontSize: context.scaleFont(14),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          SccTypeAhead(
            selectedItem: selectedItem,
            url: Constant.mstFeatureUrl,
            apiKey: "featureName",
            // apiKeyValue: "roleCd",
            hintText: "Input Feature",
            fillColor: sccWhite,
            enableBorderColor: true,
            onLogout: () {
              // context.push(LoginRoute());
            },
            onError: (value) {
              // showTopSnackBar(context, UpperSnackBar.error(message: value ?? "Error occured"));
            },
            onStrChange: (value) {
              setState(() {
                selectedItem = value;
              });
              widget.onChange(value);
            },
            onSelectionChange: (value) {
              setState(() {
                selectedItem = value;
              });
              widget.onChange(value);
            },
            validator: (value) {
              if (selectedItem?.trim().isEmpty == true) {
                return "This Field is Mandatory";
              } else if (!RegExp(r'^[a-zA-Z0-9\s\_]*$')
                  .hasMatch(selectedItem?.trim() ?? "")) {
                return "Only alphanumeric, spaces, and underscores are allowed";
              } else {
                return null;
              }
            },
          ),
        ],
      ),
    );
  }
}
