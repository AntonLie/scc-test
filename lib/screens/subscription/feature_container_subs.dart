import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heroicons/heroicons.dart';
import 'package:scc_web/bloc/package/bloc/package_bloc.dart';
import 'package:scc_web/helper/app_route.gr.dart';
import 'package:scc_web/helper/app_scale.dart';
import 'package:scc_web/helper/assisted_auto_route.dart';
import 'package:scc_web/helper/drag_behaviour.dart';
import 'package:scc_web/model/subs_features.dart';
import 'package:scc_web/screens/register_product/title_section.dart';
import 'package:scc_web/screens/subscription/feature_item_subs.dart';
import 'package:scc_web/shared_widgets/empty_container.dart';
import 'package:scc_web/shared_widgets/expandable_widget.dart';
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
  // List<SubsFeatures> listModel = [];
  List<SubsFeatures> listCompact = [];
  Map<String, Map<String, dynamic>> completeComp = {};
  // Map<String, dynamic> completeBody = {};
  Map<String, bool> mapExpansion = {};
  bool loaded = false;
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
            // completeBody.addAll(state.completeBody);
            loaded = true;
          });
        }
        if (state is PackageError) {
          showTopSnackBar(context, UpperSnackBar.error(message: state.error));
        }
        if (state is OnLogout) {
          context.push(const LoginRoute());
        }
      },
      child: Visibility(
        //! visible: completeBody.entries.isNotEmpty && listModel.isNotEmpty,
        visible: completeComp.entries.isNotEmpty && listCompact.isNotEmpty,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,

          // crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: () {
                setState(() {
                  expand = !expand;
                  if (expand) {
                    _controller.forward(from: 0.0);
                  } else {
                    _controller.reverse(from: 0.5);
                  }
                });
              },
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: sccWhite,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                  shape: BoxShape.circle,
                ),
                child: RotationTransition(
                  turns: Tween(begin: 0.0, end: 0.5).animate(_controller),
                  child: HeroIcon(
                    HeroIcons.chevronDown,
                    style: HeroIconStyle.solid,
                    color: sccBlack,
                    size: context.scaleFont(30),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            ExpandableWidget(
              expand: expand,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Compare Features',
                    style: TextStyle(
                      fontSize: context.scaleFont(28),
                      fontWeight: FontWeight.bold,
                      color: sccBlack,
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  MouseRegion(
                    onExit: (val) {
                      setState(() {
                        selectedRow = '';
                      });
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(
                              height: 120,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: completeComp.entries.isNotEmpty
                                  ? completeComp.entries.map((e) {
                                      return TitleSection(
                                          title: e.key,
                                          map: e.value,
                                          isExpanded:
                                              (mapExpansion[e.key] == true),
                                          selectedRow: selectedRow,
                                          onExpansionChange: () {
                                            setState(() {
                                              mapExpansion[e.key] =
                                                  !(mapExpansion[e.key] ??
                                                      false);
                                            });
                                          },
                                          onHover: (value) {
                                            setState(() {
                                              selectedRow = value;
                                            });
                                          },
                                          onExitHover: () {
                                            setState(() {
                                              selectedRow = '';
                                            });
                                          });
                                    }).toList()
                                  : [],
                            )
                          ],
                        ),
                        Expanded(
                          child: Visibility(
                            // visible: listModel.isNotEmpty,
                            visible: listCompact.isNotEmpty,
                            child: ScrollConfiguration(
                              behavior: DragBehavior(),
                              child: Scrollbar(
                                thumbVisibility: true,
                                controller: controller,
                                child: SingleChildScrollView(
                                  controller: controller,
                                  padding: const EdgeInsets.only(bottom: 12),
                                  physics: const ClampingScrollPhysics(),
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: listCompact.map((e) {
                                      return FeatureItemNew(
                                          model: e,
                                          selectedRow: selectedRow,
                                          onHover: (val) {
                                            setState(() {
                                              selectedRow = val;
                                            });
                                          },
                                          adminContacted: () =>
                                              widget.adminContacted(),
                                          mapExpansion: mapExpansion,
                                          onExpansionChange: (val) {
                                            setState(() {
                                              mapExpansion[val] =
                                                  !(mapExpansion[val] ?? false);
                                            });
                                          },
                                          onExitHover: () {
                                            setState(() {
                                              selectedRow = '';
                                            });
                                          });
                                    }).toList(),
                                  ),
                                  // ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    // ),
                  ),
                ],
              ),
            ),
            Visibility(
              //! visible: loaded == true && listModel.isEmpty,
              visible: loaded == true && listCompact.isEmpty,
              child: const EmptyContainer(),
            ),
          ],
        ),
      ),
    );
  }
}
