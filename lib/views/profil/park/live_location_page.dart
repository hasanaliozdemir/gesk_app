import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gesk_app/bloc/app_bloc.dart';
import 'package:gesk_app/core/colors.dart';
import 'package:gesk_app/core/funcs/triangleCreator.dart';

import 'package:gesk_app/data_models/location.dart';

import 'package:gesk_app/models/park.dart';
import 'package:gesk_app/services/markerCreator.dart';
import 'package:get/get.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LiveLocationPage extends StatefulWidget {
  final bool searched;
  const LiveLocationPage({Key key, this.searched}) : super(key: key);

  @override
  _LiveLocationPageState createState() => _LiveLocationPageState(searched);
}

class _LiveLocationPageState extends State<LiveLocationPage> {
  final bool searched;
  Location place;
  Location currentLocation;
  CameraPosition cameraPosition;
  List<Marker> _markers = [];

  Completer<GoogleMapController> _mapController =
      Completer<GoogleMapController>();

  _LiveLocationPageState(this.searched);
  @override
  void initState() {
    final applicationBloc = Provider.of<AppBloc>(context, listen: false);

    MarkerGenerator(markerWidgets(), (bitmaps) {
      setState(() {
        _markers = mapBitmapsToMarkers(bitmaps);
      });
    }).generate(context);

    super.initState();
  }

  @override
  void dispose() {
    final applicationBloc = Provider.of<AppBloc>(context, listen: false);

    applicationBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final applicationBloc = Provider.of<AppBloc>(context, listen: false);

    if (searched == false) {
      cameraPosition = CameraPosition(
          target: LatLng(applicationBloc.currentLocation.latitude,
              applicationBloc.currentLocation.longitude),
          zoom: 16);
      currentLocation = Location(
          lat: applicationBloc.currentLocation.latitude,
          lng: applicationBloc.currentLocation.longitude);
    } else {
      cameraPosition = CameraPosition(
          target: LatLng(applicationBloc.currentLocation.latitude,
              applicationBloc.currentLocation.longitude),
          zoom: 16);
      _getPlace();
    }

    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: cameraPosition,
        onMapCreated: (GoogleMapController controller) {
          _mapController.complete(controller);
        },
        markers: _markers.toSet(),
      ),
    );
  }

  _getPlace() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final GoogleMapController _controller = await _mapController.future;

    var _lat = prefs.getDouble("lastPlaceLat");
    var _lng = prefs.getDouble("lastPlaceLng");
    setState(() {
      place = Location(lat: _lat, lng: _lng);
      currentLocation = Location(lat: _lat, lng: _lng);
    });
    _controller.moveCamera(CameraUpdate.newLatLng(LatLng(_lat, _lng)));
  }

  List<Marker> mapBitmapsToMarkers(List<Uint8List> bitmaps) {
    List<Marker> _markersList = [];
    bitmaps.asMap().forEach((i, bmp) {
      _markersList.add(Marker(
          markerId: MarkerId("20"),
          draggable: true,
          onDragEnd: (latlng) {
            setState(() {
              currentLocation =
                  Location(lat: latlng.latitude, lng: latlng.longitude);
            });
          },
          position: LatLng(currentLocation.lat, currentLocation.lng),
          icon: BitmapDescriptor.fromBytes(bmp)));
    });
    return _markersList;
  }

  Widget _getMarkerWidget(
      double price, Status status, bool isWithElectiricity) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        child: Container(
          width: Get.width / 375 * 64,
          height: Get.height / 812 * 70,
          child: Stack(children: [
            Padding(
              padding:
                  const EdgeInsets.only(top: 8.0, right: 8, left: 8, bottom: 1),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4.00),
                      color: blue800,
                    ),
                    width: Get.width / 375 * 48,
                    height: Get.height / 812 * 48,
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: Align(
                              alignment: Alignment.center,
                              child: _buildMarkerText(Status.owner, price)),
                        ),
                      ],
                    ),
                  ),
                  RotatedBox(
                    quarterTurns: 2,
                    child: CustomPaint(
                      painter: TrianglePainter(
                        strokeColor: blue800,
                        strokeWidth: 10,
                        paintingStyle: PaintingStyle.fill,
                      ),
                      child: Container(
                        height: Get.height / 812 * 7,
                        width: Get.width / 375 * 10,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ]),
        ));
  }

  List<Widget> markerWidgets() {
    return [_getMarkerWidget(0, Status.owner, false)];
  }

  Widget _buildMarkerText(Status status, price) {
    if (status == Status.owner) {
      return Icon(
        CupertinoIcons.map_pin_ellipse,
        color: white,
      );
    } else {
      return Text(
        price.truncate().toString() + "₺",
        style: TextStyle(
          color: Colors.white,
          fontSize: 17,
          fontFamily: "SF Pro Text",
          fontWeight: FontWeight.w600,
        ),
      );
    }
  }
}