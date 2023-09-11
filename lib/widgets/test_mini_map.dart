import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

class TestMiniMap extends StatefulWidget {
  const TestMiniMap({super.key});

  @override
  State<TestMiniMap> createState() => _TestMiniMapState();
}

class _TestMiniMapState extends State<TestMiniMap> {
  late MapController controller;
  List<GeoPoint> coordinatesArray = [
    GeoPoint(latitude: 13.226698783274813, longitude: 80.27379122647375),
    GeoPoint(latitude: 13.178688602634708, longitude: 80.25025801225144),
    GeoPoint(latitude: 13.16180844183556, longitude: 80.26932807722494),
    GeoPoint(latitude: 13.150122244565054, longitude: 80.22900351499749),
  ];
  late BoundingBox bounds;
  final List<Color> colors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.orange
  ];

  @override
  void initState() {
    // controller = MapController.withUserPosition(
    //     trackUserLocation: const UserTrackingOption(
    //   enableTracking: true,
    //   unFollowUser: false,
    // ));
    bounds = BoundingBox.fromGeoPoints(coordinatesArray);

    controller = MapController(
      initPosition: GeoPoint(latitude: 47.4358055, longitude: 8.4737324),
      areaLimit: BoundingBox(
        east: bounds.east,
        north: bounds.north,
        south: bounds.south,
        west: bounds.west,
      ),
    );
    super.initState();
  }

  void drawMarker() async {
    print('within marker');
    for (var coordinate in coordinatesArray) {
      await controller.addMarker(
        coordinate,
        markerIcon: const MarkerIcon(
          icon: Icon(
            Icons.person_pin_circle,
            color: Colors.amber,
            size: 48,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: 350,
      child: OSMFlutter(
        controller: controller,
        osmOption: OSMOption(enableRotationByGesture: false),
        onMapIsReady: (p0) async => {
          await controller.zoomToBoundingBox(
              BoundingBox.fromGeoPoints(coordinatesArray),
              paddinInPixel: 75),
          await controller.limitAreaMap(BoundingBox(
              north: bounds.north,
              east: bounds.east,
              south: bounds.south,
              west: bounds.west)),
          drawMarker(),
          //  await controller.zoomOut()
        },
      ),
    );
  }
}
