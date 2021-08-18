import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gesk_app/core/colors.dart';
import 'package:gesk_app/core/funcs/triangleCreator.dart';
import 'package:gesk_app/models/park.dart';
import 'package:gesk_app/services/markerCreator.dart';
import 'package:gesk_app/views/giris/MapScreen.dart';
import 'package:get/route_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DatePickScreen extends StatefulWidget {
  final Park park;

  const DatePickScreen({Key key, this.park}) : super(key: key);

  @override
  _DatePickScreenState createState() => _DatePickScreenState(park);
}

class _DatePickScreenState extends State<DatePickScreen> {
  List<Marker> _markers = [];
  final Park _park;

  _DatePickScreenState(this._park);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).padding.top,
          ),
          Spacer(flex: 22,),
          Expanded(
            flex: 44,
            child: _buildBackButton()
          ),
          Spacer(flex: 16,),
          Expanded(
            flex: 240,
            child: _buildCard()
          ),
          Spacer(flex: 24,),
          Expanded(
            flex: 44,
            child: _buildDatePick(),
          ),
          Spacer(flex: 32,),
          Expanded(
            flex: 44,
            child: _buildTimePicker(),
          ),
          Spacer(flex: 24,),
          Expanded(
            flex: 44,
            child: _buildButton()
          ),
          Spacer(flex: 240,),
          SizedBox(
            height: MediaQuery.of(context).padding.bottom,
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    MarkerGenerator(markerWidgets(), (bitmaps) {
      setState(() {
        _markers = mapBitmapsToMarkers(bitmaps);
      });
    }).generate(context);
  }

  List<Marker> mapBitmapsToMarkers(List<Uint8List> bitmaps) {
    List<Marker> _markersList = [];
    bitmaps.asMap().forEach((i, bmp) {
      final park = _park;
      _markersList.add(Marker(
          
          markerId: MarkerId(park.id.toString()),
          position: LatLng(park.latitude, park.longitude),
          icon: BitmapDescriptor.fromBytes(bmp)));
    });
    return _markersList;
  }


Widget _getMarkerWidget(double price, Status status, bool isWithElectiricity) {
  return Container(
      padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      child: Container(
        width: width * 64,
        height: height * 70,
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
                    color: _markerColor(status),
                  ),
                  width: width * 48,
                  height: height * 48,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Align(
                            alignment: Alignment.center,
                            child: _buildMarkerText(status, price)),
                      ),
                    ],
                  ),
                ),
                RotatedBox(
                  quarterTurns: 2,
                  child: CustomPaint(
                    painter: TrianglePainter(
                      strokeColor: _markerColor(status),
                      strokeWidth: 10,
                      paintingStyle: PaintingStyle.fill,
                    ),
                    child: Container(
                      height: height * 7,
                      width: width * 10,
                    ),
                  ),
                )
              ],
            ),
          ),
          Align(
              alignment: Alignment.topRight,
              child: _electricityIcon(isWithElectiricity)),
        ]),
      ));
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

Widget markerWidget() {
  return _getMarkerWidget(0, Status.owner,false);
      
}

Color _markerColor(Status status) {
  switch (status) {
    case Status.deselected:
      return blue200;
      break;
    case Status.selected:
      return blue500;
      break;
    case Status.admin:
      return yellow400;
      break;
    case Status.deselected:
      return gray800;
      break;
    case Status.owner:
      return blue800;
      break;

    default:
      return blue500;
  }
}

Widget _electricityIcon(bool active) {
  if (active) {
    return Container(
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(16), color: white),
      width: width * 24,
      height: height * 24,
      child: Icon(
        CupertinoIcons.bolt_circle,
        color: blue500,
      ),
    );
  } else {
    return SizedBox();
  }
}



  Widget _buildBackButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Container(
        child: GestureDetector(
          onTap: () => _backButtonFunc(),
          child: Row(
            children: [
              Icon(CupertinoIcons.left_chevron, color: blue500),
              Text(
                "Geri",
                style: TextStyle(fontSize: 17, color: blue500),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard(){
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          color: gray900,
          borderRadius: BorderRadius.circular(16)
        ),
        child: Column(
          children: [
            Expanded(
              flex: 36,
              child: _buildParkTextRow()),
            Expanded(
              flex: 204,
              child: Container(
                child: _buildMap(),
              ),
            )
          ],
        ),
      ),
    );
  }

  Row _buildParkTextRow() {
    return Row(
            children: [
              Spacer(
                flex: 16,
              ),
              Expanded(
                flex: 251,
                child: Text(
                  widget.park.name,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13
                  ),
                ),
              ),
              Spacer(flex: 8,),
              Expanded(child: Text(
                widget.park.price.toString()+" ₺",
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                textAlign: TextAlign.right,
              ),flex: 56,),
              Spacer(flex: 8,)
            ],
          );
  }



  Widget _buildMap(){
    return GoogleMap(
      markers: _markers.toSet(),
      initialCameraPosition: CameraPosition(target: LatLng(widget.park.latitude,widget.park.longitude),zoom: 17),
      myLocationButtonEnabled: false,
      myLocationEnabled: true,
      tiltGesturesEnabled: false,
      zoomGesturesEnabled: false,
      rotateGesturesEnabled: false,
      scrollGesturesEnabled: false,
    );
  }

  Widget _buildDatePick(){
    return Container();
  }

  Widget _buildTimePicker(){
    return Container();
  }

  Widget _buildButton(){
    return Container();
  }

  _backButtonFunc(){
    Get.to(()=>MapScreen());
  }
}