import 'package:pharmacy_app/src/models/general/Client_Enum.dart';

class FeedInfo {
  int userId = 0;
  String feedType = ClientEnum.FEED_PENDING;
  Function(dynamic value) feedFunc;

  FeedInfo(String feedType, {Function feedFunc}) {
    this.feedType = feedType;
    this.feedFunc = feedFunc;
  }
}
