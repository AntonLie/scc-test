import 'package:flutter/material.dart';
import 'package:scc_web/helper/app_scale.dart';
import 'package:scc_web/helper/keyval.dart';
import 'package:scc_web/widgets/dashboard/map.dart';

import 'package:scc_web/widgets/dashboard/legend_map.dart';
import 'package:scc_web/widgets/dashboard/overlay/overlay_arrow.dart';
import 'package:scc_web/widgets/dashboard/overlay/overlay_content.dart';
import 'package:scc_web/widgets/dashboard/overlay/overlay_map.dart';
import 'package:scc_web/widgets/dashboard/select-trace/option_trace.dart';
import 'package:scc_web/widgets/dashboard/select-trace/select_trace.dart';
import 'package:scc_web/widgets/dashboard/select-view/option-view.dart';
import 'package:scc_web/widgets/dashboard/select-view/select-view.dart';
import 'package:scc_web/widgets/dashboard/time_updated.dart';

class DashboardMap extends StatefulWidget {
  final bool showMap;
  final KeyVal? searchBySelected;

  const DashboardMap(
      {Key? key, required this.showMap, required this.searchBySelected})
      : super(key: key);

  @override
  State<DashboardMap> createState() => _DashboardMapState();
}

class _DashboardMapState extends State<DashboardMap> {
  bool isLoading = false;
  bool openSelectTrace = false;
  bool openSelectView = false;
  String selectedTrace = 'Traceability';
  String selectedView = 'Area';

  void handleOpenSelect(String value) {
    if (value == "Trace") {
      return setState(() {
        openSelectTrace = !openSelectTrace;
        openSelectView = false;
      });
    }

    if (value == "View") {
      return setState(() {
        openSelectView = !openSelectView;
        openSelectTrace = false;
      });
    }
  }

  void handleSelectedTrace(String value) {
    setState(() {
      selectedTrace = value;
      openSelectTrace = false;
    });
  }

  void handleSelectedView(String value) {
    setState(() {
      selectedView = value;
      openSelectView = false;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool showMap = widget.showMap;
    return Stack(
      children: [
        Positioned(
            child: Container(
          height: context.deviceHeight() * 0.65,
          width: double.infinity,
          color: Colors.transparent,
          margin: const EdgeInsets.only(top: 5.0, bottom: 5.0),
          child: showMap ? const Map() : null,
        )),
        Visibility(visible: showMap, child: const LegendMap()),
        Visibility(visible: showMap, child: const TimeUpdated()),
        SelectTrace(
            handleOpenSelect: handleOpenSelect, selectedTrace: selectedTrace),
        Visibility(
            visible: openSelectTrace,
            child: OptionTrace(handleSelectedTrace: handleSelectedTrace)),
        SelectView(
            handleOpenSelect: handleOpenSelect, selectedView: selectedView),
        Visibility(
            visible: openSelectView,
            child: OptionView(handleSelectedView: handleSelectedView)),
        if (!showMap) ...[
          const OverlayBackgroundMap(),
          const OverlayArrowMap(),
          const OverlayContentMap()
        ],
      ],
    );
  }
}
