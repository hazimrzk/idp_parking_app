import 'dart:async';

import 'package:badges/badges.dart' as badges;
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:idp_parking_app/pages/wallet.dart';
import 'dart:ui';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:idp_parking_app/uiElements.dart';

import 'package:idp_parking_app/widgets/nearby.dart';
import 'package:idp_parking_app/widgets/profile.dart';
import 'package:idp_parking_app/widgets/status.dart';
import 'package:provider/provider.dart';
import 'package:swipe_refresh/swipe_refresh.dart';

import '../services/authService.dart';
import '../services/dbService.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  Map<String, dynamic> userData = Map<String, dynamic>();
  Map<String, dynamic> parkingLotData = Map<String, dynamic>();
  List<Map<String, dynamic>> parkList = [];
  Map<String, int> allTime = Map<String, int>();

  void setAllTime(Map<String, int> timeMap, int entryTime) {
    int currentTime = DateTime.now().millisecondsSinceEpoch~/1000;
    int timeDiff = currentTime - entryTime;

    int hour = timeDiff/60~/60;
    int mins = ((timeDiff)~/60)%60;
    int left = 60-mins;
    int effHrs = (timeDiff/60/60).ceil();
    int estFee = effHrs*1;

    timeMap['hour'] = hour;
    timeMap['mins'] = mins;
    timeMap['left'] = left;
    timeMap['effHrs'] = effHrs;
    timeMap['estFee'] = estFee;
  }
  void convertToList(Map<String, dynamic> inputMap, List<Map<String, dynamic>> outList) {
    inputMap.forEach((key, value) {outList.add(Map<String, dynamic>.from(value));});
  }

  Future<void> _refresh() async {
    await Future<void>.delayed(const Duration(seconds: 1));
    setState(() {});
    _controller.sink.add(SwipeRefreshState.hidden);
  }

  final _controller = StreamController<SwipeRefreshState>.broadcast();
  Stream<SwipeRefreshState> get _stream => _controller.stream;

  @override
  void dispose() {
    _controller.close();

    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {

    final authService = Provider.of<AuthService>(context);
    final dbInstance = Provider.of<FirebaseDatabase>(context);

    //Future builder function
    Future<void> getHomeData(Map<String, dynamic> userData, Map<String, dynamic> parkingLotData, Map<String, int> allTime) async {

      // await authService.signOutUserAccount();


      parkList = [];
      Map<dynamic, dynamic> rawMap = Map<dynamic, dynamic>();
      String uidPath = authService.uid!;

      final DatabaseReference plateRef = dbInstance.ref('RegisteredPlates/${uidPath}');
      final dbSnapshotPlate = await plateRef.get();
      uidPath = dbSnapshotPlate.value as String;

      final DatabaseReference userRef = dbInstance.ref('Users/${uidPath}');
      final dbSnapshot = await userRef.get();
      rawMap = dbSnapshot.value as Map<dynamic, dynamic>;
      convertMap(rawMap, userData);
      setAllTime(allTime, userData['parkTime']);

      final DatabaseReference parkingLotRefRef = dbInstance.ref('ParkingLot');
      final dbSnapshot2 = await parkingLotRefRef.get();
      rawMap = dbSnapshot2.value as Map<dynamic, dynamic>;
      convertMap(rawMap, parkingLotData);
      convertToList(parkingLotData, parkList);
    }

    return Scaffold(
      backgroundColor: uiColorBackground,
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        backgroundColor: uiColorTransparent,
        flexibleSpace: uiAppBarBlur,
        // centerTitle: true,
        // titleTextStyle: uiTextStyleAppBar,
        actions: [
          IconButton(
              icon: Icon(Icons.history),
              onPressed: () {
                Navigator.pushNamed(context, '/history');
              }),
          IconButton(
              icon: Icon(Icons.account_balance_wallet),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => WalletV2(passedUserData: userData,),),);
              }),
          IconButton(
              icon: Icon(Icons.manage_accounts),
              onPressed: () {
                Navigator.pushNamed(context, '/settings');
              }),
        ],
        title: Text("Home"),
      ),
      body: SwipeRefresh.cupertino(
          stateStream: _stream,
          onRefresh: _refresh,
        children: [FutureBuilder(
          future: getHomeData(userData, parkingLotData, allTime),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if(snapshot.connectionState == ConnectionState.done) {
              return ListView(
                shrinkWrap: true,
                physics: ScrollPhysics(),
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Padding(padding: uiPaddingTop),
                      // Padding(
                      //   padding: uiPaddingUSides,
                      //   child: Text('PROFILE'),
                      // ),
                      // Padding(
                      //   padding: uiPaddingUSides,
                      //   child: Card(
                      //     elevation: uiElevation,
                      //     shape: uiCardShape,
                      //     child: Column(
                      //       children: [
                      //         Divider(),
                      //         Padding(
                      //           padding: uiPaddingAll,
                      //           // child: Image.asset('assets/images/carPic.png'),
                      //           child: Icon(Icons.account_circle, size: 125, color: Colors.grey,),
                      //         ),
                      //         Divider(),
                      //         Padding(
                      //           padding: uiPaddingHSides,
                      //           child: Row(
                      //             crossAxisAlignment: CrossAxisAlignment.center,
                      //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //             children: [
                      //               SizedBox(
                      //                 width: 75,
                      //                 child: badges.Badge(
                      //                   toAnimate: false,
                      //                   shape: BadgeShape.square,
                      //                   badgeColor: Colors.teal,
                      //                   borderRadius: BorderRadius.circular(8),
                      //                   badgeContent: Center(child: Text(' NAME ', style: TextStyle(color: Colors.white))),
                      //                 ),
                      //               ),
                      //               Text("${userData['username']}"),
                      //             ],
                      //           ),
                      //         ),
                      //         Divider(),
                      //         Padding(
                      //           padding: uiPaddingHSides,
                      //           child: Row(
                      //             crossAxisAlignment: CrossAxisAlignment.center,
                      //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //             children: [
                      //               SizedBox(
                      //                 width: 75,
                      //                 child: badges.Badge(
                      //                   toAnimate: false,
                      //                   shape: BadgeShape.square,
                      //                   badgeColor: Colors.teal,
                      //                   borderRadius: BorderRadius.circular(8),
                      //                   badgeContent: Center(child: Text(' PLATE ', style: TextStyle(color: Colors.white))),
                      //                 ),
                      //               ),
                      //               Text("${userData['plate']}"),
                      //             ],
                      //           ),
                      //         ),
                      //         Divider(),
                      //         Padding(
                      //           padding: uiPaddingHSides,
                      //           child: Row(
                      //             crossAxisAlignment: CrossAxisAlignment.center,
                      //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //             children: [
                      //               SizedBox(
                      //                 width: 75,
                      //                 child: badges.Badge(
                      //                   toAnimate: false,
                      //                   shape: BadgeShape.square,
                      //                   badgeColor: Colors.teal,
                      //                   borderRadius: BorderRadius.circular(8),
                      //                   badgeContent: Center(child: Text(' WALLET ', style: TextStyle(color: Colors.white))),
                      //                 ),
                      //               ),
                      //               Text("RM ${userData['balance']}.00"),
                      //             ],
                      //           ),
                      //         ),
                      //         Divider(),
                      //       ],
                      //     ),
                      //   ),
                      // ),

                      Padding(
                        padding: uiPaddingAll,
                        child: Text('PARKING STATUS'),
                      ),
                      Padding(
                        padding: uiPaddingUSides,
                        child: !userData['parkStatus'] ? StatusDisabled() : Card(
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
                                      badgeContent: Text(' ${userData['parkLocation']} ', style: TextStyle(color: Colors.white)),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: uiPaddingUSides,
                                child: CircularPercentIndicator(
                                  lineWidth: 10,
                                  radius: 100,
                                  percent: (allTime['mins']!/60),
                                  circularStrokeCap: CircularStrokeCap.round,
                                  progressColor: Colors.orange,
                                  backgroundColor: uiColorBackground,
                                  animation: true,
                                  animationDuration: 5000,
                                  curve: Curves.easeOutCubic,
                                  center: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text('${allTime['hour'].toString().padLeft(2, '0')}:${allTime['mins'].toString().padLeft(2, '0')}',
                                        style: uiTextStyleBigNumbersClock,),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: uiPaddingUSides,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("${allTime['left']}", style: TextStyle(color: Colors.teal),),
                                    Text(" mins before the next hour"),
                                  ],
                                ),
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
                                            Text('${allTime['effHrs']}', style: uiTextStyleBigNumbersClock,),
                                            Text('  HRS')
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
                                            Text('${allTime['estFee']}', style: uiTextStyleBigNumbersClock,)
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      Padding(
                        padding: uiPaddingAll,
                        child: Text('NEARBY LOTS'),
                      ),
                      Padding(
                        padding: uiPaddingUSides,
                        child: Nearby(parkList: parkList,),
                      ),
                    ],
                  )
                ],
              );
            } else {
              return Center(child: CupertinoActivityIndicator());
            }
          },
        ),]
      ),
    );
  }
}

