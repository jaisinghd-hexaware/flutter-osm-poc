import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

class MiniMap extends StatefulWidget {
  const MiniMap({super.key});

  @override
  State<MiniMap> createState() => _MiniMapState();
}

class _MiniMapState extends State<MiniMap> with OSMMixinObserver {
  late MapController controller;
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
  ValueNotifier<RoadType> notifierRoadType = ValueNotifier(RoadType.car);

  @override
  void initState() {
    super.initState();

    // controller = MapController.withPosition(
    //   initPosition: GeoPoint(
    //     latitude: 12.8254,
    //     longitude: 80.2174,
    //   ),
    // );
    // controller = MapController.withUserPosition(
    //     trackUserLocation: const UserTrackingOption(
    //   enableTracking: false,
    //   unFollowUser: true,
    // ));
    BoundingBox boundingBox=BoundingBox.fromGeoPoints(coordinatesArray);

    controller = MapController(
      initMapWithUserPosition:
          const UserTrackingOption(enableTracking: false, unFollowUser: true),
      areaLimit: boundingBox,
    );


    // TODO: implement initState
  }

   BoundingBox calculateBoundingBox(List<GeoPoint> coordinates) {
    double minLatitude = coordinates[0].latitude;
    double maxLatitude = coordinates[0].latitude;
    double minLongitude = coordinates[0].longitude;
    double maxLongitude = coordinates[0].longitude;

    for (var coordinate in coordinates) {
      if (coordinate.latitude < minLatitude) {
        minLatitude = coordinate.latitude;
      }
      if (coordinate.latitude > maxLatitude) {
        maxLatitude = coordinate.latitude;
      }
      if (coordinate.longitude < minLongitude) {
        minLongitude = coordinate.longitude;
      }
      if (coordinate.longitude > maxLongitude) {
        maxLongitude = coordinate.longitude;
      }
    }

    return BoundingBox(
      north: maxLatitude,
      south: minLatitude,
      east: maxLongitude,
      west: minLongitude,
    );
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
          // zoomInto: true,
          roadBorderWidth: 2,
          roadBorderColor: Colors.green,
        ),
      );
    }
  }

  Future<void> mapIsReady(bool isReady) async {
    print('map is ready $isReady');
    await controller.addMarker(
      GeoPoint(
        latitude: 12.8254,
        longitude: 80.2174,
      ),
      markerIcon: const MarkerIcon(
        icon: Icon(
          Icons.person_pin_circle,
          color: Colors.amber,
          size: 48,
        ),
      ),
    );
    // TODO: implement mapIsReady
    throw UnimplementedError();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
      height: 200,
      width: 350,
      child: OSMFlutter(
        onMapIsReady: (p0) => {
          // controller.addMarker(
          //   GeoPoint(
          //     latitude: 12.8254,
          //     longitude: 80.2174,
          //   ),
          //   markerIcon: const MarkerIcon(
          //     icon: Icon(
          //       Icons.person_pin_circle,
          //       color: Colors.red,
          //       size: 48,
          //     ),
          //   ),
          // )
          // drawRoutes()
          // controller
          //     .zoomToBoundingBox(BoundingBox.fromGeoPoints(coordinatesArray)),
          drawRoutes()
        },
        controller: controller,
        osmOption: const OSMOption(
          showZoomController: false,
          zoomOption: ZoomOption(
            initZoom: 0,
            stepZoom: 1,
            maxZoomLevel: 15,
          ),
        ),
      ),
    );
  }
}
