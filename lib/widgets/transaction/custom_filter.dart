import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:scc_web/helper/app_scale.dart';
import 'package:scc_web/shared_widgets/buttons.dart';
import 'package:scc_web/shared_widgets/scc_calendar.dart';
import 'package:scc_web/theme/colors.dart';
import 'package:scc_web/widgets/transaction/filter_divider.dart';
import 'package:scc_web/widgets/transaction/radio_blockchain.dart';
import 'package:scc_web/widgets/transaction/radio_sort.dart';
import 'package:scc_web/widgets/transaction/radio_touchpoint.dart';
import 'package:scc_web/widgets/transaction/select_filter.dart';

class CustomFilter extends StatefulWidget {
  final double? width;

  const CustomFilter({
    super.key,
    this.width,
  });

  @override
  State<CustomFilter> createState() => _CustomFilterState();
}

class _CustomFilterState extends State<CustomFilter> {
  @override
  Widget build(BuildContext context) {
    return const CustomDropDown();
  }
}

class CustomDropDown extends StatefulWidget {
  const CustomDropDown({
    super.key,
  });

  @override
  State<StatefulWidget> createState() => CustomDropDownState();
}

class CustomDropDownState extends State<CustomDropDown> {
  final OverlayPortalController _tooltipController = OverlayPortalController();

  final _link = LayerLink();

  /// width of the button after the widget rendered
  double? _buttonWidth;

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _link,
      child: OverlayPortal(
        controller: _tooltipController,
        overlayChildBuilder: (BuildContext context) {
          return CompositedTransformFollower(
            link: _link,
            targetAnchor: Alignment.bottomLeft,
            child: Align(
              alignment: AlignmentDirectional.topStart,
              child: MenuWidget(
                  width: _buttonWidth, tooltipController: _tooltipController),
            ),
          );
        },
        child: ButtonWidget(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Filter By",
                    style:
                        TextStyle(color: Colors.grey.shade400, fontSize: 14.0),
                  ),
                  const SizedBox(
                    width: 20.0,
                  ),
                  Icon(
                    Icons.filter_alt_outlined,
                    color: Colors.grey.shade400,
                    size: 14.0,
                  )
                ],
              ),
            )),
      ),
    );
  }

  void onTap() {
    _buttonWidth = context.size?.width;
    _tooltipController.toggle();
  }
}

class ButtonWidget extends StatelessWidget {
  const ButtonWidget({
    super.key,
    this.height = 40,
    this.width,
    this.onTap,
    this.child,
  });

  final double? height;
  final double? width;

  final VoidCallback? onTap;

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: 150.0,
      child: Material(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: Colors.grey.shade400),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Center(
            child: child ?? const SizedBox(),
          ),
        ),
      ),
    );
  }
}

class MenuWidget extends StatelessWidget {
  final OverlayPortalController tooltipController;
  const MenuWidget({super.key, this.width, required this.tooltipController});

  final double? width;

  @override
  Widget build(BuildContext context) {
    DateTime? startDtSelected;
    DateTime? endDtSelected;
    bool reset = false;

    void handleResetDate(bool value) {
      reset = value;
    }

    void handleDateSelected(DateTime? startDate, DateTime? endDate) {
      startDtSelected = startDate;
      endDtSelected = endDate;
    }

    void handleEndDate(DateTime value) {
      endDtSelected = value;
    }

    return Container(
      width: 500.0,
      margin: const EdgeInsets.only(top: 10.0),
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Filter By",
                style: TextStyle(
                    color: sccPrimaryDashboard,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w600),
              ),
              InkWell(
                onTap: () => {tooltipController.toggle()},
                child: Container(
                  height: 18,
                  width: 18,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(16)),
                    color: sccMapZoomSeperator.withOpacity(0.5),
                  ),
                  child: HeroIcon(
                    HeroIcons.xMark,
                    color: sccWhite,
                    size: context.scaleFont(17),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10.0,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SelectableText(
                'Period',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: context.scaleFont(14),
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              SizedBox(
                height: 48,
                child: SccPeriodPicker(
                  isRTL: true,
                  defaultToday: true,
                  reset: reset,
                  onFinishedBuild: () {
                    handleResetDate(false);
                  },
                  onRangeDateSelected: (val) {
                    var startDate = val?.start;
                    var endDate = val?.end;

                    handleDateSelected(startDate, endDate);
                  },
                  onStartDateChanged: (val) {
                    handleDateSelected(val, val);
                  },
                  onEndDateChanged: (val) {
                    handleEndDate(val);
                  },
                ),
              ),
            ],
          ),
          const FilterDivider(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SelectableText(
                'Business Use Case',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: context.scaleFont(14),
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              SelectFilter()
            ],
          ),
          const FilterDivider(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SelectableText(
                'Blockchain',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: context.scaleFont(14),
                  fontWeight: FontWeight.w400,
                ),
              ),
              const RadioBlockChain(),
            ],
          ),
          const FilterDivider(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SelectableText(
                'Touch Point Type',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: context.scaleFont(14),
                  fontWeight: FontWeight.w400,
                ),
              ),
              const RadioTouchPoint(),
            ],
          ),
          const FilterDivider(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SelectableText(
                'Sort by',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: context.scaleFont(14),
                  fontWeight: FontWeight.w400,
                ),
              ),
              const RadioSort(),
            ],
          ),
          const SizedBox(
            height: 20.0,
          ),
          ButtonConfirm(
              colour: sccPrimaryDashboard,
              text: "Search",
              width: double.infinity,
              borderRadius: 5,
              padding: 1,
              boxShadowColor: sccWhite.withOpacity(0.3),
              onTap: () => {})
        ],
      ),
    );
  }
}
