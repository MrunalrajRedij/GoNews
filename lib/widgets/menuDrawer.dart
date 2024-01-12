import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gonews/utils/utilFunctions.dart';
import 'package:gonews/utils/config/palette.dart' as palette;
import 'package:gonews/utils/config/decoration.dart' as decoration;
import 'package:gonews/utils/config/values.dart' as values;
import 'package:gonews/widgets/policyDialog.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:share_plus/share_plus.dart';

//we can use below variable by declaring this file anywhere (We are sort of using this variables as a global thing)
//var are declared here so that parent widget can access them and pass data between screens
String userId = "";

//menu drawer for navigation between different screens
class MenuDrawer extends Drawer {
  const MenuDrawer({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Flexible(
            child: ListView(
              children: [
                SizedBox(
                  height: 170,
                  child: DrawerHeader(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: Divider.createBorderSide(
                          context,
                          width: 1.5.w,
                        ),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Image.asset('assets/images/logo.png'),
                    ),
                  ),
                ),

                //home screen btn
                ListTile(
                  horizontalTitleGap: 0,
                  leading: const Icon(Icons.home),
                  title: Text(
                    'Home',
                    style: decoration.lightBlackHeading12TS,
                  ),
                  onTap: () => changeScreenFunc(context, "/HomeScreen"),
                ),

                //job func
                ListTile(
                  horizontalTitleGap: 0,
                  leading: const Icon(Icons.book),
                  title: Text(
                    'Saved News',
                    style: decoration.lightBlackHeading12TS,
                  ),
                  onTap: () {
                    changeScreenFunc(context, "/SavedScreen");
                  },
                ),
                //privacy policy btn
                ListTile(
                  horizontalTitleGap: 0,
                  leading: const Icon(Icons.policy),
                  title: Text(
                    'Privacy Policy',
                    style: decoration.lightBlackHeading12TS,
                  ),
                  onTap: () async {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return PolicyDialog(mdFileName: 'privacy-policy.md');
                        });
                  },
                ),

                //refer a friend screen btn
                ListTile(
                  horizontalTitleGap: 0,
                  leading: const Icon(Icons.share),
                  title: Text(
                    'Refer A Friend',
                    style: decoration.lightBlackHeading12TS,
                  ),
                  onTap: () async {
                    Share.share('Check out this NEWS App:\n'
                        'https://play.google.com/store/apps/details?id=com.mobile.gonews');
                  },
                ),

                //logout btn
                ListTile(
                  horizontalTitleGap: 0,
                  leading: const Icon(Icons.logout),
                  title: Text(
                    'Logout',
                    style: decoration.lightBlackHeading12TS,
                  ),
                  onTap: () {
                    //signOut from the firebase and redirect to loginScreen
                    UtilFunctions().logOut(context);
                  },
                ),
              ],
            ),
          ),
          // ListTile(
          //   horizontalTitleGap: 0,
          //   title:
          //   onTap: () async {},
          SizedBox(
            width: 240,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: palette.primaryColor,
                  foregroundColor: palette.whiteColor,
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                    30,
                  ))),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return addCreditsAlertDialog(context);
                  },
                );
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/donateIcon.png',
                      scale: 20,
                      color: palette.whiteColor,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Want to Support?',
                      style: decoration.whiteBold16TS,
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 15),
        ],
      ),
    );
  }

  //Routing screen functionality
  void changeScreenFunc(context, routeName) {
    final currentRouteName =
        ModalRoute.of(context)?.settings.name; //get currentScreen

    //check if its on home-screen or not
    final bool isOnHomeScreen =
        currentRouteName == "/HomeScreen" || currentRouteName == "/";

    if (isOnHomeScreen && routeName == "/HomeScreen") {
      //onHomeScreen and trying to get to homeScreen
      Navigator.pop(context); //close the menu
    } else if (isOnHomeScreen && routeName != "/HomeScreen") {
      //onHomeScreen and trying to get to other screen
      Navigator.pushNamed(context, routeName!);
    } else if (currentRouteName == routeName) {
      //trying to get to similar screen
      Navigator.pop(context); //close the menu
    } else if (routeName == "/HomeScreen") {
      //trying to get to homeScreen
      Navigator.pushNamedAndRemoveUntil(
          context, routeName!, (Route<dynamic> route) => false);
    } else {
      //trying to get to other screen
      Navigator.pushReplacementNamed(context, routeName!);
    }
  }

  //alert dialog so user can credits
  AlertDialog addCreditsAlertDialog(context) {
    String toBeCreditedAmount = '10';
    TextEditingController creditAmountController = TextEditingController();

    Razorpay razorpay;
    String showSelectedCredits = values.initAmount;
    void _handlePaymentSuccess(PaymentSuccessResponse response) async {
      String secret = values.api_secret;
      String message = "${response.orderId}|${response.paymentId}";

      List<int> messageBytes = utf8.encode(message);
      List<int> key = utf8.encode(secret);
      Hmac hmac = Hmac(sha256, key);
      Digest digest = hmac.convert(messageBytes);

      if (digest.toString() == response.signature.toString()) {
        //show dialog as success
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Message"),
              content: const Text('Payment Successful!'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("OK"),
                )
              ],
            );
          },
        );
      }
    }

    void _handlePaymentError(PaymentFailureResponse response) {
      // Do something when payment fails
      UtilFunctions()
          .showScaffoldMsg(context, response.message ?? "Error: Try Again!");
    }

    //create razorPay instance
    razorpay = Razorpay();
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);

    void openCheckout(int amount) async {
      var options = {
        'key': values.api_key,
        'amount': amount,
        'description': "",
        'timeout': 300, // in seconds
        'prefill': {
          'contact': FirebaseAuth.instance.currentUser?.phoneNumber,
        }
      };
      try {
        razorpay.open(options);
      } catch (e) {
        print(e);
      }
    }

    return AlertDialog(
      actionsPadding: const EdgeInsets.symmetric(horizontal: 0),
      contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      content: SingleChildScrollView(
        child: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Select Amount in Rs. to Donate',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: palette.primaryColor),
                ),
                const SizedBox(height: 20),
                Container(
                  height: 50,
                  decoration: ShapeDecoration(
                    color: palette.scaffoldBgColor,
                    shape: RoundedRectangleBorder(
                        side: const BorderSide(
                            width: 1.0,
                            style: BorderStyle.solid,
                            color: Colors.grey),
                        borderRadius:
                            BorderRadius.circular(decoration.boxBorderRadius)),
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: DropdownButton<String>(
                      underline:
                          const SizedBox(), //for removing underline from drop down btn
                      isExpanded: true,
                      value: showSelectedCredits,
                      items: <String>[
                        '10',
                        '20',
                        '50',
                        '100',
                        '200',
                        '500',
                        '1000',
                        '2000'
                      ].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value.toString()),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          showSelectedCredits = value!;
                          creditAmountController.text = value;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: creditAmountController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    //for below version 2
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    // for version 2 and greater
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  decoration: InputDecoration(
                    fillColor: palette.scaffoldBgColor,
                    filled: true,
                    prefixIcon: const Icon(Icons.currency_rupee),
                    labelText: 'Add Custom Amount',
                    contentPadding: const EdgeInsets.only(top: 15),
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(decoration.boxBorderRadius),
                      borderSide: const BorderSide(
                        width: 1,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
      actions: [
        TextButton(
          child: const Text(
            "PROCEED TO DONATE",
            style: TextStyle(color: Colors.green),
          ),
          onPressed: () {
            if (creditAmountController.text.isNotEmpty) {
              toBeCreditedAmount = creditAmountController.text;
            }
            print(toBeCreditedAmount);
            openCheckout(int.parse(toBeCreditedAmount) * 100);
          },
        ),
        TextButton(
          child: const Text("Cancel"),
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
          },
        ),
      ],
    );
  }
}
