import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:idp_parking_app/uiElements.dart';

//ListViewBuilder

class Nearby extends StatefulWidget {
  const Nearby({Key? key, required this.parkList}) : super(key: key);

  final List<Map<String, dynamic>> parkList;

  @override
  State<Nearby> createState() => _NearbyState();
}

class _NearbyState extends State<Nearby> {
  @override

  Widget build(BuildContext context) {
    return  Card(
      elevation: uiElevation,
      shape: uiCardShape,
      child: Padding(
        padding: uiPaddingHSides,
        child: ListView(
          shrinkWrap: true,
          children: [
            Divider(),
            ListView.builder(
              shrinkWrap: true,
              physics: ScrollPhysics(),
              itemCount: widget.parkList.length,
              itemBuilder: (context , index) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(widget.parkList[index]['name']),
                    Padding(
                      padding: const EdgeInsets.only(top: uiPaddingValue/4, bottom: uiPaddingValue/4),
                      child: LinearPercentIndicator(
                        padding: EdgeInsets.zero,
                        animation: true,
                        lineHeight: 10,
                        animationDuration: 5000,
                        percent: widget.parkList[index]['occupied']/widget.parkList[index]['capacity'],
                        backgroundColor: uiColorBackground,
                        barRadius: Radius.circular(10),
                        progressColor: Colors.orange,
                        curve: Curves.easeOutCubic,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('${widget.parkList[index]['capacity']-widget.parkList[index]['occupied']} available space(s)'),
                        Text('${widget.parkList[index]['occupied']*100~/widget.parkList[index]['capacity']}% Full'),
                      ],
                    ),
                    Divider(),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
