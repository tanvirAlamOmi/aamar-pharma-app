import 'package:pharmacy_app/src/client/auth_client.dart';
import 'package:pharmacy_app/src/models/general/Enum_Data.dart';
import 'package:pharmacy_app/src/models/user/user.dart';
import 'package:pharmacy_app/src/store/store.dart';
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

  Future<Tuple2<User, String>> logIn({String email, String password}) async {
    int retry = 0;

    while (retry++ < 2) {
      try {
        String logInRequest = jsonEncode(<String, dynamic>{
          'email': email,
          'password': password,
          'fcmToken': Store.instance.appState.firebasePushNotificationToken
        });

        print(logInRequest);

        final logInResponse =
            await AuthRepo.instance.getAuthClient().logIn(logInRequest);

        if (logInResponse['result'] == ClientEnum.RESPONSE_SUCCESS) {

          return Tuple2(null, ClientEnum.RESPONSE_SUCCESS);
        }
        if (logInResponse['result'] == ClientEnum.RESPONSE_FAIL) {
          return Tuple2(null, logInResponse['RESPONSE_MESSAGE']);
        }
      } catch (err) {
        print("Error in signIn() in AuthRepo");
        print(err);
      }
    }
    return Tuple2(null, ClientEnum.RESPONSE_CONNECTION_ERROR);
  }

  Future<void> logout() async {
    await Store.instance.deleteAppData();
  }
}
