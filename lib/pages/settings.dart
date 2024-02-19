import 'package:badges/badges.dart' as badges;
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:idp_parking_app/services/onlinePayment.dart';
import 'dart:ui';
import 'package:idp_parking_app/uiElements.dart';
import 'package:provider/provider.dart';

import '../services/authService.dart';
import '../services/dbService.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override

  Map<String, dynamic> obtainedUserData = Map<String, dynamic>();
  String paymentMethodName = '';

  Widget build(BuildContext context) {

    final authService = Provider.of<AuthService>(context);
    final dbInstance = Provider.of<FirebaseDatabase>(context);

    Future<void> getProfileData(Map<String, dynamic> userData) async {

      Map<dynamic, dynamic> rawMap = Map<dynamic, dynamic>();
      String uidPath = authService.uid!;

      final DatabaseReference plateRef = dbInstance.ref('RegisteredPlates/${uidPath}');
      final dbSnapshotPlate = await plateRef.get();
      uidPath = dbSnapshotPlate.value as String;
      final DatabaseReference userRef = dbInstance.ref('Users/${uidPath}');
      final dbSnapshot = await userRef.get();

      rawMap = dbSnapshot.value as Map<dynamic, dynamic>;
      convertMap(rawMap, userData);

      print(userData);

      print('test');
      print(userData['paymentMethod'].runtimeType);

      Map<String, String> payMethod = getPaymentMethodMapFromCode(userData['paymentMethod'])!;
      print(payMethod);

      paymentMethodName = payMethod['name']!;
      print(paymentMethodName);
    }

    return Scaffold(
      backgroundColor: uiColorBackground,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: uiColorTransparent,
        flexibleSpace: uiAppBarBlur,
        centerTitle: true,
        title: Text("Account"),
      ),
      body: FutureBuilder(
        future: getProfileData(obtainedUserData),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if(snapshot.connectionState == ConnectionState.done) {
            return ListView(
              shrinkWrap: true,
              physics: ScrollPhysics(),
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(padding: uiPaddingTop),
                    Padding(
                      padding: uiPaddingUSides,
                      child: Text('PROFILE DETAILS'),
                    ),
                    Padding(
                      padding: uiPaddingUSides,
                      child: Card(
                        elevation: uiElevation,
                        shape: uiCardShape,
                        child: Padding(
                          padding: uiPaddingHSides,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Divider(),
                              Padding(
                                padding: uiPaddingAll,
                                // child: Image.asset('assets/images/carPic.png'),
                                child: Icon(Icons.account_circle, size: 125, color: Colors.grey,),
                              ),
                              Divider(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: 100,
                                    child: badges.Badge(
                                      toAnimate: false,
                                      shape: badges.BadgeShape.square,
                                      badgeColor: Colors.grey,
                                      borderRadius: BorderRadius.circular(8),
                                      badgeContent: Center(child: Text(' EMAIL ', style: TextStyle(color: Colors.white))),
                                    ),
                                  ),
                                  Text("${obtainedUserData['email']}")
                                ],
                              ),
                              Divider(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: 100,
                                    child: badges.Badge(
                                      toAnimate: false,
                                      shape: badges.BadgeShape.square,
                                      badgeColor: Colors.grey,
                                      borderRadius: BorderRadius.circular(8),
                                      badgeContent: Center(child: Text(' PASSWORD ', style: TextStyle(color: Colors.white))),
                                    ),
                                  ),
                                  Text("${obtainedUserData['password']}")
                                ],
                              ),
                              Divider(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: 100,
                                    child: badges.Badge(
                                      toAnimate: false,
                                      shape: badges.BadgeShape.square,
                                      badgeColor: Colors.grey,
                                      borderRadius: BorderRadius.circular(8),
                                      badgeContent: Center(child: Text(' USERNAME ', style: TextStyle(color: Colors.white))),
                                    ),
                                  ),
                                  Text("${obtainedUserData['username']}")
                                ],
                              ),
                              Divider(),
                              // Row(
                              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              //   children: [
                              //     SizedBox(
                              //       width: 100,
                              //       child: badges.Badge(
                              //         toAnimate: false,
                              //         shape: badges.BadgeShape.square,
                              //         badgeColor: Colors.grey,
                              //         borderRadius: BorderRadius.circular(8),
                              //         badgeContent: Center(child: Text(' UID ', style: TextStyle(color: Colors.white))),
                              //       ),
                              //     ),
                              //     Text("${obtainedUserData['uid']}")
                              //   ],
                              // ),
                              // Divider(),
                              // Row(
                              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              //   children: [
                              //     SizedBox(
                              //       width: 100,
                              //       child: badges.Badge(
                              //         toAnimate: false,
                              //         shape: badges.BadgeShape.square,
                              //         badgeColor: Colors.grey,
                              //         borderRadius: BorderRadius.circular(8),
                              //         badgeContent: Center(child: Text(' CARD ', style: TextStyle(color: Colors.white))),
                              //       ),
                              //     ),
                              //     // Text('**** **** **** ${obtainedUserData['cardNumber'].substring(12)}'),
                              //     // if(obtainedUserData['cardNumber'] == '' || obtainedUserData['cardNumber'] == "" || obtainedUserData['cardNumber']) Text("--") : Text('**** **** **** ${obtainedUserData['cardNumber'].substring(12)}'),
                              //   ],
                              // ),
                              // Divider(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: 100,
                                    child: badges.Badge(
                                      toAnimate: false,
                                      shape: badges.BadgeShape.square,
                                      badgeColor: Colors.grey,
                                      borderRadius: BorderRadius.circular(8),
                                      badgeContent: Center(child: Text(' PAYMENT ', style: TextStyle(color: Colors.white))),
                                    ),
                                  ),
                                  Text("$paymentMethodName")
                                ],
                              ),
                              Divider(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: 100,
                                    child: badges.Badge(
                                      toAnimate: false,
                                      shape: badges.BadgeShape.square,
                                      badgeColor: Colors.grey,
                                      borderRadius: BorderRadius.circular(8),
                                      badgeContent: Center(child: Text(' BALANCE ', style: TextStyle(color: Colors.white))),
                                    ),
                                  ),
                                  Text("RM ${obtainedUserData['balance']}.00")
                                ],
                              ),
                              Divider(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: 100,
                                    child: badges.Badge(
                                      toAnimate: false,
                                      shape: badges.BadgeShape.square,
                                      badgeColor: Colors.grey,
                                      borderRadius: BorderRadius.circular(8),
                                      badgeContent: Center(child: Text(' UID ', style: TextStyle(color: Colors.white))),
                                    ),
                                  ),
                                  Text("${obtainedUserData['uid'].substring(12)}")
                                ],
                              ),
                              Divider(),
                            ],
                          ),
                        ),
                      ),
                    ),

                    Padding(
                      padding: uiPaddingUSides,
                      child: Text('SIGN OUT'),
                    ),
                    Padding(
                      padding: uiPaddingUSides,
                      child: Card(
                        elevation: uiElevation,
                        shape: uiCardShape,
                        child: Padding(
                          padding: uiPaddingHSides,
                          child: TextButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return CupertinoAlertDialog(
                                    title: Text("Sign Out?"),
                                    content: Text("To access your account, please sign in again."),
                                    actions: [
                                      TextButton(child: Text('Cancel'), onPressed: () {Navigator.pop(context);},),
                                      TextButton(
                                        child: Text('Sign Out', style: TextStyle(color: Colors.red),),
                                        onPressed: () async {
                                          await authService.signOutUserAccount();
                                          Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
                                        },
                                      ),
                                    ],
                                  );
                                } ,
                              );
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'SIGN OUT',
                                  style: TextStyle(color: Colors.red),),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            );
          }
          else {
            return Center(child: CupertinoActivityIndicator());
          }
        }
      ),
    );
  }
}
