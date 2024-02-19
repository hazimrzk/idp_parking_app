import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:idp_parking_app/uiElements.dart';

class SignUpPlate extends StatefulWidget {
  const SignUpPlate({Key? key}) : super(key: key);

  @override
  State<SignUpPlate> createState() => _SignUpPlateState();
}

class _SignUpPlateState extends State<SignUpPlate> {
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
                    child: Text("PLATE NUMBER"),
                  ),
                  
                  Padding(
                    padding: uiPaddingHSides,
                    child: Padding(
                      padding: uiPaddingHSides,
                      child: SizedBox(
                        width: double.infinity,
                        child: Opacity(
                          opacity: 0.5,
                          child: Image.asset('assets/images/plateExample.png'),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: uiPaddingHSides,
                    child: Text('e.g: XYZ000',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ),
                  
                  Padding(
                    padding: uiPaddingUSides,
                    child: TextField(
                      decoration: uiFieldDecoration,
                    ),
                  ),

                  Padding(padding: uiPaddingTop),
                  Padding(
                    padding: uiPaddingUSides,
                    child: TextButton(

                      onPressed: () {},
                      child: Text("Register Plate"),
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
