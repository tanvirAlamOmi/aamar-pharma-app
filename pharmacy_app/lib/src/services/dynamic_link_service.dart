import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:pharmacy_app/src/util/util.dart';

class DynamicLinksApi {
  final dynamicLink = FirebaseDynamicLinks.instance;

  static DynamicLinksApi _instance;
  static DynamicLinksApi get instance => _instance ??= DynamicLinksApi();

  Future<void> handleDynamicLink() async {
    await dynamicLink.getInitialLink();
    dynamicLink.onLink(onSuccess: (PendingDynamicLinkData data) async {
      handleSuccessLinking(data);
    }, onError: (OnLinkErrorException error) async {
      print(error.message.toString());
    });
  }

  void handleSuccessLinking(PendingDynamicLinkData data) {
    final Uri deepLink = data?.link;

    if (deepLink != null) {
      var isRefer = deepLink.pathSegments.contains('refer');
      if (isRefer) {
        var code = deepLink.queryParameters['code'];
        print(code.toString());
        if (code != null) {}
      }
    }
  }

  Future<String> createReferralLink() async {
    final DynamicLinkParameters dynamicLinkParameters = DynamicLinkParameters(
      uriPrefix: 'https://devscore.page.link',
      link: Uri.parse('https://arbreesolutions.com?code=${Util.getReferralCode()}'),
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
    print(dynamicUrl);
    return dynamicUrl.toString();
  }
}
