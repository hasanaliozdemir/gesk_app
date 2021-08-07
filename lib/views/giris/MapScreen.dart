import 'dart:async';
import 'dart:typed_data';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:gesk_app/core/components/bottomBar.dart';
import 'package:gesk_app/core/components/customSwitch.dart';
import 'package:gesk_app/core/components/parkCard.dart';
import 'package:gesk_app/core/components/searchBar.dart';
import 'package:gesk_app/data_models/user_location.dart';
import 'package:gesk_app/views/giris/park_detail.dart';
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gesk_app/core/colors.dart';
import 'package:gesk_app/core/funcs/triangleCreator.dart';
import 'package:gesk_app/models/park.dart';
import 'package:gesk_app/services/markerCreator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:dio/dio.dart' as dp;
import 'package:provider/provider.dart';

var _electricitySelected = false.obs;
var width = Get.width / 375;
var height = Get.height / 812;
dp.Dio dio = new dp.Dio();

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  int _selectedIndex = 0;
  int _caroselIndex = 0;
  final _index = 0;

  CarouselController carouselController = CarouselController();
  GoogleMapController _controller;
  List<Marker> _markers = [];
  String _imageUrl =
      "https://images.unsplash.com/photo-1552519507-da3b142c6e3d?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1000&q=80";

  CameraPosition cameraPosition =
      CameraPosition(target: LatLng(40.355499, 27.971991), zoom: 17);

  @override
  Widget build(BuildContext context) {
    var userLocation = Provider.of<UserLocation>(context);

    return Scaffold(
      body: Stack(
        children: [
          Container(
            child: Stack(
              children: <Widget>[
                GoogleMap(
                  onMapCreated: (GoogleMapController controller) {
                    _controller = controller;
                  },
                  myLocationEnabled: true,
                  mapType: MapType.terrain,
                  initialCameraPosition: cameraPosition,
                  markers: _markers.toSet(),
                  myLocationButtonEnabled: true,
                ),
              ],
            ),
          ),
          _buildSearchBar(context),
          Container(
            alignment: Alignment.bottomCenter,
            padding: EdgeInsets.only(bottom: 24),
            child: CarouselSlider.builder(
              carouselController: carouselController,
              itemCount: _markers.length ?? 0,
              options: CarouselOptions(
                enableInfiniteScroll: false,
                onPageChanged: (index, reason) {
                  setState(() {
                    _caroselIndex = index;
                    _selectedIndex = _caroselIndex;
                  });

                  _controller.animateCamera(CameraUpdate.newCameraPosition(
                      CameraPosition(
                          target: LatLng(
                              _parks[index].latitude, _parks[index].longitude),
                          zoom: 16)));
                },
                height: h * 128,
              ),
              itemBuilder: (context, itemIndex, pageIndex) {
                return Container(
                  height: h * 128,
                  width: w * 264,
                  child: GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          backgroundColor: Colors.white,
                          context: context,
                          builder: (context) {
                            return ParkDetail(
                              park: _parks[itemIndex],
                            );
                          });
                    },
                    child: ParkCard(
                        imageUrl: _imageUrl,
                        point: _parks[itemIndex].point,
                        name: _parks[itemIndex].name,
                        location: "maslak",
                        distance: "4.5",
                        price: "18,00₺",
                        variants: [1]),
                  ),
                );
              },
            ),
          ),
          Positioned(
              top: MediaQuery.of(context).padding.top + (h * 108),
              left: w * 300,
              child: Container(
                  width: w * 56,
                  height: h * 31,
                  child: CustomSwitch(
                    value: _electricitySelected,
                    activeToggleColor: white,
                    activeIcon: Icon(
                      CupertinoIcons.bolt_fill,
                      color: blue500,
                    ),
                    passiveIcon: Icon(
                      CupertinoIcons.bolt_fill,
                      color: white,
                    ),
                    passiveToggleColor: blue400,
                    func: () {
                      MarkerGenerator(markerWidgets(), (bitmaps) {
                        setState(() {
                          _markers = mapBitmapsToMarkers(bitmaps);
                        });
                      }).generate(context);
                    },
                  )))
        ],
      ),
      bottomNavigationBar: BottomBar(
        index: _index,
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
      final park = _parks[i];
      _markersList.add(Marker(
          onTap: () {
            _controller
              ..animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
                  target: LatLng(park.latitude, park.longitude), zoom: 16)));
            setState(() {
              _selectedIndex =
                  _parks.indexWhere((element) => element.id == park.id);
            });
            carouselController.animateToPage(_selectedIndex,
                duration: Duration(seconds: 1));

            // TODO: _getDistance(cameraPosition.target, park.position);
          },
          markerId: MarkerId(park.id.toString()),
          position: LatLng(park.latitude, park.longitude),
          icon: BitmapDescriptor.fromBytes(bmp)));
    });
    return _markersList;
  }
}

// Example of marker widget
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

// Example of backing data
List<Park> _parks = [
  Park(
    name: "Bandırma",
    latitude: 40.355499,
    longitude: 27.971991,
    price: 18.00,
    status: Status.admin,
    isWithCam: true,
    filledParkSpace: 4,
    id: 0,
    isWeithElectricity: true,
    isWithSecurity: true,
    point: 4.5,
    parkSpace: 6,
  ),
];

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

List<Widget> markerWidgets() {
  return _parks
      .map((c) => _getMarkerWidget(c.price, c.status, c.isWeithElectricity))
      .toList();
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
  if (active && _electricitySelected.value) {
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

_buildSearchBar(context) {
  return Positioned(
      top: MediaQuery.of(context).padding.top + (h * 36),
      left: 16,
      child: Row(
        children: [
          SearchBar(),
          SizedBox(
            width: 8,
          ),
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
                color: white,
                boxShadow: [
                  BoxShadow(
                    color: Color(0x33000000),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
                borderRadius: BorderRadius.circular(8)),
            child: Icon(
              CupertinoIcons.slider_horizontal_3,
              color: blue500,
            ),
          )
        ],
      ));
}

_getDistance(LatLng location, LatLng target) async {
  dp.Response response = await dio.get(
      "https://maps.googleapis.com/maps/api/distancematrix/json?units=imperial&origins=40.6655101,-73.89188969999998&destinations=40.6905615%2C,-73.9976592&key=AIzaSyAm5L6H-LaUyOUlHNt_nMwy7b_VNRxPPLM");

  print(response.data);
}

Future<Uint8List> getPerson(context) async {
  ByteData byteData =
      await DefaultAssetBundle.of(context).load("assets/icons/person2.svg");
  return byteData.buffer.asUint8List();
}
