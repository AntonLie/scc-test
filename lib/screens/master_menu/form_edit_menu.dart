// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:scc_web/helper/app_scale.dart';
import 'package:scc_web/helper/constant.dart';
import 'package:scc_web/helper/utils.dart';
import 'package:scc_web/model/feature.dart';
import 'package:scc_web/model/menu_model.dart';
import 'package:scc_web/screens/master_menu/feature_field.dart';
import 'package:scc_web/shared_widgets/buttons.dart';
import 'package:scc_web/shared_widgets/custom_textfield.dart';
import 'package:scc_web/theme/colors.dart';
import 'package:styled_text/styled_text.dart';
import 'package:universal_html/html.dart';

class FormEditMenu extends StatefulWidget {
  final MenuModel? model;
  final Function() onClose;
  final Function(MenuModel) onSubmit;
  const FormEditMenu(
      {required this.onSubmit,
      required this.onClose,
      required this.model,
      Key? key})
      : super(key: key);

  @override
  _FormEditMenuState createState() => _FormEditMenuState();
}

class _FormEditMenuState extends State<FormEditMenu> {
  GlobalKey<FormState> key = GlobalKey<FormState>();
  MenuModel submitModel = MenuModel();
  bool validateList = false;
  bool isSubmitting = false;
  List<String> features = [];
  late TextEditingController menuNameCo;
  late TextEditingController parentMenuCo;
  @override
  void initState() {
    isSubmitting = false;
    if (widget.model != null) {
      submitModel = widget.model!;
      features.clear();
      List<Feature> listFeature = (submitModel.listFeature?.isNotEmpty == true)
          ? submitModel.listFeature!
          : [Feature(featureName: "")];
      for (var element in listFeature) {
        if (element.featureName != null) {
          features.add(element.featureName!);
        }
      }
    }

    menuNameCo = TextEditingController(text: submitModel.menuName);
    parentMenuCo = TextEditingController(text: submitModel.parentMenuName);

    WidgetsBinding.instance.addPostFrameCallback((_) {});
    super.initState();
  }

  @override
  void didUpdateWidget(FormEditMenu oldWidget) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      isSubmitting = false;
    });
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isMobile ? Colors.white : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Form(
        key: key,
        child: FocusTraversalGroup(
          descendantsAreFocusable: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StyledText(
                text: 'Menu <r>*</r>',
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
              const SizedBox(height: 10),
              CustomFormTextField(
                controller: menuNameCo,
                hint: "Menu Name wasn't set",
                enabled: false,
              ),
              const SizedBox(
                height: 20,
              ),
              StyledText(
                text: 'Parent Menu <r>*</r>',
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
              const SizedBox(height: 10),
              CustomFormTextField(
                controller: parentMenuCo,
                hint: "Parent Menu wasn't set",
                enabled: false,
              ),
              const SizedBox(
                height: 20,
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListView.builder(
                    itemCount: features.isNotEmpty ? features.length : 1,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (ctx, i) {
                      if (features.isNotEmpty) {
                        return FeatureField(
                          value: features[i],
                          removable: i > 0,
                          fromDetail: true,
                          onPreview: () {
                            String url = window.location.href;
                            List<String> baseUri = url.split(Constant.pathFe);
                            launchUrl(
                              url: baseUri[0] +
                                  Constant.pathFe +
                                  mapUrlTail(submitModel.menuCd),
                              isNewTab: true,
                            );
                          },
                          onClose: (key) {
                            setState(() {
                              features.removeAt(i);
                            });
                          },
                          onChange: (value) {
                            features[i] = value ?? "";
                          },
                        );
                      } else {
                        return const SizedBox();
                      }
                    },
                  ),
                  DottedAddButton(
                    text: ' Add Feature',
                    width: context.deviceWidth() * 0.12,
                    onTap: () {
                      setState(() {
                        features.add("");
                      });
                    },
                  ),
                  Visibility(
                    visible: validateList,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.only(left: 24),
                          child: Text(
                            'Detail list must not empty',
                            style: TextStyle(
                              fontSize: context.scaleFont(14),
                              fontWeight: FontWeight.w400,
                              color: Theme.of(context).colorScheme.error,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment:
                    isMobile ? MainAxisAlignment.center : MainAxisAlignment.end,
                children: [
                  ButtonCancel(
                    text: "Cancel",
                    width: context.deviceWidth() *
                        (context.isDesktop() ? 0.13 : 0.37),
                    borderRadius: 8,
                    onTap: () {
                      if (!isSubmitting) {
                        widget.onClose();
                      }
                    },
                  ),
                  SizedBox(
                    width: 8.wh,
                  ),
                  ButtonConfirm(
                    text: "Save",
                    borderRadius: 8,
                    // verticalMargin: !isMobile ? 11 : 8,
                    onTap: () {
                      setState(() {
                        validateList = features.isEmpty;
                      });
                      if (key.currentState!.validate() &&
                          !validateList &&
                          !isSubmitting) {
                        isSubmitting = true;
                        submitModel.features = List.from(features);
                        widget.onSubmit(submitModel);
                      }
                    },
                    width: context.deviceWidth() *
                        (context.isDesktop() ? 0.13 : 0.37),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
