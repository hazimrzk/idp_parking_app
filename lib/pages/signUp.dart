import 'package:badges/badges.dart' as badges;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:idp_parking_app/pages/ready.dart';
import 'package:idp_parking_app/pages/signUpPages/signUpEmailPassword.dart';
import 'package:idp_parking_app/pages/signUpPages/signUpPayment.dart';
import 'package:idp_parking_app/pages/signUpPages/signUpPlate.dart';
import 'package:idp_parking_app/services/onlinePayment.dart';
import 'dart:ui';
import 'package:idp_parking_app/uiElements.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:regexed_validator/regexed_validator.dart';

import '../services/authService.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {

  //Variables
  Map<String, dynamic> givenData = {
   'email' : "",
   'password' : "",
   'username' : '',
   'plate' : "",
   'paymentMethod' : "",
   'cardNumber' : "",
   'ARAmount' : 10,
   'ARTrigger' : 10,
   'ARAllowed' : false,
  };

  String emailTakenMessage = '';
  String plateTakenMessage = '';
  bool emailTaken = false;
  bool plateTaken = false;
  bool isPasswordMismatch = false;
  String isPasswordMismatchMessage = 'Passwords do not match';

  //Forms, validators, & controllers
  bool isValidAndProceed = false;
  int pageIndex = 0;
  final _signUpFormKey = GlobalKey<FormState>();
  final _popUpFormKey = GlobalKey<FormState>();


  String? emailValidator(String? inputEmail) {
    if(emailTaken) {return emailTakenMessage;}
    if(inputEmail == null || !validator.email(inputEmail)) {return "Enter a valid email";}
    else {return null;}
  }
  String? passwordValidator(String? inputPassword) {
    if(isPasswordMismatch) {return isPasswordMismatchMessage;}
    if(inputPassword == null || !validator.mediumPassword(inputPassword)) {return "Password is not strong";}
    else {return null;}  }
  String? confirmPasswordValidator(String? inputPlate) {
    if(isPasswordMismatch) {return isPasswordMismatchMessage;}
    if(inputPlate == null || !validator.mediumPassword(inputPlate)) {return "Password is not strong";}
    else {return null;}  }
  String? plateValidator(String? inputPlate) {
    final validCharacters = RegExp(r'^[a-zA-Z0-9]+$');
    if(plateTaken) {return plateTakenMessage;}
    if(inputPlate == null || !validCharacters.hasMatch(inputPlate)) {return "Enter a valid plate number";}
    else {return null;}
  }
  String? cardValidator(String? inputCard) {
    print(inputCard);
    if(inputCard == null || !validator.creditCard(inputCard)) {return "Invalid credit or debit card number";}
    else {return null;}
  }

  final PageController pageController = PageController(initialPage: 0,);
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final usernameController = TextEditingController();
  final plateController = TextEditingController();
  // final payMethodController = TextEditingController();
  final cardController = TextEditingController();
  // final arAmountController = TextEditingController();
  // final arTriggerController = TextEditingController();

  bool isLoadingWhileSigningUp = false;
  bool readyToShowDialog = false;
  List<bool> payChoice = [false, false, false];
  String chosenVendor = '';
  String tempChoice = '';

  @override
  void dispose() {
    // Clean up the controllers when the widget is disposed.
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    usernameController.dispose();
    plateController.dispose();
    // payMethodController.dispose();
    // cardNumController.dispose();
    // arAmountController.dispose();
    // arTriggerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final dbInstance = Provider.of<FirebaseDatabase>(context);

    // Async functions that reads from database
    Future<void> isEmailRegistered(String inputEmail, String errorMessage, bool isTaken) async {
      isTaken = false;

      final DatabaseReference emailRef = dbInstance.ref('RegisteredEmails/');
      final dbSnapshot = await emailRef.get();

      final rawMap = dbSnapshot.value as Map<dynamic, dynamic>;
      rawMap.forEach((key, value) {
        if(inputEmail == (value as String)) {
          isTaken = true;
          errorMessage = "Email already registered";
        }
      });

      //setstate to actually update the passes variables;
      setState(() {
        emailTaken = isTaken;
        emailTakenMessage = errorMessage;
      });

    }
    Future<void> isPlateRegistered(String inputPlate, String errorMessage, bool isTaken) async {
      isTaken = false;
      final DatabaseReference emailRef = dbInstance.ref('RegisteredPlates/');
      final dbSnapshot = await emailRef.get();

      final rawMap = dbSnapshot.value as Map<dynamic, dynamic>;
      rawMap.forEach((key, value) {
        if(inputPlate == (value as String)) {
          isTaken = true;
          errorMessage = "Plate already registered";
        }
      });

      //setstate to actually update the passes variables;
      setState(() {
        plateTaken = isTaken;
        plateTakenMessage = errorMessage;
      });
    }

    void passwordMismatchCheck(String password, String confirmPassword, String errorMessage, bool isMismatched) {
      isMismatched = true;
      if (password == confirmPassword) {
        isMismatched = false;
        errorMessage = "Passwords do not match";
      }

      setState(() {
        isPasswordMismatch = isMismatched;
        isPasswordMismatchMessage = errorMessage;
      });
    }

    return Scaffold(
      backgroundColor: uiColorBackground,
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: uiColorTransparent,
        flexibleSpace: uiAppBarBlur,
        centerTitle: true,
        title: Text("Sign Up"),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Form(
                key: _signUpFormKey,
                child: PageView(
                  physics: NeverScrollableScrollPhysics(),
                  controller: pageController,
                  children: [
                    //EmailPassword
                    Column(
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
                                  child: Text("EMAIL"),
                                ),
                                Padding(
                                  padding: uiPaddingUSides,
                                  child: TextFormField(
                                    controller: emailController,
                                    validator: emailValidator,
                                    decoration: uiFieldDecoration,
                                  ),
                                ),
                                Padding(
                                  padding: uiPaddingAll,
                                  child: Text("PASSWORD"),
                                ),
                                Padding(
                                  padding: uiPaddingUSides,
                                  child: TextFormField(
                                    controller: passwordController,
                                    validator: passwordValidator,
                                    obscureText: true,
                                    decoration: uiFieldDecoration,),
                                ),
                                Padding(
                                  padding: uiPaddingAll,
                                  child: Text("CONFIRM PASSWORD"),
                                ),
                                Padding(
                                  padding: uiPaddingUSides,
                                  child: TextFormField(
                                    controller: confirmPasswordController,
                                    validator: confirmPasswordValidator,
                                    obscureText: true,
                                    decoration: uiFieldDecoration,),
                                ),

                                Padding(padding: uiPaddingTop),
                                Padding(
                                  padding: uiPaddingUSides,
                                  child: TextButton(
                                    onPressed: () async {
                                      await isEmailRegistered(emailController.text, emailTakenMessage, emailTaken);
                                      passwordMismatchCheck(passwordController.text, confirmPasswordController.text, isPasswordMismatchMessage, isPasswordMismatch);
                                      isValidAndProceed = _signUpFormKey.currentState!.validate();
                                      givenData['email'] = emailController.text;
                                      givenData['password'] = passwordController.text;
                                      if(isValidAndProceed) {pageController.nextPage(duration: Duration(milliseconds: 625), curve: Curves.easeOutCubic);}
                                    },
                                    child: Text("Create Account"),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    //Plate
                    Column(
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
                                  child: Text("USERNAME"),
                                ),
                                Padding(
                                  padding: uiPaddingUSides,
                                  child: TextFormField(
                                    controller: usernameController,
                                    // validator: usernameValidator,
                                    decoration: uiFieldDecoration,
                                  ),
                                ),
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
                                  child: TextFormField(
                                    controller: plateController,
                                    validator: plateValidator,
                                    decoration: uiFieldDecoration,
                                  ),
                                ),

                                Padding(padding: uiPaddingTop),
                                Padding(
                                  padding: uiPaddingUSides,
                                  child: TextButton(
                                    onPressed: () async {
                                      await isPlateRegistered(plateController.text.replaceAll(' ', '').toUpperCase(), plateTakenMessage, plateTaken);
                                      isValidAndProceed = _signUpFormKey.currentState!.validate();
                                      givenData['username'] = usernameController.text;
                                      givenData['plate'] = (plateController.text).replaceAll(' ', '').toUpperCase();
                                      if(isValidAndProceed) {pageController.nextPage(duration: Duration(milliseconds: 625), curve: Curves.easeOutCubic);}
                                    },
                                    child: Text("Register Username & Plate"),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    //Payment
                    SingleChildScrollView(
                      child: Column( // change to stack
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
                                    child: ListView(
                                      shrinkWrap: true,
                                      children: [
                                        ListTile(
                                          visualDensity: VisualDensity.compact,
                                          dense: true,
                                          leading: Icon(Icons.credit_card),
                                          title: Text('Card or Debit Card'),
                                          trailing: Icon(Icons.check_box_outlined, color: payChoice[0]? Colors.blue : Colors.transparent),
                                          onTap: () {
                                            showDialog(context: context, builder: (context) => CupertinoAlertDialog(
                                              title: Text('Credit or Debit'),
                                              content: Card(
                                                elevation: uiElevation,
                                                color: Colors.transparent,
                                                child: Form(
                                                  key: _popUpFormKey,
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                                    children: [
                                                      Padding(
                                                        padding: uiPaddingAll,
                                                        child: Text("CARD NUMBER"),
                                                      ),
                                                      Padding(
                                                        padding: uiPaddingUSides,
                                                        child: TextFormField(
                                                          controller: cardController,
                                                          validator: cardValidator,
                                                          keyboardType: TextInputType.number,
                                                          decoration: uiFieldDecoration,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              actions: [
                                                TextButton(child: Text('Cancel'), onPressed: () {Navigator.pop(context);},),
                                                TextButton(
                                                  child: Text('Confirm'),
                                                  onPressed: () {
                                                    bool canDismiss = _popUpFormKey.currentState!.validate();
                                                    if(canDismiss) {
                                                      givenData['cardNumber'] = cardController.text; givenData['paymentMethod'] = '100'; givenData['ARAllowed'] = true;
                                                      payChoice[0] = true; payChoice[1] = false; payChoice[2] = false;
                                                      setState(() { payChoice = [payChoice[0], payChoice[1],payChoice[2]];});
                                                      print(givenData);
                                                      Navigator.pop(context);
                                                    }
                                                  },
                                                ),
                                              ],
                                            ));
                                          },
                                        ),
                                        Divider(),
                                        ListTile(
                                          visualDensity: VisualDensity.compact,
                                          dense: true,
                                          leading: Icon(Icons.account_balance_wallet),
                                          title: Text('Third-party eWallet'),
                                          trailing: Icon(Icons.check_box_outlined, color: payChoice[1]? Colors.blue : Colors.transparent),
                                          onTap: () {
                                            chosenVendor = 'Choose an eWallet';
                                            showDialog(context: context, builder: (context) => CupertinoAlertDialog(
                                              title: Text('Select Vendor'),
                                              content: StatefulBuilder(
                                                builder: (context, SBsetState) {
                                                  return Card(
                                                    elevation: uiElevation,
                                                    color: Colors.transparent,
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                                      children: [
                                                        Padding(
                                                          padding: uiPaddingTop,
                                                          child: SizedBox(
                                                            height: 60,
                                                            width: double.infinity,
                                                            child: GridView.builder(
                                                              physics: ScrollPhysics(),
                                                              shrinkWrap: true,
                                                              padding: uiPaddingZero,
                                                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
                                                              itemCount: eWalletVendors.length,
                                                              itemBuilder: (BuildContext context, int index) {
                                                                return Column(
                                                                  children: [
                                                                    ClipRRect(
                                                                      borderRadius: uiClipRadiusForElements,
                                                                      child: InkWell(
                                                                        onTap: () {
                                                                          setState(() {
                                                                            tempChoice = eWalletVendors[index]['code']!;
                                                                            chosenVendor = eWalletVendors[index]['name']!;
                                                                          });
                                                                          SBsetState(() {
                                                                            tempChoice = eWalletVendors[index]['code']!;
                                                                            chosenVendor = eWalletVendors[index]['name']!;
                                                                          });
                                                                          print(chosenVendor);
                                                                        },
                                                                        child: SizedBox(
                                                                          width: 60,
                                                                          height: 60,
                                                                          child: Image.asset('assets/images/payment/logo_ewallet_${eWalletVendors[index]['image']}.png', fit: BoxFit.fill),
                                                                          // child: Image.asset('assets/images/payment/logo_bank_${bankingVendors[index]['image']}.png', fit: BoxFit.fill),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                );
                                                              },
                                                            ),
                                                          ),
                                                        ),
                                                        Padding(padding: uiPaddingTop),
                                                        Padding(
                                                          padding: uiPaddingHSides,
                                                          child: Text("$chosenVendor", textAlign: TextAlign.center,),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                },
                                              ),
                                              actions: [
                                                TextButton(child: Text('Cancel'), onPressed: () {Navigator.pop(context);},),
                                                TextButton(child: Text('Confirm'), onPressed: () {
                                                  if(chosenVendor != 'Choose an eWallet') {
                                                    payChoice[0] = false; payChoice[1] = true; payChoice[2] = false;
                                                    setState(() { givenData['ARAllowed'] = false; givenData['paymentMethod'] = tempChoice; payChoice = [payChoice[0], payChoice[1],payChoice[2]];});
                                                    print(givenData);
                                                    Navigator.pop(context);
                                                  }
                                                  },
                                                ),
                                              ],
                                            ));
                                          },
                                        ),
                                        Divider(),
                                        ListTile(
                                          visualDensity: VisualDensity.compact,
                                          dense: true,
                                          leading: Icon(Icons.account_balance),
                                          title: Text('Online Banking'),
                                          trailing: Icon(Icons.check_box_outlined, color: payChoice[2]? Colors.blue : Colors.transparent),
                                          onTap: () {
                                            chosenVendor = 'Choose a bank';
                                            showDialog(context: context, builder: (context) => CupertinoAlertDialog(
                                              title: Text('Select Vendor'),
                                              content: StatefulBuilder(
                                                builder: (context, SBsetState) {
                                                  return Card(
                                                    elevation: uiElevation,
                                                    color: Colors.transparent,
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                                      children: [
                                                        Padding(
                                                          padding: uiPaddingTop,
                                                          child: SizedBox(
                                                            height: 140,
                                                            width: double.infinity,
                                                            child: GridView.builder(
                                                              physics: ScrollPhysics(),
                                                              shrinkWrap: true,
                                                              padding: uiPaddingZero,
                                                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
                                                              itemCount: bankingVendors.length,
                                                              itemBuilder: (BuildContext context, int index) {
                                                                return Column(
                                                                  children: [
                                                                    ClipRRect(
                                                                      borderRadius: uiClipRadiusForElements,
                                                                      child: InkWell(
                                                                        onTap: () {
                                                                          setState(() {
                                                                            tempChoice = bankingVendors[index]['code']!;
                                                                            chosenVendor = bankingVendors[index]['name']!;
                                                                          });
                                                                          SBsetState(() {
                                                                            tempChoice = bankingVendors[index]['code']!;
                                                                            chosenVendor = bankingVendors[index]['name']!;
                                                                          });
                                                                          print(chosenVendor);
                                                                        },
                                                                        child: SizedBox(
                                                                          width: 60,
                                                                          height: 60,
                                                                          child: Image.asset('assets/images/payment/logo_bank_${bankingVendors[index]['image']}.png', fit: BoxFit.fill),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                );
                                                              },
                                                            ),
                                                          ),
                                                        ),
                                                        Padding(padding: uiPaddingTop),
                                                        Padding(padding: uiPaddingHSides, child: Text("$chosenVendor", textAlign: TextAlign.center,),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                },
                                              ),
                                              actions: [
                                                TextButton(child: Text('Cancel'), onPressed: () {Navigator.pop(context);},),
                                                TextButton(child: Text('Confirm'), onPressed: () {
                                                  if(chosenVendor != 'Choose a bank') {
                                                    payChoice[0] = false; payChoice[1] = false; payChoice[2] = true;
                                                    setState(() { givenData['ARAllowed'] = false; givenData['paymentMethod'] = tempChoice; payChoice = [payChoice[0], payChoice[1],payChoice[2]];});
                                                    print(givenData);
                                                    Navigator.pop(context);
                                                  }
                                                },
                                                ),
                                              ],
                                            ));
                                          },
                                        ),
                                      ],
                                    ),
                                  ),

                                  Padding(
                                    padding: uiPaddingAll,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("ENABLE AUTO RELOAD"),
                                        Switch(
                                          onChanged: (!payChoice[0])? null : (bool) {setState(() {givenData['ARAllowed'] = !givenData['ARAllowed'];});}, // set state must be written
                                          value: givenData['ARAllowed'],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: uiPaddingHSides,
                                    child: Text('Only for payment via credit or debit.',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontStyle: FontStyle.italic,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ),
                                  Padding(padding: uiPaddingTop),
                                  Padding(
                                    padding: uiPaddingUSides,
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            SizedBox(
                                              width: 150,
                                              child: badges.Badge(
                                                toAnimate: false,
                                                shape: badges.BadgeShape.square,
                                                badgeColor: givenData['ARAllowed'] ? Colors.blueGrey : Colors.grey,
                                                borderRadius: BorderRadius.circular(8),
                                                badgeContent: Center(child: Text(' Top up amount ', style: TextStyle(color: Colors.white))),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 33,
                                              child: TextButton(
                                                  onPressed: !givenData['ARAllowed']? null : () {
                                                    showDialog(
                                                      context: context,
                                                      builder: (BuildContext context) {
                                                        return CupertinoAlertDialog(
                                                          title: Text("Automatic reload amount:"),
                                                          content: StatefulBuilder(
                                                            builder: (context, SBsetState) {
                                                              return NumberPicker(haptics: true, minValue: 10, maxValue: 50, value: givenData['ARAmount'],
                                                                  onChanged: (value) {
                                                                    setState(() => givenData['ARAmount'] = value);
                                                                    SBsetState(() => givenData['ARAmount'] = value);
                                                                  });
                                                            },
                                                          ),
                                                        );
                                                      },
                                                    );
                                                  },
                                                  child: Text("RM ${givenData['ARAmount']}")),
                                            ),
                                          ],
                                        ),
                                        Divider(),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            SizedBox(
                                              width: 150,
                                              child: badges.Badge(
                                                toAnimate: false,
                                                shape: badges.BadgeShape.square,
                                                badgeColor: givenData['ARAllowed'] ? Colors.blueGrey : Colors.grey,
                                                borderRadius: BorderRadius.circular(8),
                                                badgeContent: Center(child: Text(' If wallet is below ', style: TextStyle(color: Colors.white))),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 33,
                                              child: TextButton(
                                                  onPressed: !givenData['ARAllowed']? null : () {
                                                    showDialog(
                                                      context: context,
                                                      builder: (BuildContext context) {
                                                        return CupertinoAlertDialog(
                                                          title: Text("Reload e-wallet when your balance is below: "),
                                                          content: StatefulBuilder(
                                                            builder: (context, SBsetState) {
                                                              return NumberPicker(haptics: true, minValue: 10, maxValue: 30, value: givenData['ARTrigger'],
                                                                  onChanged: (value) {
                                                                setState(() => givenData['ARTrigger'] = value);
                                                                SBsetState(() => givenData['ARTrigger'] = value);
                                                                  });
                                                            },
                                                          ),
                                                        );
                                                      },
                                                    );
                                                  },
                                                  child: Text("RM ${givenData['ARTrigger']}")),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),

                                  Padding(padding: uiPaddingTop),
                                  Padding(
                                    padding: uiPaddingUSides,
                                    child: TextButton(
                                      onPressed: () async {
                                        isValidAndProceed = _signUpFormKey.currentState!.validate();
                                        if(isValidAndProceed) {
                                          print(givenData);
                                          Navigator.push(context, MaterialPageRoute(builder: (context) => Ready(createAccountData: givenData),),);
                                        }
                                      },
                                      child: Text("Save Details"),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SmoothPageIndicator(controller: pageController, count: 3,
              effect: WormEffect(
                dotHeight: 10,
                dotWidth: 10,
                activeDotColor: Colors.black
              ),
            ),
          ],
        ),
      ),
    );
  }
}




// Add each child into list. The elements of the list is
List<Map<String,dynamic>> parkingHistories = [
  <String,dynamic>{ 'location' : 'KL Gateway' , 'entryTime' : 1655455337 , 'exitTime' : 1655461337 , 'duration' : 0 , 'fee' : 0 },
  <String,dynamic>{ 'location' : 'UM KK12' , 'entryTime' : 1655365337 , 'exitTime' : 1655365337 , 'duration' : 0 , 'fee' : 0 },
  <String,dynamic>{ 'location' : 'KL Gateway' , 'entryTime' : 1655275337 , 'exitTime' : 1655283337 , 'duration' : 0 , 'fee' : 0 },
  <String,dynamic>{ 'location' : 'Prototype Lot' , 'entryTime' : 1655185337 , 'exitTime' : 1655190337 , 'duration' : 0 , 'fee' : 0 },
  <String,dynamic>{ 'location' : 'UM KK12' , 'entryTime' : 1655095337 , 'exitTime' : 1655100337 , 'duration' : 0 , 'fee' : 0 },
];