import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:pharmacy_app/src/models/general/App_Enum.dart';
import 'package:pharmacy_app/src/models/states/app_vary_states.dart';
import 'package:pharmacy_app/src/store/store.dart';
import 'package:pharmacy_app/src/util/util.dart';

class DynamicLinksApi {
  final dynamicLink = FirebaseDynamicLinks.instance;

  static DynamicLinksApi _instance;
  static DynamicLinksApi get instance => _instance ??= DynamicLinksApi();

  Future<void> handleDynamicLink() async {
    // Install the app and get first dynamic link data.
    final PendingDynamicLinkData data = await dynamicLink.getInitialLink();
    handleSuccessLinking(data);

    dynamicLink.onLink(onSuccess: (PendingDynamicLinkData data) async {
      // If app is installed, this will work. No code to execute here currently
    }, onError: (OnLinkErrorException error) async {
      print(error.message.toString());
    });
  }

  void handleSuccessLinking(PendingDynamicLinkData data) async {
    print("Handling Dynamic Link");
    final Uri deepLink = data?.link;

    print("Dynamic Deep Link: " + deepLink.toString());

    if (deepLink != null) {
      bool isRefer = deepLink.toString().contains('refer_code');
      if (isRefer) {
        String code = deepLink.queryParameters['refer_code'];
        if (code != null) {
          await Future.delayed(Duration(seconds: 5));
          await Store.instance.setReferralCode(code);
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

  Future<String> createReferralLink() async {
    final DynamicLinkParameters dynamicLinkParameters = DynamicLinkParameters(
      uriPrefix: 'https://aamarpharma.page.link',
      link: Uri.parse(
          'https://arbreesolutions.com?refer_code=${Util.getReferralCode()}'),
      androidParameters: AndroidParameters(
        packageName: 'com.arbree.pharmacy_app',
      ),
      socialMetaTagParameters: SocialMetaTagParameters(
        title: 'Refer A Friend',
        description: 'Refer and earn',
        imageUrl: Uri.parse(
            'https://www.insperity.com/wp-content/uploads/Referral-_Program1200x600.png'),
      ),
    );

    final ShortDynamicLink shortLink =
        await dynamicLinkParameters.buildShortLink();

    final Uri dynamicUrl = shortLink.shortUrl;
    AppVariableStates.instance.dynamicLink = dynamicUrl.toString();
    return dynamicUrl.toString();
  }
}
