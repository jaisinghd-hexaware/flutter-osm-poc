import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:flutter/foundation.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';

class OSM extends StatefulWidget {
  OSM({super.key});

  @override
  State<OSM> createState() => _OSMState();
}

class _OSMState extends State<OSM> with OSMMixinObserver {
  late MapController controller;
  ValueNotifier<GeoPoint?> centerMap = ValueNotifier(null);
  ValueNotifier<bool> beginDrawRoad = ValueNotifier(false);
  List<GeoPoint> pointsRoad = [];
  List<GeoPoint> redMarker = [];
  ValueNotifier<RoadType> notifierRoadType = ValueNotifier(RoadType.car);
  TextEditingController latController_1 = TextEditingController();
  TextEditingController lonController_1 = TextEditingController();
  TextEditingController latController_2 = TextEditingController();
  TextEditingController lonController_2 = TextEditingController();
  List<GeoPoint> coordinatesArray = [
    GeoPoint(latitude: 13.226698783274813, longitude: 80.27379122647375),
    GeoPoint(latitude: 13.178688602634708, longitude: 80.25025801225144),
    GeoPoint(latitude: 13.16180844183556, longitude: 80.26932807722494),
    GeoPoint(latitude: 13.150122244565054, longitude: 80.22900351499749),
  ];
  final List<Color> colors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.orange
  ];
  @override
  void initState() {
    super.initState();
    controller = MapController.withPosition(
      initPosition: GeoPoint(
        latitude: 12.8254,
        longitude: 80.2174,
      ),
    );

    controller.addObserver(this);

    controller.listenerMapSingleTapping.addListener(() async {
      print('Clicked:  ${controller.listenerMapSingleTapping.value}');
      if (beginDrawRoad.value) {
        if (controller.listenerMapSingleTapping.value != null) {
          pointsRoad.add(controller.listenerMapSingleTapping.value!);
        } else {
          pointsRoad.add(GeoPoint(
            latitude: double.parse(latController_1.text),
            longitude: double.parse(lonController_1.text),
          ));
          pointsRoad.add(GeoPoint(
            latitude: double.parse(latController_2.text),
            longitude: double.parse(lonController_2.text),
          ));
        }

        await controller.addMarker(
          controller.listenerMapSingleTapping.value!,
          markerIcon: const MarkerIcon(
            icon: Icon(
              Icons.person_pin_circle,
              color: Colors.amber,
              size: 48,
            ),
          ),
        );
        print('pointsRoad ${pointsRoad}');
        print('pointsRoad.first ${pointsRoad.first}');
        print('pointsRoad.last ${pointsRoad.last}');
        await controller.drawRoad(
          pointsRoad.first,
          pointsRoad.last,
          roadType: notifierRoadType.value,
          intersectPoint:
              pointsRoad.getRange(1, pointsRoad.length - 1).toList(),
          // roadOption: RoadOption(
          //   roadWidth: 15,
          //   roadColor: Colors.red,
          //   zoomInto: true,
          //   roadBorderWidth: 2,
          //   roadBorderColor: Colors.green,
          // ),
        );

        // if (pointsRoad.length >= 2 && showFab.value) {
        //   roadActionBt(context);
        // }
      } else {
        redMarker.add(controller.listenerMapSingleTapping.value!);
        print(
            'here are red marker:${controller.listenerMapSingleTapping.value}');
        await controller.addMarker(
          controller.listenerMapSingleTapping.value!,
          markerIcon: const MarkerIcon(
            icon: Icon(
              Icons.person_pin,
              color: Colors.red,
              size: 48,
            ),
          ),
          iconAnchor: IconAnchor(
            anchor: Anchor.top,
            //offset: (x: 32.5, y: -32),
          ),
        );
      }
    });
    // controller.listenerRegionIsChanging.addListener(() async {
    //   if (controller.listenerRegionIsChanging.value != null) {
    //     print(controller.listenerRegionIsChanging.value);
    //     centerMap.value = controller.listenerRegionIsChanging.value!.center;
    //   }
    // });
  }

  @override
  Future<void> mapIsReady(bool isReady) {
    print('map is ready $isReady');
    drawRoutes();
    // TODO: implement mapIsReady
    throw UnimplementedError();
  }

  void drawRoutes() async {
    print('within draw routes');
    for (int i = 0; i < coordinatesArray.length - 1; i++) {
      GeoPoint startPoint = coordinatesArray[i];
      GeoPoint endPoint = coordinatesArray[i + 1];

      await controller.addMarker(
        startPoint,
        markerIcon: MarkerIcon(
          key: Key(i.toString()),
          iconWidget: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Point:$i',
                style:
                    const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
              ),
              Icon(
                Icons.person_pin_circle,
                color: colors[i],
                size: 48,
              ),
            ],
          ),
        ),
      );
      if (i == coordinatesArray.length - 2) {
        await controller.addMarker(
          coordinatesArray[i + 1],
          markerIcon: MarkerIcon(
            key: Key(i.toString()),
            iconWidget: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Point:${i + 1}',
                  style: const TextStyle(
                      fontSize: 13, fontWeight: FontWeight.bold),
                ),
                Icon(
                  Icons.person_pin_circle,
                  color: colors[i + 1],
                  size: 48,
                ),
              ],
            ),
          ),
        );
      }
      await controller.drawRoad(
        startPoint,
        endPoint,
        roadType: notifierRoadType.value,
        roadOption: RoadOption(
          roadWidth: 18,
          roadColor: colors[i],
          zoomInto: true,
          roadBorderWidth: 2,
          roadBorderColor: Colors.green,
        ),
      );
    }
  }

  void drawMap() async {
    pointsRoad.add(GeoPoint(
      latitude: double.parse(latController_1.text),
      longitude: double.parse(lonController_1.text),
    ));
    pointsRoad.add(GeoPoint(
      latitude: double.parse(latController_2.text),
      longitude: double.parse(lonController_2.text),
    ));
    await controller.addMarker(
      pointsRoad.first,
      markerIcon: const MarkerIcon(
        icon: Icon(
          Icons.person_pin_circle,
          color: Colors.amber,
          size: 48,
        ),
      ),
    );
    await controller.addMarker(
      pointsRoad.last,
      markerIcon: const MarkerIcon(
        icon: Icon(
          Icons.person_pin_circle,
          color: Colors.amber,
          size: 48,
        ),
      ),
    );
    print('pointsRoad.first ${pointsRoad.first}');
    print('pointsRoad.last ${pointsRoad.last}');
    await controller.drawRoad(
      pointsRoad.first,
      pointsRoad.last,
      roadType: notifierRoadType.value,
      intersectPoint: pointsRoad.getRange(1, pointsRoad.length - 1).toList(),
      // roadOption: RoadOption(
      //   roadWidth: 15,
      //   roadColor: Colors.red,
      //   zoomInto: true,
      //   roadBorderWidth: 2,
      //   roadBorderColor: Colors.green,
      // ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Maps'),
        actions: [
          IconButton(
            onPressed: () {
              beginDrawRoad.value = !beginDrawRoad.value;
            },
            icon: const Icon(Icons.route),
          ),
          IconButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Enter Latitude and Longitude'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextField(
                            controller: latController_1,
                            keyboardType: TextInputType.number,
                            decoration:
                                InputDecoration(labelText: 'Lat Place A'),
                          ),
                          TextField(
                            controller: lonController_1,
                            keyboardType: TextInputType.number,
                            decoration:
                                InputDecoration(labelText: 'Long Place A'),
                          ),
                          TextField(
                            controller: latController_2,
                            keyboardType: TextInputType.number,
                            decoration:
                                InputDecoration(labelText: 'Lat Place B'),
                          ),
                          TextField(
                            controller: lonController_2,
                            keyboardType: TextInputType.number,
                            decoration:
                                InputDecoration(labelText: 'Long Place B'),
                          ),
                        ],
                      ),
                      actions: [
                        ElevatedButton(onPressed: drawMap, child: Text('Done'))
                      ],
                    );
                  });
            },
            icon: const Icon(Icons.type_specimen),
          ),
          IconButton(
            onPressed: () {
              controller.clearAllRoads();
              controller.removeMarkers(pointsRoad);
              controller.removeMarkers(redMarker);
              pointsRoad.clear();
            },
            icon: const Icon(Icons.clear),
          ),
        ],
      ),
      body: Container(
        child: Stack(
          children: [
            OSMFlutter(
              controller: controller,
              osmOption: OSMOption(
                enableRotationByGesture: true,
                zoomOption: const ZoomOption(
                  initZoom: 8,
                  minZoomLevel: 3,
                  maxZoomLevel: 19,
                  stepZoom: 1.0,
                ),
                userLocationMarker: UserLocationMaker(
                    personMarker: const MarkerIcon(
                      // icon: Icon(
                      //   Icons.car_crash_sharp,
                      //   color: Colors.red,
                      //   size: 48,
                      // ),
                      // iconWidget: SizedBox.square(
                      //   dimension: 56,
                      //   child: Image.asset(
                      //     "asset/taxi.png",
                      //     scale: .3,
                      //   ),
                      // ),
                      iconWidget: SizedBox(
                        width: 32,
                        height: 64,
                        child: Icon(Icons.arrow_back),
                      ),
                      // assetMarker: AssetMarker(
                      //   image: AssetImage(
                      //     "asset/taxi.png",
                      //   ),
                      //   scaleAssetImage: 0.3,
                      // ),
                    ),
                    directionArrowMarker: const MarkerIcon(
                      // icon: Icon(
                      //   Icons.navigation_rounded,
                      //   size: 48,
                      // ),
                      iconWidget: SizedBox(
                        width: 32,
                        height: 64,
                        child: Icon(Icons.arrow_back),
                      ),
                    )
                    // directionArrowMarker: MarkerIcon(
                    //   assetMarker: AssetMarker(
                    //     image: AssetImage(
                    //       "asset/taxi.png",
                    //     ),
                    //     scaleAssetImage: 0.25,
                    //   ),
                    // ),
                    ),
                staticPoints: [
                  StaticPositionGeoPoint(
                    "line 1",
                    const MarkerIcon(
                      icon: Icon(
                        Icons.train,
                        color: Colors.green,
                        size: 32,
                      ),
                    ),
                    [
                      GeoPoint(
                        latitude: 47.4333594,
                        longitude: 8.4680184,
                      ),
                      GeoPoint(
                        latitude: 47.4317782,
                        longitude: 8.4716146,
                      ),
                    ],
                  ),
                  /*StaticPositionGeoPoint(
                            "line 2",
                            MarkerIcon(
                              icon: Icon(
                                Icons.train,
                                color: Colors.red,
                                size: 48,
                              ),
                            ),
                            [
                              GeoPoint(latitude: 47.4433594, longitude: 8.4680184),
                              GeoPoint(latitude: 47.4517782, longitude: 8.4716146),
                            ],
                          )*/
                ],
                roadConfiguration: const RoadOption(
                  roadColor: Colors.blueAccent,
                ),
                markerOption: MarkerOption(
                  defaultMarker: const MarkerIcon(
                    icon: Icon(
                      Icons.home,
                      color: Colors.orange,
                      size: 24,
                    ),
                  ),
                  advancedPickerMarker: const MarkerIcon(
                    icon: Icon(
                      Icons.location_searching,
                      color: Colors.green,
                      size: 56,
                    ),
                  ),
                ),
                showContributorBadgeForOSM: true,
                //trackMyPosition: trackingNotifier.value,
                showDefaultInfoWindow: false,
              ),
              mapIsLoading: const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    Text("Map is Loading.."),
                  ],
                ),
              ),
              // onMapIsReady: (isReady) {
              //   if (isReady) {
              //     print("map is ready");
              //   }
              // },
              // onLocationChanged: (myLocation) {
              //   print('user location :$myLocation');
              // },
              // onGeoPointClicked: (geoPoint) async {
              //   print('jai Clicked on :$geoPoint');
              //   if (geoPoint ==
              //       GeoPoint(
              //         latitude: 47.442475,
              //         longitude: 8.4680389,
              //       )) {
              //     final newGeoPoint = GeoPoint(
              //       latitude: 47.4517782,
              //       longitude: 8.4716146,
              //     );
              //     await controller.changeLocationMarker(
              //       oldLocation: geoPoint,
              //       newLocation: newGeoPoint,
              //       markerIcon: const MarkerIcon(
              //         icon: Icon(
              //           Icons.bus_alert,
              //           color: Colors.blue,
              //           size: 24,
              //         ),
              //       ),
              //     );
              //   }
              //   ScaffoldMessenger.of(context).showSnackBar(
              //     SnackBar(
              //       content: Text(
              //         "${geoPoint.toMap().toString()}",
              //       ),
              //       action: SnackBarAction(
              //         onPressed: () =>
              //             ScaffoldMessenger.of(context).hideCurrentSnackBar(),
              //         label: "hide",
              //       ),
              //     ),
              //   );
              // },
            ),
            Positioned(
                bottom: 10,
                left: 10,
                child: Container(
                  color: Colors.blue.shade200,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                            border: BorderDirectional(
                          bottom: BorderSide(color: Colors.black),
                        )),
                        child: IconButton(
                          onPressed: () {
                            controller.zoomIn();
                          },
                          icon: const Icon(Icons.add),
                          color: const Color.fromARGB(255, 236, 109, 109),
                        ),
                      ),
                      IconButton(
                          onPressed: () {
                            controller.zoomOut();
                          },
                          icon: Icon(Icons.remove)),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
