import 'dart:convert';
import 'dart:io';
import 'package:pharmacy_app/src/configs/server_config.dart';
import 'package:pharmacy_app/src/models/general/Enum_Data.dart';
import 'package:pharmacy_app/src/models/states/app_vary_states.dart';
import 'package:pharmacy_app/src/models/user/user.dart';
import 'package:pharmacy_app/src/repo/auth_repo.dart';
import 'package:pharmacy_app/src/store/store.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart' as FirebaseAuthClass;
import 'package:tuple/tuple.dart';

class AuthClient {
  AuthClient() {
    print("AuthClient Initialized");
  }

  Future<dynamic> signIn(String signInRequest) async {
    final http.Response response = await http
        .post(
          ServerConfig.SERVER_HOST +
              ServerConfig.SERVER_PORT.toString() +
              '/api/adminapi/login',
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: signInRequest,
        )
        .timeout(Duration(seconds: 20));

    final jsonResponse = json.decode(response.body);
    return jsonResponse;
  }

  Future<void> sendSMSCode(String phoneNumber) async {
    /*
      You directly get logged in if Google Play Services verified the phone number
      instantly or helped you auto-retrieve the verification code.
     */
    await FirebaseAuthClass.FirebaseAuth.instance.verifyPhoneNumber(
      /* Fully qualified phone number with country code */
      phoneNumber: phoneNumber,

      /* Minimum value: 30 seconds */
      timeout: const Duration(seconds: 45),

      /* It will trigger when an SMS is auto-retrieved or the phone number has been instantly verified. */
      verificationCompleted:
          (FirebaseAuthClass.AuthCredential authCredential) async {
        try {
          final FirebaseAuthClass.User firebaseUser = (await FirebaseAuthClass
                  .FirebaseAuth.instance
                  .signInWithCredential(authCredential))
              .user;

          final authToken = await firebaseUser.getIdToken();

          Tuple2<User, String> userResponse = await AuthRepo.instance.signIn(
              authToken: authToken,
              phoneNumber: Store.instance.appState.user.phone);

          if (userResponse.item2 == ClientEnum.RESPONSE_SUCCESS &&
              userResponse.item1 != null) {
          } else {}
        } catch (error) {}
      },

      /* Optional callback. It will trigger when an SMS has been sent to the users phone */
      codeSent: (token, [force]) async {
        AppVariableStates.instance.firebaseSMSToken = token;
      },

      /* Optional callback. It will trigger when SMS auto-retrieval times out */
      codeAutoRetrievalTimeout: (id) {},

      /* Triggered when an error occurred during phone number verification */
      verificationFailed: (err) {},
    );
  }

  static AuthClient _instance;
  static AuthClient get instance => _instance ??= AuthClient();
}
