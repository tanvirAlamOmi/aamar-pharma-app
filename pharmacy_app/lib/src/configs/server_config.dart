import 'package:flutter/foundation.dart';

class ServerConfig {
  static String getEnvironment() {
    if (kReleaseMode) {
      // is Release Mode ??
      return "prod";
    }
    return "dev";
  }

  static final String environmentMode = getEnvironment();

  static final String SERVER_HOST = (getEnvironment() == "dev")
      ? 'http://pharmacy.arbreesolutions.com:'
      : 'http://pharmacy.arbreesolutions.com:';
  static final String SERVER_PORT = (getEnvironment() == "dev") ? "80" : "8989";

}
