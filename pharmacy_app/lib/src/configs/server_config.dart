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
      ? 'https://pharmacy.arbreesolutions.com:'
      : 'https://pharmacy.arbreesolutions.com:';
  static final String SERVER_PORT = (getEnvironment() == "dev") ? "443" : "443";

}
