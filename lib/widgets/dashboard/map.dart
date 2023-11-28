/// Flutter package imports
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:scc_web/helper/app_scale.dart';
import 'package:scc_web/helper/constant.dart';

import 'package:syncfusion_flutter_core/theme.dart';

import 'package:syncfusion_flutter_maps/maps.dart';

class Map extends StatefulWidget {
  const Map({super.key});
  @override
  State<Map> createState() => _MapState();
}

class _MapState extends State<Map> with SingleTickerProviderStateMixin {
  late List<_RouteDetails> routes;
  late List<_MarkerData> markerList;
  late MapZoomPanBehavior zoomPanBehavior;
  late MapTileLayerController mapController;
  late AnimationController animationController;
  late Animation<double> animation;
  int currentType = 0;
  bool _isDesktop = false;
  late bool canUpdateZoomLevel;

  @override
  void initState() {
    mapController = MapTileLayerController();

    zoomPanBehavior = MapZoomPanBehavior(
        focalLatLng: const MapLatLng(-6.2186488, 106.7991978),
        maxZoomLevel: 13,
        toolbarSettings: const MapToolbarSettings(
          direction: Axis.vertical,
          position: MapToolbarPosition.bottomRight,
        ),
        enableDoubleTapZooming: true);

    handleGetMap(currentType);

    canUpdateZoomLevel = true;

    animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    animation = CurvedAnimation(
      parent: animationController,
      curve: Curves.linear,
    );
    animationController.forward(from: 0);

    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    mapController.dispose();
    markerList.clear();
    routes.clear();
    super.dispose();
  }

  void handleGetMap(int index) {
    switch (index) {
      case 0:
        markerList = <_MarkerData>[
          const _MarkerData(
              'TMMIN Plant 3', MapLatLng(-6.2180589, 106.8675366), Colors.red),
          const _MarkerData('TMMIN Sunter', MapLatLng(-6.1532818, 106.8188285),
              Colors.orange),
          const _MarkerData('Sugity Creatives',
              MapLatLng(-6.3327044, 107.1155062), Colors.orange),
          const _MarkerData('TMMIN Plant 2', MapLatLng(-6.3750346, 107.2342053),
              Colors.purple),
        ];

        routes = <_RouteDetails>[
          const _RouteDetails(
              MapLatLng(-6.1532818, 106.8188285),
              MapLatLng(-6.2180589, 106.8675366),
              'TMMIN Plant 3',
              'TMMIN Sunter',
              Colors.orange,
              Colors.red,
              Colors.orange,
              'Inbound',
              25),
          const _RouteDetails(
              MapLatLng(-6.3327044, 107.1155062),
              MapLatLng(-6.2180589, 106.8675366),
              'TMMIN Plant 3',
              'Sugity Creatives',
              Colors.orange,
              Colors.red,
              Colors.orange,
              'Inbound',
              50),
          const _RouteDetails(
              MapLatLng(-6.2180589, 106.8675366),
              MapLatLng(-6.3750346, 107.2342053),
              'TMMIN Plant 3',
              'TMMIN Plant 2',
              Colors.purple,
              Colors.red,
              Colors.purple,
              'Outbound',
              10),
        ];
        _updateMarkers();
        break;
    }
  }

  void _updateMarkers() {
    mapController.clearMarkers();
    for (int i = 0; i < markerList.length; i++) {
      mapController.insertMarker(i);
    }
  }

  MapSublayer subLayer() {
    return MapArcLayer(
      arcs: List<MapArc>.generate(
        routes.length,
        (int index) {
          return MapArc(
            from: routes[index].from,
            to: routes[index].to,
            heightFactor: index == 5 &&
                    routes[index].to == const MapLatLng(13.0827, 80.2707)
                ? 0.5
                : 0.2,
            color: routes[index].color,
            width: 2.0,
          );
        },
      ).toSet(),
      animation: animation,
      tooltipBuilder: tooltipBuilder,
    );
  }

