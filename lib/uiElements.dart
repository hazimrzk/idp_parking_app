import 'package:flutter/material.dart';
import 'dart:ui';

// Colorings
// Main elements
const Color uiColorTheme = Color(0xff6750a4); // Color.fromRGBO(255, 220, 150, 1);

const Color uiColorAppBar = Color.fromRGBO(255, 255, 255, 0.55);
const Color uiColorBackground = Color.fromRGBO(240, 240, 245, 1);
const Color uiColorTransparent = Color.fromRGBO(255, 255, 255, 0);
const Color uiColorForeground = Color.fromRGBO(255, 255, 255, 1);
const Color uiColorDividers = Color.fromRGBO(0, 0, 0, 0.25);

// Widgets elements
// Cards (M3's outline cards)
const Color uiColorCardFill = Color.fromRGBO(50, 50, 50, 1);
const Color uiColorCardOutline = Color.fromRGBO(90, 90, 90, 1);


// Shapes

// Borders
const double uiBorderCorner = 10;
const double uiBorderThickness = 3;
const BorderRadius uiBorderRadius = BorderRadius.all(Radius.circular(uiBorderCorner));
const BorderRadius uiClipRadiusForElements = BorderRadius.all(Radius.circular(uiBorderCorner/2));

// Elevations
const double uiElevation = 0;

// Paddings
const double uiPaddingValue = 20;
const EdgeInsetsGeometry uiPaddingAll = EdgeInsets.all(uiPaddingValue);
const EdgeInsetsGeometry uiPaddingTop = EdgeInsets.only(top: uiPaddingValue);
const EdgeInsetsGeometry uiPaddingZero = EdgeInsets.all(0);
const EdgeInsetsGeometry uiPaddingUSides = EdgeInsets.only(left: uiPaddingValue, right: uiPaddingValue, bottom: uiPaddingValue);
const EdgeInsetsGeometry uiPaddingHSides = EdgeInsets.symmetric(horizontal: uiPaddingValue);
const EdgeInsetsGeometry uiPaddingVSides = EdgeInsets.symmetric(vertical: uiPaddingValue);

// Text styles
const double uiTextDisplayL = 64;
const double uiTextDisplayM = 52;
const double uiTextDisplayS = 44;
const double uiTextHeadlineL = 40;
const double uiTextHeadlineM = 36;
const double uiTextHeadlineS = 32;
const double uiTextTitleL = 28;
const double uiTextTitleM = 24;
const double uiTextTitleS = 20;
const double uiTextLabelL = 20;
const double uiTextLabelM = 16;
const double uiTextLabelS = 6;
const double uiTextBodyL = 24;
const double uiTextBodyM = 20;
const double uiTextBodyS = 16;

const TextStyle uiTextStyleBigNumbers = TextStyle(
  fontSize: uiTextDisplayL,
  fontWeight: FontWeight.bold,
  //letterSpacing: -7.5,
  color: Colors.teal,
);

const TextStyle uiTextStyleBigNumbersClock = TextStyle(
  fontSize: uiTextDisplayL,
  fontWeight: FontWeight.bold,
  letterSpacing: -7.5,
  color: Colors.teal,
);

const TextStyle uiTextStyleAppBar = TextStyle(
  fontWeight: FontWeight.bold,
  fontSize: uiTextLabelL,
  letterSpacing: -1,
  color: Colors.black,
);

// Compound attributes

//not a const due to child container's constraint
ClipRect uiAppBarBlur = ClipRect(
  child: BackdropFilter(
    filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
    child: Container(
      color: uiColorAppBar,
    ),
  ),
);

const RoundedRectangleBorder uiCardShape = RoundedRectangleBorder(
  borderRadius: uiBorderRadius,
  // side: BorderSide(
  //     //color: uiColorCardOutline,
  //     width: uiBorderThickness,
  //     style: BorderStyle.solid,
  // )
);


const InputDecoration uiFieldDecoration = InputDecoration(
);
// Widget Styles
// Card

// class CardFilled extends StatelessWidget {
//   const CardFilled({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Card(
//         elevation: uiElevations,
//         shape: RoundedRectangleBorder(
//           // borderRadius: ,
//           // side: BorderSide(),
//         ),
//         //child: SizedBox(),
//       ),
//     );
//   }
// }
