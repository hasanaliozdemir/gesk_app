import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gesk_app/core/colors.dart';
import 'package:gesk_app/core/components/bottomBar.dart';
import 'package:gesk_app/models/reservation.dart';
import 'package:get/get.dart';

class ReservationsScreen extends StatefulWidget {
  const ReservationsScreen({Key key}) : super(key: key);

  @override
  _ReservationsScreenState createState() => _ReservationsScreenState();
}

class _ReservationsScreenState extends State<ReservationsScreen> {
  final int _index = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomBar(index: _index),
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).padding.top,
          ),
          Spacer(
            flex: 56,
          ),
          Expanded(
            flex: 160,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Image.asset("assets/images/blueCard.png"),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    child: Image.asset("assets/images/grayCard.png"),
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    
                ))
              ],
            )
          ),
          Spacer(
            flex: 37,
          ),
          Expanded(
            flex: 432,
            child: _buildReservations(),
          )
        ],
      ),
    );
  }

  _buildReservations() {
    return ListView.builder(
      shrinkWrap: false,
      itemCount: reservations.length ?? 0,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.all(8),
          child: Container(
            height: Get.height / 812 * 56,
            child: ListTile(
              leading: Container(
                width: Get.width / 375 * 36,
                height: Get.width / 375 * 36,
                decoration: BoxDecoration(
                    color: gray700, borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ),
        );
      },
    );
  }

  List<Reservation> reservations = [
    Reservation(
        reservationId: 0,
        date: "21.08.21",
        start: "18.00",
        end: "19.00",
        parkId: 0,
        tpaId: 0,
        owner: false)
  ];
}
