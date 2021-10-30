import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:testing_referral/elements/button.dart';
import 'package:testing_referral/network/location.dart';
import 'package:testing_referral/operations/operations.dart';
import 'package:testing_referral/screens/location_search_screen.dart';

class MapScreen extends StatefulWidget {
  static final String mapScreen = 'MapScreen';
  final double? lat;
  final double? lng;

  MapScreen({this.lat, this.lng});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final Completer<GoogleMapController> _controller = Completer();

  var lat;
  var long;
  String sessionToken = '';
  Map<String, String> locationDetails = {};

  @override
  void initState() {
    getPermission();
    sessionToken = Operations.getSessionToken();
    super.initState();
  }

  void getPermission() async {
    await Permission.location.request();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: new Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: GoogleMap(
                compassEnabled: false,
                myLocationEnabled: true,
                myLocationButtonEnabled: false,
                zoomControlsEnabled: false,
                mapType: MapType.normal,
                initialCameraPosition: CameraPosition(
                    bearing: 192.8334901395799,
                    target: LatLng(widget.lat!, widget.lng!),
                    zoom: 19.151926040649414),
                onCameraIdle: () async {
                  final LatLng centerLatLng = await getCenter();
                  print(centerLatLng.latitude);
                  print(centerLatLng.longitude);
                  final Map<String, String> details = await Location.byLatLng(
                      centerLatLng.latitude, centerLatLng.longitude);
                  setState(
                    () => locationDetails = details,
                  );
                },
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0, left: 20, right: 20),
              child: Align(
                alignment: Alignment.topCenter,
                child: Material(
                  elevation: 3,
                  borderRadius: BorderRadius.circular(15),
                  child: ListTile(
                    onTap: () async {
                      final locationDetails = await Navigator.pushNamed(context,
                          LocationSearchScreen.locationSearchScreen) as Map;
                      if (locationDetails[Location.lat] != null) {
                        await goToLocation(
                          locationDetails[Location.location] ?? '',
                          locationDetails[Location.lat],
                          locationDetails[Location.lng],
                        );
                      }
                    },
                    title: Text(
                      locationDetails[Location.location] ?? 'Search location',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.ptSans(),
                    ),
                    leading: Icon(Icons.search_sharp),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Button(
                  buttonText: 'CONFIRM LOCATION',
                  onPress: () {
                    Navigator.pop(context, locationDetails);
                  },
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Image.asset(
                'images/pin.png',
                height: 30,
                width: 30,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> goToLocation(
      String? locationName, double? lat, double? lng) async {
    final GoogleMapController controller = await _controller.future;
    setState(() => locationDetails[Location.location] = locationName!);
    final CameraPosition location = CameraPosition(
      target: LatLng(lat!, lng!),
      zoom: 17.4746,
    );
    controller.animateCamera(
      CameraUpdate.newCameraPosition(location),
    );
  }

  Future<LatLng> getCenter() async {
    final GoogleMapController controller = await _controller.future;
    LatLngBounds visibleRegion = await controller.getVisibleRegion();
    LatLng centerLatLng = LatLng(
      (visibleRegion.northeast.latitude + visibleRegion.southwest.latitude) / 2,
      (visibleRegion.northeast.longitude + visibleRegion.southwest.longitude) /
          2,
    );

    return centerLatLng;
  }
}