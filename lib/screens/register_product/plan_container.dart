// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:scc_web/bloc/package/bloc/package_bloc.dart';

import 'package:scc_web/helper/app_scale.dart';

import 'package:scc_web/helper/constant.dart';
import 'package:scc_web/helper/drag_behaviour.dart';
import 'package:scc_web/model/pricing.dart';
import 'package:scc_web/screens/register_product/plan_item.dart';

import 'package:scc_web/shared_widgets/empty_container.dart';
import 'package:scc_web/shared_widgets/snackbars.dart';
import 'package:scc_web/theme/colors.dart';

class PricingContainer extends StatefulWidget {
  final Function() adminContacted;
  const PricingContainer({super.key, required this.adminContacted});

  @override
  State<PricingContainer> createState() => _PricingContainerState();
}

class _PricingContainerState extends State<PricingContainer> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PackageBloc()..add(GetPricing()),
      child: PricingBody(
        adminContacted: () => widget.adminContacted(),
      ),
    );
  }
}

class PricingBody extends StatefulWidget {
  final Function() adminContacted;
  const PricingBody({super.key, required this.adminContacted});

  @override
  State<PricingBody> createState() => _PricingBodyState();
}

class _PricingBodyState extends State<PricingBody> {
  String selectedPeriod = Constant.yearly;
  List<Pricing> listModel = [];
  bool loaded = false;
  bool isHovered = false;
  String selectedPlan = '';
  final controller = ScrollController();
  bloc(dynamic event) {
    BlocProvider.of<PackageBloc>(context).add(event);
  }

  @override
  void initState() {
    bloc(GetPricing());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PackageBloc, PackageState>(
      listener: (context, state) {
        if (state is LoadPricing) {
          setState(() {
            listModel = List.from(state.listPricing);
            loaded = true;
          });
        }
        if (state is PackageError) {
          showTopSnackBar(context, UpperSnackBar.error(message: state.error));
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            height: 10,
          ),
          Container(
            decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(width: 0.3, color: sccButtonPurple)),
            padding: const EdgeInsets.all(2),
            width: context.deviceWidth() * 0.15,
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      if (selectedPeriod != Constant.yearly) {
                        setState(() {
                          selectedPeriod = Constant.yearly;
                        });
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: selectedPeriod == Constant.yearly
                            ? sccButtonPurple
                            : sccWhite,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 4,
                      ),
                      child: Center(
                        child: Text(
                          'Yearly',
                          style: TextStyle(
                            fontSize: context.scaleFont(16),
                            fontWeight: selectedPeriod == Constant.yearly
                                ? FontWeight.w200
                                : FontWeight.w400,
                            color: selectedPeriod == Constant.yearly
                                ? sccWhite
                                : sccButtonBlue,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      if (selectedPeriod != Constant.monthly) {
                        setState(() {
                          selectedPeriod = Constant.monthly;
                        });
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: selectedPeriod == Constant.monthly
                            ? sccButtonPurple
                            : sccWhite,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 4,
                      ),
                      child: Center(
                        child: Text(
                          'Monthly',
                          style: TextStyle(
                            fontSize: context.scaleFont(16),
                            fontWeight: selectedPeriod == Constant.monthly
                                ? FontWeight.w200
                                : FontWeight.w400,
                            color: selectedPeriod == Constant.monthly
                                ? sccWhite
                                : sccButtonBlue,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Gap(20),
          Visibility(
            visible: listModel.isNotEmpty,
            child: ScrollConfiguration(
              behavior: DragBehavior(),
              child: Scrollbar(
                controller: controller,
                child: SingleChildScrollView(
                  controller: controller,
                  padding: const EdgeInsets.only(bottom: 12),
                  physics: const ClampingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  child: IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: listModel.map((e) {
                        return PricingItem(
                          onExitHover: () {
                            setState(() {
                              selectedPlan = '';
                            });
                          },
                          onHover: (val) {
                            setState(() {
                              selectedPlan = val;
                            });
                          },
                          plan: selectedPlan,
                          model: e,
                          price: (selectedPeriod == Constant.yearly)
                              ? e.priceYearly
                              : e.priceMonthly,
                          adminContacted: () => widget.adminContacted(),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Visibility(
            visible: loaded == true && listModel.isEmpty,
            child: EmptyData(),
          ),
        ],
      ),
    );
  }

  onHoverActivation(hoverState) {
    setState(() {
      isHovered = hoverState;
    });
   
  }
}
