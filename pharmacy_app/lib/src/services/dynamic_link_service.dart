import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pharmacy_app/src/models/general/App_Enum.dart';
import 'package:pharmacy_app/src/models/states/app_vary_states.dart';
import 'package:pharmacy_app/src/store/store.dart';
import 'package:pharmacy_app/src/util/util.dart';

class DynamicLinksApi {
  final dynamicLink = FirebaseDynamicLinks.instance;

  static DynamicLinksApi _instance;
  static DynamicLinksApi get instance => _instance ??= DynamicLinksApi();

  Future<void> handleReferralLink(
      {GlobalKey<ScaffoldState> scaffoldKey}) async {
    // Install the app and get first dynamic link data.
    final PendingDynamicLinkData data = await dynamicLink.getInitialLink();
    handleSuccessLinking(data, 'FROM_INIT', scaffoldKey);

    // If app is installed, this will work.
    dynamicLink.onLink(onSuccess: (PendingDynamicLinkData data) async {
      print('Dynamic Link Access Success');
      handleSuccessLinking(data, 'FROM_ONLINK', scaffoldKey);
    }, onError: (OnLinkErrorException error) async {
      print('Link Error');
      print(error.message.toString());
    });
  }

  void handleSuccessLinking(PendingDynamicLinkData data, String fromState,
      GlobalKey<ScaffoldState> scaffoldKey) async {
    print("Handling Dynamic Link Click ${fromState}");

    final Uri deepLink = data?.link;

    print("Dynamic Deep Link Referral Data: " + deepLink.toString());

    if (Store.instance.appState.user.id == null && deepLink != null) {
      bool isRefer = deepLink.toString().contains('refer_code');
      if (isRefer) {
        String code = deepLink.queryParameters['refer_code'];
        if (code != null) {
          await Store.instance.setReferralCode(code);
          await Future.delayed(Duration(seconds: 5));
          AppVariableStates.instance.loginWithReferral = true;
          AppVariableStates.instance.navigatorKey.currentState
              .pushNamedAndRemoveUntil(
            '/login',
            (Route<dynamic> route) => false,
          );
        }
      }
    }
  }

  Future<String> createDynamicReferralLink({String referralCode}) async {
    //if (Store.instance.appState.user.id != null) return null;

    final DynamicLinkParameters dynamicLinkParameters = DynamicLinkParameters(
      uriPrefix: 'https://aamarpharmarefer.page.link',
      link: Uri.parse('https://aamarpharma.com?refer_code=${referralCode}'),
      androidParameters: AndroidParameters(
          packageName: 'com.arbree.aamarpharma', minimumVersion: 4),
      socialMetaTagParameters: SocialMetaTagParameters(
        title: 'Refer Aamar Pharma to a friend',
        description: 'Refer and earn',
        imageUrl: Uri.parse(
            'https://www.insperity.com/wp-content/uploads/Referral-_Program1200x600.png'),
      ),
    );

    final ShortDynamicLink shortLink =
        await dynamicLinkParameters.buildShortLink();

    final Uri dynamicUrl = shortLink.shortUrl;
    print('Referral Link: ' + dynamicUrl.toString() + ' ' + referralCode);
    return dynamicUrl.toString();
  }
}
