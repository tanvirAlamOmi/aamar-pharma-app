import 'package:flutter/foundation.dart';

class ServerConfig {
  static String getEnvironment() {
    if (kReleaseMode) {
      // is Release Mode ??
      return "prod";
    }
    return "prod";
  }

  static final String environmentMode = getEnvironment();


  static final String SERVER_HOST = (getEnvironment() == "dev")
      ? 'http://192.168.0.5'
      : 'https://pharmacy.arbreesolutions.com';
  static final int SERVER_PORT =
      (getEnvironment() == "dev") ? 8989 : 443;
}
