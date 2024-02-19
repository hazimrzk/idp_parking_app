import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:idp_parking_app/uiElements.dart';

class SignUpPayment extends StatefulWidget {
  const SignUpPayment({Key? key}) : super(key: key);

  @override
  State<SignUpPayment> createState() => _SignUpPaymentState();
}

class _SignUpPaymentState extends State<SignUpPayment> {

  bool allowAutoReload = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: uiColorBackground,
      extendBodyBehindAppBar: true,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(padding: uiPaddingTop,),

          Padding(padding: uiPaddingTop),
          Padding(
            padding: uiPaddingUSides,
            child: Card(
              elevation: uiElevation,
              shape: uiCardShape,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(padding: uiPaddingTop),
                  Padding(
                    padding: uiPaddingAll,
                    child: Text("CHOOSE PAYMENT METHOD"),
                  ),
                  Padding(padding: uiPaddingTop),
                  Padding(
                    padding: uiPaddingUSides,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(Icons.credit_card),
                            Text('Credit/Debit'),
                          ],
                        ),
                        Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(Icons.account_balance_wallet),
                            Text('TouchnGo eWallet'),
                          ],
                        ),
                        Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(Icons.account_balance),
                            Text('Online Banking'),
                          ],
                        ),
                      ],
                    ),
                  ),

                  Padding(padding: uiPaddingTop),
                  Padding(
                    padding: uiPaddingAll,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("ENABLE AUTO RELOAD"),
                        Switch(
                          onChanged: (bool) {allowAutoReload = !allowAutoReload;}, // set state must be written
                          value: allowAutoReload,
                        ),
                      ],
                    ),
                  ),
                  // Padding(
                  //   padding: uiPaddingUSides,
                  //   child: Text('Applicable for payment via credit or debit card.',
                  //     textAlign: TextAlign.center,
                  //     style: TextStyle(fontStyle: FontStyle.italic),
                  //   ),
                  // ),
                  Padding(padding: uiPaddingTop),
                  Padding(
                    padding: uiPaddingUSides,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            badges.Badge(
                              toAnimate: false,
                              shape: badges.BadgeShape.square,
                              badgeColor: Colors.blueGrey,
                              borderRadius: BorderRadius.circular(8),
                              badgeContent: Text(' Top up this amount ', style: TextStyle(color: Colors.white)),
                            ),
                          ],
                        ),
                        Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            badges.Badge(
                              toAnimate: false,
                              shape: badges.BadgeShape.square,
                              badgeColor: Colors.blueGrey,
                              borderRadius: BorderRadius.circular(8),
                              badgeContent: Text(' If balance is below ', style: TextStyle(color: Colors.white)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  Padding(padding: uiPaddingTop),
                  Padding(
                    padding: uiPaddingUSides,
                    child: TextButton(
                      onPressed: () {},
                      child: Text("Save Details"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
