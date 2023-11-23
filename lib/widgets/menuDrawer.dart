import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gonews/utils/utilFunctions.dart';
import 'package:gonews/utils/config/palette.dart' as palette;
import 'package:gonews/utils/config/decoration.dart' as decoration;
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
            leading: const Icon(Icons.account_box_outlined),
            title: Text(
              'Bookmarks',
              style: decoration.lightBlackHeading12TS,
            ),
            onTap: () {
              changeScreenFunc(context, "/BookmarkScreen");
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
              // //pop menu so inAppWebView bg will look correct
              // Navigator.pop(context);
              // // launches privacyPolicy url
              // UtilFunctions().launchUrlInWebView(
              //   Uri.parse(values.privacyPolicyUrl),
              // );
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
}
