import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heroicons/heroicons.dart';
import 'package:scc_web/bloc/package/bloc/package_bloc.dart';
import 'package:scc_web/helper/app_scale.dart';
import 'package:scc_web/helper/assisted_auto_route.dart';
import 'package:scc_web/helper/constant.dart';
import 'package:scc_web/model/subs_features.dart';
import 'package:scc_web/screens/register_product/feature_item.dart';
import 'package:scc_web/screens/register_product/title_section.dart';
import 'package:scc_web/shared_widgets/snackbars.dart';
import 'package:scc_web/theme/colors.dart';


class FeatureContainer extends StatelessWidget {
  final Function() adminContacted;
  const FeatureContainer({required this.adminContacted, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PackageBloc()..add(GetSubsFeatures()),
      child: FeatureBody(
        adminContacted: () => adminContacted(),
      ),
    );
  }
}

class FeatureBody extends StatefulWidget {
  final Function() adminContacted;
  const FeatureBody({required this.adminContacted, Key? key}) : super(key: key);

  @override
  State<FeatureBody> createState() => _FeatureBodyState();
}

class _FeatureBodyState extends State<FeatureBody>
    with SingleTickerProviderStateMixin {
  List<SubsFeatures> listCompact = [];
  Map<String, Map<String, dynamic>> completeComp = {};

  Map<String, bool> mapExpansion = {};

  bool expand = false;
  String selectedRow = '';

  late AnimationController _controller;
  @override
  void initState() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 450),
      vsync: this,
    );
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = ScrollController();
    return BlocListener<PackageBloc, PackageState>(
      listener: (context, state) {
        if (state is LoadSubsFeatures) {
          setState(() {
            //! listModel = List.from(state.listSubsFeatures);
            listCompact = List.from(state.listSubsFeaturesComp);
            completeComp.addAll(state.completeCompact);
            for (var element in completeComp.entries) {
              mapExpansion[element.key] = false;
            }
          });
        }
        if (state is PackageError) {
          showTopSnackBar(context, UpperSnackBar.error(message: state.error));
        }
      },
      child: BlocBuilder<PackageBloc, PackageState>(builder: (context, state) {
        if (state is PackageLoading) {
          return const SizedBox(
            width: 800,
            height: 1280,
            child: Center(
              child: CircularProgressIndicator(
                color: sccButtonBlue,
              ),
            ),
          );
        } else {
          return Visibility(
            //! visible: completeBody.entries.isNotEmpty && listModel.isNotEmpty,
            visible: completeComp.entries.isNotEmpty && listCompact.isNotEmpty,
            child: Dialog(
              insetPadding: kIsWeb && !isWebMobile
                  ? EdgeInsets.symmetric(
                      horizontal: (context.deviceWidth() * 0.1),
                      vertical: (context.deviceHeight() * 0.1),
                    )
                  : const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              backgroundColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              child: Container(
                width: context.deviceWidth() * 0.68,
                decoration: BoxDecoration(
                  color: sccWhite,
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.only(top: 12),
                child: Scrollbar(
                  controller: controller,
                  child: SingleChildScrollView(
                    controller: controller,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const SizedBox(
                                  width: 20,
                                ),
                                Text(
                                  'Compare Features',
                                  style: TextStyle(
                                    fontSize: context.scaleFont(28),
                                    fontWeight: FontWeight.bold,
                                    color: sccBlack,
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    context.closeDialog();
                                  },
                                  child: Container(
                                    height: 20,
                                    width: 20,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        color: sccWhite,
                                        boxShadow: const [
                                          BoxShadow(
                                              color: sccBlack, blurRadius: 2)
                                        ]),
                                    child: HeroIcon(
                                      HeroIcons.xMark,
                                      color: sccButtonPurple,
                                      size: context.scaleFont(28),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 0.1, color: sccButtonBlue),
                                  borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(8),
                                      bottomLeft: Radius.circular(8)),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SizedBox(
                                      height: 120,
                                      child: Center(
                                          child: Text(
                                        "All Features",
                                        style: TextStyle(
                                            fontSize: context.scaleFont(24),
                                            color: sccButtonBlue,
                                            fontWeight: FontWeight.bold),
                                      )),
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: completeComp.entries.isNotEmpty
                                          ? completeComp.entries.map((e) {
                                              return TitleSection(
                                                  title: e.key,
                                                  map: e.value,
                                                  isExpanded:
                                                      (mapExpansion[e.key] ==
                                                          true),
                                                  selectedRow: selectedRow,
                                                  onExpansionChange: () {
                                                    setState(() {
                                                      mapExpansion[e.key] =
                                                          !(mapExpansion[
                                                                  e.key] ??
                                                              false);
                                                    });
                                                  },
                                                  onHover: (value) {
                                                    setState(() {
                                                      selectedRow = value;
                                                    });
                                                  },
                                                  onExitHover: () {
                                                    // setState(() {
                                                    //   selectedRow = '';
                                                    // });
                                                  });
                                            }).toList()
                                          : [],
                                    )
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Visibility(
                                  visible: listCompact.isNotEmpty,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: listCompact.map((e) {
                                      return FeatureItemNew(
                                        model: e,
                                        selectedRow: selectedRow,
                                        adminContacted: () =>
                                            widget.adminContacted(),
                                        mapExpansion: mapExpansion,
                                        onExpansionChange: (val) {},
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        }
      }),
    );
  }
}
