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

  Future<Tuple2<User, String>> signIn(
      {String phoneNumber, String authToken}) async {
    int retry = 0;

    while (retry++ < 2) {
      try {
        String signInRequest = jsonEncode(<String, dynamic>{
          'AUTH_TOKEN': authToken,
          'PHONE_NUMBER': phoneNumber,
          'SIGNIN_TYPE': ClientEnum.SIGNIN_PHONE
        });

        final signInResponse =
            await AuthRepo.instance.getAuthClient().signIn(signInRequest);

        if (signInResponse['STATUS'] == true) {
          final user = User.fromJson(json.decode(signInResponse['USER']));

          await Store.instance.updateUser(user);

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

  Future<void> logout() async {
    await Store.instance.deleteAppData();
  }
}
