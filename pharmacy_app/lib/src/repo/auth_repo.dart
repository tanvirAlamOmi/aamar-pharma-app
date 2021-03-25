import 'package:firebase_auth/firebase_auth.dart';
import 'package:pharmacy_app/src/client/auth_client.dart';
import 'package:pharmacy_app/src/models/general/Client_Enum.dart';
import 'package:pharmacy_app/src/models/states/app_vary_states.dart';
import 'package:pharmacy_app/src/models/user/user.dart' as PharmaUser;
import 'package:pharmacy_app/src/services/dynamic_link_service.dart';
import 'package:pharmacy_app/src/store/store.dart';
import 'package:pharmacy_app/src/util/util.dart';
import 'package:tuple/tuple.dart';
import 'dart:convert';

class AuthRepo {
  static final AuthRepo _instance = AuthRepo();
  AuthClient _authClient;

  AuthClient getAuthClient() {
    if (_authClient == null) _authClient = new AuthClient();
    return _authClient;
  }

  static AuthRepo get instance => _instance;

  Future<Tuple2<PharmaUser.User, String>> signIn(
      {String phoneNumber, String authToken}) async {
    int retry = 0;

    while (retry++ < 2) {
      try {
        final String self_referral_code = Util.getReferralCode();

        String signInRequest = jsonEncode(<String, dynamic>{
          // 'FIREBASE_AUTH_TOKEN': authToken,
          'verified_phone': phoneNumber,
          'fcm_token': Store.instance.appState.firebasePushNotificationToken,
          'referral_code': Store.instance.appState.referralCode,
          'self_referral_code': self_referral_code,
          'dynamic_referral_link': await DynamicLinksApi.instance
              .createDynamicReferralLink(referralCode: self_referral_code)
        });

        final signInResponse =
            await AuthRepo.instance.getAuthClient().signIn(signInRequest);

        if (signInResponse['result'] == ClientEnum.RESPONSE_SUCCESS) {
          final user = PharmaUser.User.fromJson(signInResponse['user']);

          await Store.instance.updateUser(user);
          await Store.instance.setReferralCode('');
          AppVariableStates.instance.loginWithReferral = false;

          return Tuple2(user, ClientEnum.RESPONSE_SUCCESS);
        }
        if (signInResponse['STATUS'] == false) {
          return Tuple2(null, signInResponse['RESPONSE_MESSAGE']);
        }
      } catch (err) {
        print("Error in signIn() in AuthRepo");
        print(err);
      }
    }
    return Tuple2(null, ClientEnum.RESPONSE_CONNECTION_ERROR);
  }

  Future<void> sendSMSCode(String phoneNumber) async {
    // No need to check for Server_Down. Because FireBase Server
    // Handles it, Not our server. Just check internet connection
    await AuthRepo.instance.getAuthClient().sendSMSCode(phoneNumber);
  }

  Future<Tuple2<PharmaUser.User, String>> signInWithPhoneNumber(
      {String smsCode, String firebaseToken, String phoneNumber}) async {
    int retry = 0;
    while (retry++ < 2) {
      try {
        final AuthCredential credential = PhoneAuthProvider.credential(
          verificationId: firebaseToken,
          smsCode: smsCode,
        );

        final User firebaseUser =
            (await FirebaseAuth.instance.signInWithCredential(credential)).user;

        final authToken = await firebaseUser.getIdToken();

        Tuple2<PharmaUser.User, String> userResponse = await AuthRepo.instance
            .signIn(authToken: authToken, phoneNumber: phoneNumber);

        return userResponse;
      } catch (err) {
        print("Error in signInWithPhoneNumber() in AuthRepo");
        print(err);
      }
    }
    return Tuple2(null, ClientEnum.RESPONSE_CONNECTION_ERROR);
  }

  Future<void> logout() async {
    await Store.instance.deleteAppData();
  }
}
