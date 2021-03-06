import 'dart:convert';
import 'dart:io';
import 'package:pharmacy_app/src/bloc/stream.dart';
import 'package:pharmacy_app/src/configs/server_config.dart';
import 'package:pharmacy_app/src/models/general/Client_Enum.dart';
import 'package:pharmacy_app/src/models/states/app_vary_states.dart';
import 'package:pharmacy_app/src/models/states/event.dart';
import 'package:pharmacy_app/src/models/user/user.dart' as PharmaUser;
import 'package:pharmacy_app/src/repo/auth_repo.dart';
import 'package:pharmacy_app/src/store/store.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tuple/tuple.dart';

class AuthClient {
  FirebaseAuth auth = FirebaseAuth.instance;
  AuthClient() {
    print("AuthClient Initialized");
  }

  Future<dynamic> signIn(String signInRequest) async {
    final http.Response response = await http
        .post(
          ServerConfig.Address(path: '/api/appapi/login'),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: signInRequest,
        )
        .timeout(Duration(seconds: 20));

    final jsonResponse = json.decode(response.body);
    return jsonResponse;
  }

  // Bulk Third Party SMS
  Future<dynamic> sendPhoneNumberForSMS(
      String sendPhoneNumberForSMSRequest) async {
    final http.Response response = await http
        .post(
          ServerConfig.Address(path: '/api/appapi/login'),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: sendPhoneNumberForSMSRequest,
        )
        .timeout(Duration(seconds: 20));

    final jsonResponse = json.decode(response.body);
    return jsonResponse;
  }

  Future<dynamic> getUserDetails(String jwtToken, customerId) async {
    final http.Response response = await http.get(
      ServerConfig.Address(path: '/api/appapi/customer-details/${customerId}'),
      headers: {
        'token': jwtToken,
        'Content-Type': 'application/json; charset=UTF-8',
      },
    ).timeout(Duration(seconds: 20));

    final jsonResponse = json.decode(response.body);
    return jsonResponse;
  }

  // Firebase Auth SMS
  Future<void> sendSMSCode(String phoneNumber) async {
    await auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: const Duration(seconds: 120),
      verificationCompleted: (AuthCredential authCredential) => {},
      // This is auto verification code
      // verificationCompleted: (AuthCredential authCredential) async {
      //   try {
      //     final User firebaseUser =
      //         (await FirebaseAuth.instance.signInWithCredential(authCredential))
      //             .user;
      //
      //     final authToken = await firebaseUser.getIdToken();
      //
      //     Tuple2<PharmaUser.User, String> userResponse = await AuthRepo.instance
      //         .signIn(
      //             authToken: authToken,
      //             phoneNumber: Store.instance.appState.user.phone);
      //
      //     if (userResponse.item2 == ClientEnum.RESPONSE_SUCCESS &&
      //         userResponse.item1 != null) {
      //       Streamer.putEventStream(Event(EventType.REFRESH_VERIFICATION_PAGE));
      //     } else {
      //       Streamer.putErrorStream(
      //           'Auto Verification Failed. ' + userResponse.item2);
      //     }
      //   } catch (error) {
      //     Streamer.putErrorStream(error.toString());
      //   }
      // },
      codeSent: (token, [force]) async {
        AppVariableStates.instance.firebaseSMSToken = token;
      },
      codeAutoRetrievalTimeout: (id) {},
      verificationFailed: (FirebaseAuthException authException) {
        Streamer.putErrorStream(
            'Phone number verification failed. Code: ${authException.code}. Message: ${authException.message}');
      },
    );
  }

  Future<dynamic> updateProfile(String updateProfileRequest) async {
    final http.Response response = await http
        .post(
          ServerConfig.Address(path: '/api/appapi/profile-update'),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: updateProfileRequest,
        )
        .timeout(Duration(seconds: 20));

    final jsonResponse = json.decode(response.body);
    return jsonResponse;
  }

  Future<dynamic> updateDynamicReferralLink(
      String updateDynamicReferralLinkRequest) async {
    final http.Response response = await http
        .post(
          ServerConfig.Address(path: '/api/appapi/add_referral'),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: updateDynamicReferralLinkRequest,
        )
        .timeout(Duration(seconds: 20));

    final jsonResponse = json.decode(response.body);
    return jsonResponse;
  }

  static AuthClient _instance;
  static AuthClient get instance => _instance ??= AuthClient();
}
