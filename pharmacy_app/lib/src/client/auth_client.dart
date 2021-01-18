import 'dart:convert';
import 'dart:io';
import 'package:pharmacy_app/src/configs/server_config.dart';
import 'package:pharmacy_app/src/models/general/Enum_Data.dart';
import 'package:pharmacy_app/src/models/states/app_vary_states.dart';
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
    await auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: const Duration(seconds: 45),
      verificationCompleted: (AuthCredential authCredential) async {
        try {
          final User firebaseUser =
              (await FirebaseAuth.instance.signInWithCredential(authCredential))
                  .user;

          final authToken = await firebaseUser.getIdToken();

          Tuple2<PharmaUser.User, String> userResponse = await AuthRepo.instance
              .signIn(
                  authToken: authToken,
                  phoneNumber: Store.instance.appState.user.phone);

          if (userResponse.item2 == ClientEnum.RESPONSE_SUCCESS &&
              userResponse.item1 != null) {
          } else {}
        } catch (error) {}
      },
      codeSent: (token, [force]) async {},
      codeAutoRetrievalTimeout: (id) {},
      verificationFailed: (err) {},
    );
  }

  static AuthClient _instance;
  static AuthClient get instance => _instance ??= AuthClient();
}