  Widget tooltipBuilder(BuildContext context, int index) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 5.0, right: 5.0),
        child: SizedBox(
          height: _isDesktop ? 55 : 40,
          width: 280.0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.stop_circle_outlined,
                          color: routes[index].colorFrom,
                          size: context.scaleFont(12)),
                      const SizedBox(
                        width: 5.0,
                      ),
                      Text(
                        routes[index].fromPlace,
                        style: TextStyle(
                            fontSize: context.scaleFont(12),
                            overflow: TextOverflow.clip,
                            fontWeight: FontWeight.w600),
                      )
                    ],
                  ),
                  const SizedBox(
                    width: 5.0,
                  ),
                  Icon(
                      routes[index].type == 'Inbound'
                          ? Icons.arrow_back_sharp
                          : Icons.arrow_forward_sharp,
                      color: routes[index].color,
                      size: context.scaleFont(12)),
                  const SizedBox(
                    width: 5.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.stop_circle_outlined,
                          color: routes[index].color,
                          size: context.scaleFont(12)),
                      const SizedBox(
                        width: 5.0,
                      ),
                      Text(
                        routes[index].toPlace,
                        style: TextStyle(
                            fontSize: context.scaleFont(12),
                            overflow: TextOverflow.clip,
                            fontWeight: FontWeight.w600),
                      )
                    ],
                  ),
                ],
              ),
              const SizedBox(
                width: 5.0,
              ),
              Align(
                alignment: Alignment.center,
                child: Text(
                  "${routes[index].totalTransaction} Transactions",
                  style: TextStyle(
                      fontSize: context.scaleFont(16),
                      overflow: TextOverflow.clip,
                      fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    _isDesktop = kIsWeb ||
        themeData.platform == TargetPlatform.macOS ||
        themeData.platform == TargetPlatform.windows ||
        themeData.platform == TargetPlatform.linux;
    if (canUpdateZoomLevel) {
      zoomPanBehavior.zoomLevel = _isDesktop ? 11 : 3;
      zoomPanBehavior.minZoomLevel = _isDesktop ? 11 : 3;
    }

    return Stack(children: <Widget>[
      Positioned.fill(
        child: Image.asset(
          Constant.scc_map_grid,
          repeat: ImageRepeat.repeat,
        ),
      ),
      SfMapsTheme(
        data: SfMapsThemeData(
            shapeHoverColor: Colors.transparent,
            layerStrokeColor: Colors.transparent),
        child: SfMaps(
          layers: <MapLayer>[
            MapTileLayer(
              urlTemplate:
                  'https://maps.geoapify.com/v1/tile/klokantech-basic/{z}/{x}/{y}.png?apiKey=4dc9fb3b41f248fb94e570e058b3b313',
              initialMarkersCount: markerList.length,
              initialZoomLevel: 10,
              zoomPanBehavior: zoomPanBehavior,
              controller: mapController,
              markerBuilder: (BuildContext context, int index) {
                return MapMarker(
                  latitude: markerList[index].latLng.latitude,
                  longitude: markerList[index].latLng.longitude,
                  offset: const Offset(0, 45),
                  size: const Size(150, 150),
                  child: Column(
                    children: [
                      Center(
                        child: Icon(Icons.location_on,
                            color: markerList[index].color, size: 45),
                      ),
                      Container(
                        padding: const EdgeInsets.fromLTRB(8.0, 5.0, 8.0, 5.0),
                        decoration: BoxDecoration(
                            color: markerList[index].color,
                            borderRadius: BorderRadius.circular(8)),
                        child: Text(
                          markerList[index].country,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 12.0),
                        ),
                      )
                    ],
                  ),
                );
              },
              tooltipSettings: const MapTooltipSettings(
                color: Colors.transparent,
              ),
              sublayers: <MapSublayer>[subLayer()],
            ),
          ],
        ),
      ),
    ]);
  }
}

class _MarkerData {
  const _MarkerData(this.country, this.latLng, this.color);

  final String country;
  final MapLatLng latLng;
  final Color color;
}

class _RouteDetails {
  const _RouteDetails(
      this.from,
      this.to,
      this.fromPlace,
      this.toPlace,
      this.color,
      this.colorFrom,
      this.colorTo,
      this.type,
      this.totalTransaction);

  final MapLatLng from;
  final MapLatLng to;
  final String fromPlace;
  final String toPlace;
  final Color color;
  final Color colorTo;
  final Color colorFrom;
  final String type;
  final int totalTransaction;
}
