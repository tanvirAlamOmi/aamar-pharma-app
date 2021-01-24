import 'package:pharmacy_app/src/client/query_client.dart';
import 'package:pharmacy_app/src/models/feed/feed_item.dart';
import 'package:pharmacy_app/src/models/feed/feed_request.dart';
import 'package:pharmacy_app/src/models/feed/feed_response.dart';
import 'package:pharmacy_app/src/models/general/Enum_Data.dart';
import 'package:pharmacy_app/src/models/general/Order_Enum.dart';
import 'package:pharmacy_app/src/models/notification.dart';
import 'package:pharmacy_app/src/models/order/deliver_address_details.dart';
import 'package:pharmacy_app/src/models/order/invoice.dart';
import 'package:pharmacy_app/src/models/order/invoice_item.dart';
import 'package:pharmacy_app/src/models/order/order.dart';
import 'package:pharmacy_app/src/models/order/order_manual_item.dart';
import 'package:pharmacy_app/src/models/user/user.dart';
import 'package:pharmacy_app/src/models/user/user_details.dart';
import 'package:pharmacy_app/src/store/store.dart';
import 'package:pharmacy_app/src/util/util.dart';
import 'package:tuple/tuple.dart';

class QueryRepo {
  QueryClient _queryClient;

  QueryClient getQueryClient() {
    if (_queryClient == null) _queryClient = new QueryClient();
    return _queryClient;
  }

  static final QueryRepo _instance = QueryRepo();

  static QueryRepo get instance => _instance;

  Future<Tuple2<FeedResponse, String>> getFeedData(
      FeedRequest feedRequest) async {
    int retry = 0;
    while (retry++ < 2) {
      try {
        final String jwtToken = Store.instance.appState.user.token;
        final int userId = Store.instance.appState.user.id;

        final feedResponse = await QueryRepo.instance
            .getQueryClient()
            .getOrderFeed(jwtToken, feedRequest, userId);

        final List<Order> allOrders = List<dynamic>.from(
                feedResponse.map((singleOrder) => Order.fromJson(singleOrder)))
            .cast<Order>();

        final orderFeedResponse = FeedResponse()
          ..status = true
          ..lastFeed = false
          ..feedItems = allOrders
              .map((singleOrder) => FeedItem()
                ..order = singleOrder
                ..viewCardType = ClientEnum.FEED_ITEM_ORDER_CARD)
              .toList()
          ..response = ClientEnum.RESPONSE_SUCCESS
          ..error = false;

        return Tuple2(orderFeedResponse, ClientEnum.RESPONSE_SUCCESS);
      } catch (err) {
        print("Error in getPendingFeed() in QueryRepo");
        print(err);
      }
    }
    return Tuple2(null, ClientEnum.RESPONSE_CONNECTION_ERROR);
  }

  Future<Tuple2<FeedResponse, String>> getOrderFeedData(
      FeedRequest feedRequest) async {
    int retry = 0;
    while (retry++ < 2) {
      try {
        final String jwtToken = Store.instance.appState.user.token;
        final int userId = Store.instance.appState.user.id;

        final feedResponse = await QueryRepo.instance
            .getQueryClient()
            .getOrderFeed(jwtToken, feedRequest, userId);

        final List<Order> allOrders = List<dynamic>.from(
                feedResponse.map((singleOrder) => Order.fromJson(singleOrder)))
            .cast<Order>();

        final orderFeedResponse = FeedResponse()
          ..status = true
          ..lastFeed = false
          ..feedItems = allOrders
              .map((singleOrder) => FeedItem()
                ..order = singleOrder
                ..viewCardType = ClientEnum.FEED_ITEM_ORDER_CARD)
              .toList()
          ..response = ClientEnum.RESPONSE_SUCCESS
          ..error = false;

        return Tuple2(orderFeedResponse, ClientEnum.RESPONSE_SUCCESS);
      } catch (err) {
        print("Error in getPendingFeed() in QueryRepo");
        print(err);
      }
    }
    return Tuple2(null, ClientEnum.RESPONSE_CONNECTION_ERROR);
  }


