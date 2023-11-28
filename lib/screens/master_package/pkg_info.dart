import 'package:flutter/material.dart';
import 'package:scc_web/helper/app_scale.dart';
import 'package:scc_web/model/pkg_list.dart';
import 'package:scc_web/shared_widgets/custom_textfield.dart';
import 'package:scc_web/theme/colors.dart';
import 'package:styled_text/styled_text.dart';

class PkgInfoForm extends StatefulWidget {
  final PackageInfo? value;
  final int index;
  final bool removable, enabled;
  final Function() onClose;
  final Function(String?) onChange;
  final Function(String?) onChangeDesc;
  const PkgInfoForm({
    required this.value,
    required this.index,
    required this.removable,
    required this.enabled,
    required this.onChange,
    required this.onClose,
    Key? key,
    required this.onChangeDesc,
  }) : super(key: key);

  @override
  State<PkgInfoForm> createState() => _PkgInfoFormState();
}

class _PkgInfoFormState extends State<PkgInfoForm> {
  late TextEditingController textCo;
  late TextEditingController textCd;
  @override
  void initState() {
    textCo = TextEditingController(text: widget.value!.packageInfo ?? "");
    textCd = TextEditingController(text: widget.value!.packageInfoDesc ?? "");
    super.initState();
  }

  @override
  void didUpdateWidget(PkgInfoForm oldWidget) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      textCo.value = textCo.value.copyWith(text: widget.value!.packageInfo);
      textCd.value = textCd.value.copyWith(text: widget.value!.packageInfoDesc);
    });
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            StyledText(
              text: 'Package Info ${widget.index + 1}<r>*</r> ',
              style: TextStyle(fontSize: context.scaleFont(16)),
              tags: {
                'r': StyledTextTag(
                    style: TextStyle(
                        fontSize: context.scaleFont(16), color: sccDanger)),
              },
            ),
            Visibility(
              visible: widget.removable && widget.enabled,
              replacement: const SizedBox(),
              child: TextButton(
                onPressed: () {
                  widget.onClose();
                },
                child: Text(
                  "Remove info",
                  style:
                      TextStyle(color: sccRed, fontSize: context.scaleFont(14)),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        CustomFormTextField(
          controller: textCo,
          hint: 'Input Package info',
          // inputType: TextInputType.numberWithOptions(decimal: true),
          inputType: TextInputType.text,
          enabled: widget.enabled,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "This field is mandatory";
            } else {
              return null;
            }
          },
          onChanged: (value) {
            widget.onChange(value);
          },
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            StyledText(
              text: 'Package Info desc ${widget.index + 1}<r>*</r> ',
              style: TextStyle(fontSize: context.scaleFont(16)),
              tags: {
                'r': StyledTextTag(
                    style: TextStyle(
                        fontSize: context.scaleFont(16), color: sccDanger)),
              },
            ),
          ],
        ),
        const SizedBox(height: 10),
        CustomFormTextField(
          controller: textCd,
          hint: 'Input Package desc',
          // inputType: TextInputType.numberWithOptions(decimal: true),
          inputType: TextInputType.text,
          maxLine: 5,
          enabled: widget.enabled,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "This field is mandatory";
            } else {
              return null;
            }
          },
          onChanged: (value) {
            widget.onChangeDesc(value);
          },
        ),
      ],
    );
  }
}
