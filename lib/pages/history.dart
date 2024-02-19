import 'dart:ffi';

import 'package:badges/badges.dart' as badges;
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:idp_parking_app/uiElements.dart';
import 'package:provider/provider.dart';

import '../services/authService.dart';

class History extends StatefulWidget {
  const History({Key? key}) : super(key: key);

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {

  List<DropdownMenuItem<String>> pickPeriod = <String>['Past Week', 'Past Month', 'Past 3 Months']
      .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(value: value, child: Text(value),);
      }).toList();


  // Add each child into list. The elements of the list is
  Map<String,int> summaryMap = {};
  List<Map<String,dynamic>> rawHistory = [];
  List<Map<String,dynamic>> readableHistory = [];

  // List<Map<String,dynamic>> rawHistory = [
  //   <String,dynamic>{ 'location' : 'KL Gateway' , 'entryTime' : 1655455337 , 'exitTime' : 1655461337 , 'duration' : 1655455337-1655461337 , 'fee' : 2 },
  //   <String,dynamic>{ 'location' : 'UM KK12' , 'entryTime' : 1655365337 , 'exitTime' : 1655365337 , 'duration' : 1655365337-1655365337 , 'fee' : 0 },
  //   <String,dynamic>{ 'location' : 'KL Gateway' , 'entryTime' : 1655275337 , 'exitTime' : 1655283337 , 'duration' : 1655275337-1655283337 , 'fee' : 3 },
  //   <String,dynamic>{ 'location' : 'Prototype' , 'entryTime' : 1655185337 , 'exitTime' : 1655190337 , 'duration' : 1655185337-1655190337 , 'fee' : 2 },
  //   <String,dynamic>{ 'location' : 'UM KK12' , 'entryTime' : 1655095337 , 'exitTime' : 1655110337 , 'duration' : 1655095337-1655100337 , 'fee' : 5 },
  // ];

  void convertToReadableList(List<Map<String,dynamic>> oldList, List<Map<String,dynamic>> newList, Map<String,int> summaryMap) {
    int sumTimes = 0;
    int sumHours = 0;
    int sumFees = 0;

    oldList.forEach((element) {
      DateTime entryTimeDT = DateTime.fromMillisecondsSinceEpoch(element['entryTime']*1000); //.isUTC or isUtc = true
      DateTime exitTimeDT = DateTime.fromMillisecondsSinceEpoch(element['exitTime']*1000); //.isUTC or isUtc = true
      int durationHours = (element['exitTime']-element['entryTime'])/60~/60;
      int durationMins = (element['exitTime']-element['entryTime'])~/60%60;

      String location = element['location'];
      String parkDate = "${entryTimeDT.day}-${entryTimeDT.month}";
      String entryHrMin = "${entryTimeDT.hour.toString().padLeft(2, '0')}:${entryTimeDT.minute.toString().padLeft(2, '0')}";
      String exitHrMin = "${exitTimeDT.hour.toString().padLeft(2, '0')}:${exitTimeDT.minute.toString().padLeft(2, '0')}";
      String duration = '${durationHours.toString().padLeft(2, '0')}:${durationMins.toString().padLeft(2, '0')}';
      String fee = '${((element['exitTime']-element['entryTime'])/60/60).ceil()}.00';

      sumTimes = sumTimes + 1;
      sumHours = sumHours + ((element['exitTime']-element['entryTime']) as int);
      sumFees = sumFees + ((element['exitTime']-element['entryTime'])/60/60).ceil() as int;

      newList.add({ 'location' : location , 'date' : parkDate, 'entryTime' : entryHrMin , 'exitTime' : exitHrMin , 'duration' : duration , 'fee' : fee });
    });

    sumHours = sumHours/60~/60;
    summaryMap['times'] = sumTimes;
    summaryMap['hours'] = sumHours;
    summaryMap['fees'] = sumFees;

    print(newList);
    print(summaryMap);
  }

  @override
  Widget build(BuildContext context) {

    final authService = Provider.of<AuthService>(context);
    final dbInstance = Provider.of<FirebaseDatabase>(context);

    convertToReadableList(rawHistory, readableHistory, summaryMap);

    Future<void> getHistoryData(List<Map<String,dynamic>> rawHistory) async {
      Map<dynamic, dynamic> rawMap = <dynamic, dynamic>{};
      String uidPath = authService.uid!;

      final DatabaseReference plateRef = dbInstance.ref('RegisteredPlates/${uidPath}');
      final dbSnapshotPlate = await plateRef.get();
      uidPath = dbSnapshotPlate.value as String;

      final DatabaseReference histRef = dbInstance.ref('UserHistory/${uidPath}');
      final dbSnapshot = await histRef.get();
      rawMap = dbSnapshot.value as Map<dynamic, dynamic>;

      rawMap.forEach((key, value) {
        print(value);
        rawHistory.add(Map<String, dynamic>.from(value));
      });
      print('done!!!!');
      print(rawHistory);
      convertToReadableList(rawHistory, readableHistory, summaryMap);
    }

    return Scaffold(
      backgroundColor: uiColorBackground,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: uiColorTransparent,
        flexibleSpace: uiAppBarBlur,
        centerTitle: true,
        title: Text("History"),
      ),
      body: FutureBuilder(
        future: getHistoryData(rawHistory),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return ListView(
            shrinkWrap: true,
            physics: ScrollPhysics(),
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: uiPaddingAll,
                    child: Text('SHOW FROM'),
                  ),
                  Padding(
                    padding: uiPaddingUSides,
                    child: Card(
                      elevation: uiElevation,
                      shape: uiCardShape,
                      child: Padding(
                        padding: uiPaddingHSides,
                        child: DropdownButton<String>(
                          isExpanded: true,
                          elevation: 0,
                          value: 'Past Week',
                          icon: const Icon(Icons.keyboard_arrow_down),
                          items: pickPeriod,
                          underline: Container(
                            color: Colors.transparent,
                          ),
                          onChanged: (String? newValue) {},
                        ),
                      ),
                    ),
                  ),

                  Padding(
                    padding: uiPaddingAll,
                    child: Text('SUMMARY'),
                  ),
                  Padding(
                    padding: uiPaddingZero,
                    child: SizedBox(
                      width: double.infinity,
                      height: 200,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          SizedBox(
                            width: uiPaddingValue,
                          ),
                          Card(
                            elevation: uiElevation,
                            shape: uiCardShape,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: uiPaddingAll,
                                  child: Text('${summaryMap['times']}', style: uiTextStyleBigNumbers,),
                                ),
                                SizedBox(width: 125),
                                Padding(
                                  padding: uiPaddingHSides,
                                  child: Text("TIMES", textAlign: TextAlign.center,),
                                ),
                                Padding(
                                  padding: uiPaddingUSides,
                                  child: Text("PARKED", textAlign: TextAlign.center,),
                                ),
                              ],
                            ),
                          ),
                          Card(
                            elevation: uiElevation,
                            shape: uiCardShape,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: uiPaddingAll,
                                  child: Text('${summaryMap['hours']}', style: uiTextStyleBigNumbers,),
                                ),
                                SizedBox(width: 125),
                                Padding(
                                  padding: uiPaddingHSides,
                                  child: Text("HOURS", textAlign: TextAlign.center,),
                                ),
                                Padding(
                                  padding: uiPaddingUSides,
                                  child: Text("SPENT", textAlign: TextAlign.center,),
                                ),
                              ],
                            ),
                          ),
                          Card(
                            elevation: uiElevation,
                            shape: uiCardShape,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: uiPaddingAll,
                                  child: Text('${summaryMap['fees']}', style: uiTextStyleBigNumbers,),
                                ),
                                SizedBox(width: 125),
                                Padding(
                                  padding: uiPaddingHSides,
                                  child: Text("FEES", textAlign: TextAlign.center,),
                                ),
                                Padding(
                                  padding: uiPaddingUSides,
                                  child: Text("PAID", textAlign: TextAlign.center,),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: uiPaddingValue,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(padding: uiPaddingTop),

                  Padding(
                    padding: uiPaddingAll,
                    child: Text('PAST ENTRIES '),
                  ),

                  Padding(
                    padding: uiPaddingUSides,
                    child: Row(
                      children: [
                        SizedBox(width: uiPaddingValue/2,),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: 130,
                                child: badges.Badge(
                                  toAnimate: false,
                                  shape: badges.BadgeShape.square,
                                  badgeColor: Colors.grey,
                                  borderRadius: BorderRadius.circular(8),
                                  badgeContent: Center(child: Text(' LOCATION ', style: TextStyle(color: Colors.white))),
                                ),
                              ),
                              SizedBox(
                                width: 55,
                                child: badges.Badge(
                                  toAnimate: false,
                                  shape: badges.BadgeShape.square,
                                  badgeColor: Colors.grey,
                                  borderRadius: BorderRadius.circular(8),
                                  badgeContent: Center(child: Text(' DATE ', style: TextStyle(color: Colors.white))),
                                ),
                              ),
                              SizedBox(
                                width: 55,
                                child: badges.Badge(
                                  toAnimate: false,
                                  shape: badges.BadgeShape.square,
                                  badgeColor: Colors.grey,
                                  borderRadius: BorderRadius.circular(8),
                                  badgeContent: Center(child: Text(' FEES ', style: TextStyle(color: Colors.white))),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: uiPaddingValue/2,),
                        SizedBox(width: uiPaddingValue/2,),
                        Icon(Icons.keyboard_arrow_down, color: Colors.grey,),
                        SizedBox(width: uiPaddingValue,),
                      ],
                    ),
                  ),

                  ListView.builder(
                      shrinkWrap: true,
                      physics: ScrollPhysics(),
                      itemCount: rawHistory.length,
                      itemBuilder: (context ,index) {
                        return Padding(
                          padding: uiPaddingUSides,
                          child: Card(
                            elevation: uiElevation,
                            shape: uiCardShape,
                            child: ExpansionTile(
                              title: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Expanded(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(width: 120, child: Text("${readableHistory[index]['location']}"),),
                                        SizedBox(width: 60, child: Center(child: Text("${readableHistory[index]['date']}"))),
                                        SizedBox(width: 60, child: Center(child: Text("${readableHistory[index]['fee']}"))),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              children: [
                                Padding(
                                  padding: uiPaddingUSides,
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("Car Plate:"),
                                          Text("XYZ1234")
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("Enter Time:"),
                                          Text("${readableHistory[index]['entryTime']}")
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("Exit Time:"),
                                          Text("${readableHistory[index]['exitTime']}")
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("Duration:"),
                                          Text("${readableHistory[index]['duration']}"),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("Payment Method:"),
                                          Text("TnG EWallet")
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      }
                  ),

                ],
              )
            ],
          );
        }
      ),
    );
  }
}