  Future<Tuple2<FeedResponse, String>> getFeed(FeedRequest feedRequest) async {
    if (feedRequest.feedInfo.feedType == ClientEnum.FEED_NOTIFICATION)
      return Tuple2(
          FeedResponse(status: true, feedItems: [
            FeedItem(
                viewCardType: ClientEnum.FEED_ITEM_NOTIFICATION_CARD,
                notificationItem: NotificationItem(
                    title: "Order Confirmation",
                    message: "Your Order has been confirmed")),
            FeedItem(
                viewCardType: ClientEnum.FEED_ITEM_NOTIFICATION_CARD,
                notificationItem: NotificationItem(
                    title: "Order Processing",
                    message:
                        "Please wait some time. Aamar pharma is on the processing of your order. You will get it shortly")),
          ]),
          ClientEnum.RESPONSE_SUCCESS);

    if (feedRequest.feedInfo.feedType == ClientEnum.FEED_ORDER)
      return getDummyFeed(feedRequest);
    if (feedRequest.feedInfo.feedType == ClientEnum.FEED_PENDING) {
      return getFeedData(feedRequest);
    } else if (feedRequest.feedInfo.feedType == ClientEnum.FEED_CONFIRM) {
      return getFeedData(feedRequest);
    } else if (feedRequest.feedInfo.feedType == ClientEnum.FEED_CANCELED) {
      return getFeedData(feedRequest);
    } else if (feedRequest.feedInfo.feedType == ClientEnum.FEED_RETURNED) {
      return getFeedData(feedRequest);
    } else if (feedRequest.feedInfo.feedType == ClientEnum.FEED_REJECTED) {
      return getFeedData(feedRequest);
    }

    return null;
  }



  Future<Tuple2<FeedResponse, String>> getDummyFeed(
      FeedRequest feedRequest) async {
    if (feedRequest.feedInfo.feedType == ClientEnum.FEED_NOTIFICATION)
      return Tuple2(
          FeedResponse(status: true, feedItems: [
            FeedItem(
                viewCardType: ClientEnum.FEED_ITEM_NOTIFICATION_CARD,
                notificationItem: NotificationItem(
                    title: "Order Confirmation",
                    message: "Your Order has been confirmed")),
            FeedItem(
                viewCardType: ClientEnum.FEED_ITEM_NOTIFICATION_CARD,
                notificationItem: NotificationItem(
                    title: "Order Processing",
                    message:
                    "Please wait some time. Aamar pharma is on the processing of your order. You will get it shortly")),
          ]),
          ClientEnum.RESPONSE_SUCCESS);

    if (feedRequest.feedInfo.feedType == ClientEnum.FEED_ORDER)
      return Tuple2(
          FeedResponse(status: true, feedItems: [
            FeedItem(
              viewCardType: ClientEnum.FEED_ITEM_ORDER_CARD,
              order: Order(
                  id: 1026,
                  prescription: Util.getStaticImageURL() +
                      "," +
                      Util.getStaticImageURL() +
                      "," +
                      Util.getStaticImageURL() +
                      "," +
                      Util.getStaticImageURL() +
                      ",",
                  orderedWith: OrderEnum.ORDER_WITH_PRESCRIPTION,
                  status: OrderEnum.ORDER_STATUS_DELIVERED,
                  idAddress:
                  Store.instance.appState?.allDeliveryAddress[0].id ?? "0",
                  name: "ABC",
                  mobileNo: "+8801528 285415",
                  email: "abc@gmail.com"),
            ),
            FeedItem(
              viewCardType: ClientEnum.FEED_ITEM_ORDER_CARD,
              order: Order(
                  id: 1023,
                  prescription: Util.getStaticImageURL() +
                      "," +
                      Util.getStaticImageURL() +
                      "," +
                      Util.getStaticImageURL() +
                      "," +
                      Util.getStaticImageURL() +
                      ",",
                  orderedWith: OrderEnum.ORDER_WITH_PRESCRIPTION,
                  status: OrderEnum.ORDER_STATUS_PENDING,
                  idAddress:
                  Store.instance.appState?.allDeliveryAddress[0].id ?? "0",
                  name: "ABC",
                  mobileNo: "+8801528 285415",
                  email: "abc@gmail.com"),
            ),
            FeedItem(
              viewCardType: ClientEnum.FEED_ITEM_ORDER_CARD,
              order: Order(
                  id: 1024,
                  items: [
                    OrderManualItem(itemName: "ABC", unit: "mg", quantity: 10),
                    OrderManualItem(itemName: "XYZ", unit: "g", quantity: 20)
                  ],
                  orderedWith: OrderEnum.ORDER_WITH_ITEM_NAME,
                  status: OrderEnum.ORDER_STATUS_INVOICE_SENT,
                  idAddress:
                  Store.instance.appState?.allDeliveryAddress[0].id ?? "0",
                  name: "ABC",
                  mobileNo: "+8801528 285415",
                  email: "abc@gmail.com"),
            )
          ]),
          ClientEnum.RESPONSE_SUCCESS);

    return null;
  }
}
