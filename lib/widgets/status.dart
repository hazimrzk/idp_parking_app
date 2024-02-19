import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:idp_parking_app/uiElements.dart';
import 'package:badges/badges.dart' as badges;
import 'package:slide_to_confirm/slide_to_confirm.dart';

class Status extends StatefulWidget {
  const Status({Key? key}) : super(key: key);

  @override
  State<Status> createState() => _StatusState();
}

class _StatusState extends State<Status> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: uiElevation,
      shape: uiCardShape,
      child: Column(
        children: [
          Padding(
            padding: uiPaddingAll,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Status:"),
                badges.Badge(
                  toAnimate: false,
                  shape: badges.BadgeShape.square,
                  badgeColor: Colors.orange,
                  borderRadius: BorderRadius.circular(8),
                  badgeContent: Text(' PARKED ', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
          // Padding(
          //   padding: uiPaddingUSides,
          //   child: ConfirmationSlider(
          //     text: "Slide to Authorize Parking",
          //     shadow: BoxShadow(color: Colors.transparent),
          //     height: 50,
          //     backgroundColor: uiColorBackground,
          //     backgroundColorEnd: Colors.orange.shade50,
          //     foregroundColor: Colors.orange,
          //     onConfirmation: () {},
          //   ),
          // ),
          Divider(height: 0, color: uiColorDividers,),
          Padding(
            padding: uiPaddingAll,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Parked at:"),
                badges.Badge(
                  toAnimate: false,
                  shape: badges.BadgeShape.square,
                  badgeColor: Colors.orange,
                  borderRadius: BorderRadius.circular(8),
                  badgeContent: Text(' KL GATEWAY ', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
          Padding(
            padding: uiPaddingUSides,
            child: CircularPercentIndicator(
              lineWidth: 10,
              radius: 100,
              percent: 0.7,
              circularStrokeCap: CircularStrokeCap.round,
              progressColor: Colors.orange,
              backgroundColor: uiColorBackground,
              animation: true,
              animationDuration: 5000,
              curve: Curves.easeOutCubic,
              center: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('16',style: uiTextStyleBigNumbersClock,),
                  Text('mins'),
                ],
              ),
            ),
          ),
          Padding(
            padding: uiPaddingUSides,
            child: Text("before the next hour", textAlign: TextAlign.center,),
          ),
          Padding(
            padding: uiPaddingUSides,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Text('Effective Hours'),
                    Row(
                      children: [
                        Text('5', style: uiTextStyleBigNumbers,),
                        Text('HRS')
                      ],
                    ),
                  ],
                ),
                Container(
                  height: 50,
                  width: 1.5,
                  color: uiColorBackground,
                ),
                Column(
                  children: [
                    Text('Estimated Fees'),
                    Row(
                      children: [
                        Text('RM'),
                        Text('5', style: uiTextStyleBigNumbers,)
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
