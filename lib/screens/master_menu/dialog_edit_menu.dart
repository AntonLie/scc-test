// ignore_for_file: library_private_types_in_public_api, implementation_imports

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heroicons/heroicons.dart';
import 'package:scc_web/bloc/master_menu/bloc/master_menu_bloc.dart';
import 'package:scc_web/helper/app_scale.dart';
import 'package:scc_web/helper/assisted_auto_route.dart';
import 'package:scc_web/helper/constant.dart';
import 'package:scc_web/helper/utils.dart';
import 'package:scc_web/model/feature.dart';
import 'package:scc_web/model/menu_model.dart';
import 'package:scc_web/screens/master_menu/feature_field.dart';
import 'package:universal_html/html.dart';
import '../../shared_widgets/buttons.dart';
import '../../theme/colors.dart';
import 'package:flutter/src/widgets/text.dart' as widgets;

class LovMenu extends StatefulWidget {
  final Function(String) onError;
  final Function() onSuccess, onLogout;
  final MenuModel? model;
  // final bool viewMode;

  const LovMenu({
    required this.onError,
    required this.model,
    // required this.viewMode,
    required this.onSuccess,
    required this.onLogout,
    Key? key,
  }) : super(key: key);

  @override
  State<LovMenu> createState() => _LovMenuState();
}

class _LovMenuState extends State<LovMenu> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MasterMenuBloc()
        ..add(ToMenuFeatDialog(
          menu: widget.model,
          // paging: Paging(pageNo: 1, pageSize: 99999),
          // usecaseCd: "",
        )),
      child: LovMenuBody(
        // viewMode: widget.viewMode,
        onError: (value) => widget.onError(value),
        onLogout: () => widget.onLogout(),
        onSuccess: () => widget.onSuccess(),
        // model: widget.model,
        // listUsecase: (value) => widget.listUsecase(value),
      ),
    );
  }
}

class LovMenuBody extends StatefulWidget {
  final Function(String) onError;
  final Function() onSuccess, onLogout;
  final MenuModel? model;
  // final bool viewMode;
  const LovMenuBody({
    required this.onError,
    // required this.viewMode,
    required this.onSuccess,
    required this.onLogout,
    this.model,
    Key? key,
  }) : super(key: key);

  @override
  _LovMenuBodyState createState() => _LovMenuBodyState();
}

class _LovMenuBodyState extends State<LovMenuBody> {
  GlobalKey<FormState> key = GlobalKey<FormState>();
  // late ScrollController controller;
  late ScrollController vController;
  bool validateList = false;
  MenuModel submitModel = MenuModel();
  List<String> features = [];

  @override
  void initState() {
    if (widget.model != null) {
      submitModel = widget.model!;
    }
    // title = widget.partNo;
    // controller = ScrollController();
    vController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bloc(MasterMenuEvent event) {
      BlocProvider.of<MasterMenuBloc>(context).add(event);
    }

    return Dialog(
      insetPadding: kIsWeb && !isWebMobile
          ? EdgeInsets.symmetric(
              horizontal: (context.deviceWidth() * 0.15),
              vertical: (context.deviceHeight() * 0.1),
            )
          : const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: MultiBlocListener(
        listeners: [
          BlocListener<MasterMenuBloc, MasterMenuState>(
            listener: (context, state) {
              if (state is MenuFeatLoaded) {
                submitModel = state.model;
                List<Feature> listFeature =
                    (submitModel.listFeature?.isNotEmpty == true)
                        ? submitModel.listFeature!
                        : [Feature(featureName: "")];
                features.clear();
                setState(() {
                  for (var element in listFeature) {
                    if (element.featureName != null) {
                      features.add(element.featureName!);
                    }
                  }
                });
              }
              if (state is MenuFeatUpdated) {
                context.closeDialog();
                widget.onSuccess();
              }
              if (state is MasterMenuError) {
                context.closeDialog();
                widget.onError(state.error);
              }
              if (state is OnLogoutMasterMenu) {
                context.closeDialog();
                widget.onLogout();
              }
            },
          ),
        ],
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    BlocBuilder<MasterMenuBloc, MasterMenuState>(
                      builder: (context, state) {
                        return widgets.Text(
                          'Menu ${submitModel.menuName ?? "[UNIDENTIFIED MENU]"}',
                          style: TextStyle(
                            fontSize: context.scaleFont(24),
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      },
                    ),
                    BlocBuilder<MasterMenuBloc, MasterMenuState>(
                      builder: (context, state) {
                        return IconButton(
                          onPressed: () {
                            if (state is! UpdateMenuFeatLoading) {
                              context.back();
                            }
                          },
                          icon: const HeroIcon(HeroIcons.xCircle),
                          splashRadius: 20,
                        );
                      },
                    ),
                  ],
                ),
              ),
              const Divider(
                color: sccLightGrayDivider,
                height: 25,
                thickness: 2,
              ),
              BlocBuilder<MasterMenuBloc, MasterMenuState>(
                builder: (context, state) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ConstrainedBox(
                        constraints: BoxConstraints(
                            maxHeight: context.deviceHeight() * 0.5),
                        child: Scrollbar(
                          controller: vController,
                          child: SingleChildScrollView(
                            controller: vController,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            // scrollDirection: Axis.vertical,
                            child: Form(
                              key: key,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ListView.builder(
                                    itemCount: features.isNotEmpty
                                        ? features.length
                                        : 1,
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemBuilder: (ctx, i) {
                                      if (features.isNotEmpty) {
                                        return FeatureField(
                                          value: features[i],
                                          removable: i > 0,
                                          onPreview: () {
                                            String url = window.location.href;
                                            List<String> baseUri =
                                                url.split(Constant.pathFe);
                                            launchUrl(
                                              url: baseUri[0] +
                                                  Constant.pathFe +
                                                  mapUrlTail(
                                                      submitModel.menuCd),
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
                                          padding:
                                              const EdgeInsets.only(left: 24),
                                          child: widgets.Text(
                                            'Detail list must not empty',
                                            style: TextStyle(
                                              fontSize: context.scaleFont(16),
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .error,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: isMobile
                              ? MainAxisAlignment.center
                              : MainAxisAlignment.end,
                          children: [
                            ButtonCancel(
                              text: "Cancel",
                              width: context.deviceWidth() *
                                  (context.isDesktop() ? 0.11 : 0.35),
                              onTap: () {
                                if (state is! UpdateMenuFeatLoading) {
                                  context.back();
                                }
                              },
                            ),
                            SizedBox(
                              width: 8.wh,
                            ),
                            ButtonConfirm(
                              text: "Save",
                              onTap: () {
                                setState(() {
                                  validateList = features.isEmpty;
                                });
                                if ((key.currentState?.validate() == true) &&
                                    !validateList &&
                                    (state is! UpdateMenuFeatLoading)) {
                                  submitModel.features = List.from(features);
                                  bloc(UpdateMenuFeat(submitModel));
                                }
                              },
                              width: context.deviceWidth() *
                                  (context.isDesktop() ? 0.1 : 0.35),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
