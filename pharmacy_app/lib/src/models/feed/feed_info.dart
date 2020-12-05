import 'package:pharmacy_app/src/models/general/Enum_Data.dart';

class FeedInfo {
  int userId = 0;
  int branchId = 0;
  String feedType = ClientEnum.FEED_PENDING;

  FeedInfo(String feedType, int branchId) {
    this.feedType = feedType;
    this.branchId = branchId;
  }

  Map<String, dynamic> toJsonMap() {
    final data = Map<String, dynamic>();
    data['userId'] = userId.toString();
    data['branchId'] = branchId.toString();
    data['feedType'] = feedType.toString();
    return data;
  }
}
