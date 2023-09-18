import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => MapScreenState();
}

class MapScreenState extends State<MapScreen> {
  late MapController controller;
  bool isMapReady = false;
  @override
  initState() {
    controller = MapController(
      initMapWithUserPosition:
          const UserTrackingOption(enableTracking: false, unFollowUser: true),
    );
    super.initState();
  }

  List<GeoPoint> coordinatesArray = [
    GeoPoint(latitude: 13.226698783274813, longitude: 80.27379122647375),
    GeoPoint(latitude: 13.178688602634708, longitude: 80.25025801225144),
    GeoPoint(latitude: 13.16180844183556, longitude: 80.26932807722494),
    GeoPoint(latitude: 13.150122244565054, longitude: 80.22900351499749),
  ];

  MarkerIcon userMarker() {
    return const MarkerIcon(
      icon: Icon(
        Icons.home,
        color: Colors.blue,
        size: 48,
      ),
    );
  }

  MarkerIcon locationMarker() {
    return const MarkerIcon(
      icon: Icon(
        Icons.location_pin,
        color: Colors.red,
        size: 48,
      ),
    );
  }

  drawLocationMarker() async {
    for (var coordinate in coordinatesArray) {
      await controller.addMarker(
        coordinate,
        markerIcon: locationMarker(),
      );
    }
  }

  void zoomUserLocation() async {
    await controller.currentLocation();
  }

  addUserMarker() async {
    var user = await controller.myLocation();
    await controller.addMarker(user, markerIcon: userMarker());
  }

  addAllMarkers() async {
    await addUserMarker();
    await drawLocationMarker();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        OSMFlutter(
          controller: controller,
          osmOption: const OSMOption(
            enableRotationByGesture: false,
            zoomOption: ZoomOption(minZoomLevel: 10),
          ),
          onMapIsReady: (p0) {
            if (!isMapReady) {
              print('onMapIsReady');
              addAllMarkers();
              controller.zoomToBoundingBox(
                  BoundingBox.fromGeoPoints(coordinatesArray),
                  paddinInPixel: 200);
              controller.enableTracking(
                enableStopFollow: false,
              );
              isMapReady = true;
            }
          },
        ),
        ElevatedButton(
          onPressed: () {
            zoomUserLocation();
          },
          child: const Text('User'),
        ),
      ],
    );
  }
}
