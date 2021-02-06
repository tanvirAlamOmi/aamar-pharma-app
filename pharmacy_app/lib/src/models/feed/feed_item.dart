import 'package:pharmacy_app/src/models/notification.dart';
import 'package:pharmacy_app/src/models/order/order.dart';
import 'package:pharmacy_app/src/models/order/request_order.dart';

class FeedItem {
  String viewCardType;
  Order order;
  RequestOrder requestOrder;
  NotificationItem notificationItem;
  FeedItem({this.order,this.viewCardType,this.notificationItem});

  factory FeedItem.fromJson(Map<String, dynamic> json) {
    return FeedItem(
      order: json['order_data'],
      viewCardType: json['view_card_type'],
    );
  }
}
