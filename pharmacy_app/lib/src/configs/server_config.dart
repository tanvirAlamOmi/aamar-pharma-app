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

  static Uri Address({String path}) {
    switch (getEnvironment()) {
      case 'dev':
        return Uri.http('137.184.156.117', path);
      case 'prod':
        return Uri.https('pharmacy.arbreesolutions.com', path);
    }
  }
}
