import 'package:firebase_auth/firebase_auth.dart';
import 'package:pharmacy_app/src/bloc/stream.dart';
import 'package:pharmacy_app/src/client/auth_client.dart';
import 'package:pharmacy_app/src/models/general/Client_Enum.dart';
import 'package:pharmacy_app/src/models/states/app_vary_states.dart';
import 'package:pharmacy_app/src/models/states/event.dart';
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
        String signInRequest = jsonEncode(<String, dynamic>{
          // 'FIREBASE_AUTH_TOKEN': authToken,
          'verified_phone': phoneNumber,
          'fcm_token': Store.instance.appState.firebasePushNotificationToken,
          'referral_code': Store.instance.appState.referralCode,
        });

        final signInResponse =
            await AuthRepo.instance.getAuthClient().signIn(signInRequest);

        if (signInResponse['result'] == ClientEnum.RESPONSE_SUCCESS) {
          final user = PharmaUser.User.fromJson(signInResponse['user']);

          await Store.instance.updateUser(user);
          await Store.instance.setReferralCode('');
          AppVariableStates.instance.loginWithReferral = false;

          if (user.dynamicReferralLink == null ||
              user.dynamicReferralLink.isEmpty) {
            await AuthRepo.instance.updateDynamicReferralLink();
          }

          return Tuple2(
              Store.instance.appState.user, ClientEnum.RESPONSE_SUCCESS);
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

  // Firebase Phone Auth SMS
  Future<void> sendSMSCode(String phoneNumber) async {
    // No need to check for Server_Down. Because FireBase Server
    // Handles it, Not our server. Just check internet connection
    await AuthRepo.instance.getAuthClient().sendSMSCode(phoneNumber);
  }

  // Will be needed if Bulk SMS system introduced
  Future<void> sendPhoneNumberForSMS(String phoneNumber) async {
    int retry = 0;

    while (retry++ < 2) {
      try {
        String sendPhoneNumberForSMSRequest = jsonEncode(<String, dynamic>{
          'phone_number': phoneNumber,
        });

        final sendPhoneNumberForSMSResponse = await AuthRepo.instance
            .getAuthClient()
            .sendPhoneNumberForSMS(sendPhoneNumberForSMSRequest);

        if (sendPhoneNumberForSMSResponse['result'] ==
            ClientEnum.RESPONSE_SUCCESS) {
          return Tuple2(null, ClientEnum.RESPONSE_SUCCESS);
        } else {
          return Tuple2(
              null, sendPhoneNumberForSMSResponse['RESPONSE_MESSAGE']);
        }
      } catch (err) {
        print("Error in sendPhoneNumberForSMS() in AuthRepo");
        print(err);
      }
    }
    return Tuple2(null, ClientEnum.RESPONSE_CONNECTION_ERROR);
  }

  Future<void> getUserDetails() async {
    if (Store.instance.appState.user.id == null) return;

    int retry = 0;
    while (retry++ < 2) {
      try {
        String getUserDetailsSMSRequest = jsonEncode(<String, dynamic>{
          'customer_id': Store.instance.appState.user.id,
        });

        final getUserDetailsSMSResponse = await AuthRepo.instance
            .getAuthClient()
            .getUserDetails(getUserDetailsSMSRequest);

        if (getUserDetailsSMSResponse['result'] ==
            ClientEnum.RESPONSE_SUCCESS) {
          final user =
              PharmaUser.User.fromJson(getUserDetailsSMSResponse['user']);
          await Store.instance.updateUser(user);
          Streamer.putEventStream(Event(EventType.REFRESH_ALL_PAGES));
        }
      } catch (err) {
        print("Error in getUserDetails() in AuthRepo");
        print(err);
      }
    }
    return Tuple2(null, ClientEnum.RESPONSE_CONNECTION_ERROR);
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

  Future<Tuple2<void, String>> updateProfile(
      {String name, String email, String phone}) async {
    int retry = 0;

    while (retry++ < 2) {
      try {
        String updateProfileRequest = jsonEncode(
            <String, dynamic>{'name': name, 'email': email, 'phone': phone});

        final updateProfileResponse = await AuthRepo.instance
            .getAuthClient()
            .updateProfile(updateProfileRequest);

        if (updateProfileResponse['result'] == ClientEnum.RESPONSE_SUCCESS) {
          final PharmaUser.User user = Store.instance.appState.user;
          user.name = name;
          user.email = email;
          await Store.instance.updateUser(user);
          return Tuple2(user, ClientEnum.RESPONSE_SUCCESS);
        }
        if (updateProfileResponse['STATUS'] == false) {
          return Tuple2(null, updateProfileResponse['RESPONSE_MESSAGE']);
        }
      } catch (err) {
        print("Error in signIn() in AuthRepo");
        print(err);
      }
    }
    return Tuple2(null, ClientEnum.RESPONSE_CONNECTION_ERROR);
  }

  Future<Tuple2<void, void>> updateDynamicReferralLink() async {
    int retry = 0;

    while (retry++ < 2) {
      try {
        final String selfReferralCode = Util.getReferralCode();
        final String dynamicReferralLink = await DynamicLinksApi.instance
            .createDynamicReferralLink(referralCode: selfReferralCode);

        String updateDynamicReferralLinkRequest = jsonEncode(<String, dynamic>{
          'customer_id': Store.instance.appState.user.id,
          'self_referral_code': selfReferralCode,
          'dynamic_referral_link': dynamicReferralLink,
        });

        final updateDynamicReferralLinkResponse = await AuthRepo.instance
            .getAuthClient()
            .updateDynamicReferralLink(updateDynamicReferralLinkRequest);

        if (updateDynamicReferralLinkResponse['result'] ==
            ClientEnum.RESPONSE_SUCCESS) {
          final PharmaUser.User user = Store.instance.appState.user;
          user.dynamicReferralLink = dynamicReferralLink;
          await Store.instance.updateUser(user);
          return Tuple2(user, ClientEnum.RESPONSE_SUCCESS);
        }
        if (updateDynamicReferralLinkResponse['STATUS'] == false) {
          return Tuple2(
              null, updateDynamicReferralLinkResponse['RESPONSE_MESSAGE']);
        }
      } catch (err) {
        print("Error in updateDynamicReferralLink() in AuthRepo");
        print(err);
      }
    }
    return Tuple2(null, ClientEnum.RESPONSE_CONNECTION_ERROR);
  }

  Future<void> logout() async {
    await Store.instance.deleteAppData();
  }
}
