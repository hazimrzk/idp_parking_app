import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:idp_parking_app/uiElements.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: uiElevation,
      shape: uiCardShape,
      child: Column(
        children: [
          Divider(),
          Padding(
            padding: uiPaddingAll,
            child: Image.asset('assets/images/carPic.png'),
          ),
          Divider(),
          Padding(
            padding: uiPaddingHSides,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                badges.Badge(
                  toAnimate: false,
                  shape: badges.BadgeShape.square,
                  badgeColor: Colors.grey,
                  borderRadius: BorderRadius.circular(8),
                  badgeContent: Text(' NAME ', style: TextStyle(color: Colors.white)),
                ),
                Text("John Doe"),
              ],
            ),
          ),
          Divider(),
          Padding(
            padding: uiPaddingHSides,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                badges.Badge(
                  toAnimate: false,
                  shape: badges.BadgeShape.square,
                  badgeColor: Colors.grey,
                  borderRadius: BorderRadius.circular(8),
                  badgeContent: Text(' PLATE ', style: TextStyle(color: Colors.white)),
                ),
                Text("XYZ1234"),
              ],
            ),
          ),
          Divider(),
          Padding(
            padding: uiPaddingHSides,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                badges.Badge(
                  toAnimate: false,
                  shape: badges.BadgeShape.square,
                  badgeColor: Colors.grey,
                  borderRadius: BorderRadius.circular(8),
                  badgeContent: Text(' BALANCE ', style: TextStyle(color: Colors.white)),
                ),
                Text("RM 12.00"),
              ],
            ),
          ),
          Divider(),
        ],
      ),
    );
  }
}