class StatusDisabled extends StatelessWidget {
  const StatusDisabled({Key? key}) : super(key: key);

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
                  badgeColor: Colors.teal,
                  borderRadius: BorderRadius.circular(8),
                  badgeContent: Text(' NOT PARKED ', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
          Padding(
            padding: uiPaddingHSides,
            child: Divider(height: 0, color: uiColorDividers,),
          ),
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
                  badgeColor: Colors.grey,
                  borderRadius: BorderRadius.circular(8),
                  badgeContent: Text(' -- ', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
          Padding(
            padding: uiPaddingUSides,
            child: CircularPercentIndicator(
              lineWidth: 10,
              radius: 100,
              percent: 0,
              circularStrokeCap: CircularStrokeCap.round,
              progressColor: Colors.grey,
              backgroundColor: uiColorBackground,
              animation: true,
              animationDuration: 5000,
              curve: Curves.easeOutCubic,
              center: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('-- : --',style: uiTextStyleBigNumbersClock,),
                ],
              ),
            ),
          ),
          Padding(
            padding: uiPaddingUSides,
            child: Text("- mins before the next hour", textAlign: TextAlign.center,),
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
                        Text('-', style: uiTextStyleBigNumbers,),
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
                        Text('-', style: uiTextStyleBigNumbers,)
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
