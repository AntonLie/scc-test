// ignore_for_file: prefer_collection_literals

import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
// import 'package:heroicons/heroicons.dart';

class TransactionMap extends StatefulWidget {
  const TransactionMap({super.key});

  @override
  State<TransactionMap> createState() => _TransactionMapState();
}

class _TransactionMapState extends State<TransactionMap> {
  final mapController = MapController.customLayer(
    initPosition: GeoPoint(
      latitude: -6.2186488,
      longitude: 106.7991978,
    ),
    customTile: CustomTile(
      sourceName: "geoapify",
      tileExtension: ".png",
      minZoomLevel: 2,
      maxZoomLevel: 19,
      urlsServers: [
        TileURLs(
          url: 'https://maps.geoapify.com/v1/tile/osm-carto/',
        )
      ],
      keyApi: const MapEntry("apiKey", "4dc9fb3b41f248fb94e570e058b3b313"),
      tileSize: 256,
    ),
  );

  initMap(bool isReady) async {
    if (isReady) {
      await mapController.addMarker(
        GeoPoint(latitude: -6.21767, longitude: 106.7989386),
        markerIcon: MarkerIcon(
          iconWidget: SizedBox(
            width: 250.0,
            height: 60.0,
            child: Column(
              children: [
                const Icon(
                  Icons.location_on,
                  color: Colors.purple,
                  size: 40,
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 1.0),
                  decoration: BoxDecoration(
                      color: Colors.purple,
                      borderRadius: BorderRadius.circular(8)),
                  child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("TMMIN Plant 2",
                            style:
                                TextStyle(fontSize: 10.0, color: Colors.white))
                      ]),
                )
              ],
            ),
          ),
        ),
      );

      await mapController.addMarker(
        GeoPoint(latitude: -6.2186488, longitude: 106.7991978),
        markerIcon: const MarkerIcon(
            iconWidget: SizedBox(
          width: 250.0,
          height: 60.0,
          child: Column(
            children: [
              // HeroIcon(HeroIcons.truck, color: Colors.red,
              //   size: 40,)
              Icon(
                Icons.fire_truck,
                color: Colors.red,
                size: 40,
              ),
              // Container(
              //   padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 1.0),
              //   decoration: BoxDecoration(
              //       color: Colors.red, borderRadius: BorderRadius.circular(8)),
              //   child: const Column(
              //       mainAxisAlignment: MainAxisAlignment.center,
              //       children: [
              //         Text("TMMIN Plant 3",
              //             style: TextStyle(fontSize: 10.0, color: Colors.white))
              //       ]),
              // )
            ],
          ),
        )),
      );
      final configsRoad = [
        MultiRoadConfiguration(
            startPoint: GeoPoint(latitude: -6.2186488, longitude: 106.7991978),
            destinationPoint:
                GeoPoint(latitude: -6.21767, longitude: 106.7989386),
            roadOptionConfiguration:
                const MultiRoadOption(roadColor: Colors.purple, roadWidth: 3)),
      ];

      await mapController.drawMultipleRoad(
        configsRoad,
      );
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 550.0,
      child: OSMFlutter(
          controller: mapController,
          onMapIsReady: (isReady) => initMap(isReady),
          osmOption: OSMOption(
            userTrackingOption: const UserTrackingOption(
              enableTracking: true,
              unFollowUser: false,
            ),
            showContributorBadgeForOSM: false,
            zoomOption: const ZoomOption(
              initZoom: 17,
              minZoomLevel: 3,
              maxZoomLevel: 19,
              stepZoom: 1.0,
            ),
            userLocationMarker: UserLocationMaker(
              personMarker: const MarkerIcon(
                icon: Icon(
                  Icons.location_history_rounded,
                  color: Colors.red,
                  size: 48,
                ),
              ),
              directionArrowMarker: const MarkerIcon(
                icon: Icon(
                  Icons.double_arrow,
                  size: 48,
                ),
              ),
            ),
            markerOption: MarkerOption(
                defaultMarker: const MarkerIcon(
              icon: Icon(
                Icons.person_pin_circle,
                color: Colors.red,
                size: 56,
              ),
            )),
          )),
    );
  }
}
