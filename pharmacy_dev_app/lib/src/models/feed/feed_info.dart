import 'package:pharmacy_app/src/models/general/Client_Enum.dart';

class FeedInfo {
  int userId = 0;
  String feedType = ClientEnum.FEED_PENDING;

  FeedInfo(String feedType) {
    this.feedType = feedType;
  }

  Map<String, dynamic> toJsonMap() {
    final data = Map<String, dynamic>();
    data['userId'] = userId.toString();
    data['feedType'] = feedType.toString();
    return data;
  }
}
