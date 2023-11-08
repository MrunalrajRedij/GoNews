import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

//this class is used to implement common functionalities through out the app
//So less repeatable code is used
class UtilFunctions {
  //common func to show SnackBar msg
  void showScaffoldMsg(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
      ),
    );
  }

  //launch URL in external browser
  // void launchUrlInExternalBrowser(String url) async {
  //   if (await canLaunchUrl(Uri.parse(url))) {
  //     await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  //   }
  // }

  //launch URL in webView
  Future<void> launchUrlInWebView(Uri url) async {
    InAppBrowser().openUrlRequest(
      urlRequest: URLRequest(
        url: url,
      ),
      options: InAppBrowserClassOptions(
        inAppWebViewGroupOptions: InAppWebViewGroupOptions(
          android: AndroidInAppWebViewOptions(useWideViewPort: false),
          ios: IOSInAppWebViewOptions(enableViewportScale: true),
        ),
        android: AndroidInAppBrowserOptions(),
        ios: IOSInAppBrowserOptions(
            presentationStyle: IOSUIModalPresentationStyle.FULL_SCREEN),
        crossPlatform:
            InAppBrowserOptions(toolbarTopBackgroundColor: Colors.white),
      ),
    );
  }

  //logout func
  void logOut(context) {
    //redirect to loginScreen
    Navigator.pushNamedAndRemoveUntil(
        context, "/LoginScreen", (route) => false);
    FirebaseAuth.instance.signOut();
  }
}
