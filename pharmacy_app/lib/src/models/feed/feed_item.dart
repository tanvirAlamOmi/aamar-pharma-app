import 'package:pharmacy_app/src/models/order/order.dart';

class FeedItem {
  String viewCardType;
  Order order;
  FeedItem({this.order,this.viewCardType});

  factory FeedItem.fromJson(Map<String, dynamic> json) {
    return FeedItem(
      order: json['order_data'],
      viewCardType: json['view_card_type'],
    );
  }
}
