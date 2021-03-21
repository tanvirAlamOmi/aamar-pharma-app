import 'package:pharmacy_app/src/client/query_client.dart';
import 'package:pharmacy_app/src/models/feed/feed_item.dart';
import 'package:pharmacy_app/src/models/feed/feed_request.dart';
import 'package:pharmacy_app/src/models/feed/feed_response.dart';
import 'package:pharmacy_app/src/models/general/Enum_Data.dart';
import 'package:pharmacy_app/src/models/general/Order_Enum.dart';
import 'package:pharmacy_app/src/models/notification.dart';
import 'package:pharmacy_app/src/models/order/deliver_address_details.dart';
import 'package:pharmacy_app/src/models/order/invoice_item.dart';
import 'package:pharmacy_app/src/models/order/order.dart';
import 'package:pharmacy_app/src/models/order/order_manual_item.dart';
import 'package:pharmacy_app/src/models/order/request_order.dart';
import 'package:pharmacy_app/src/repo/notification_repo.dart';
import 'package:pharmacy_app/src/store/store.dart';
import 'package:pharmacy_app/src/util/util.dart';
import 'package:tuple/tuple.dart';
import 'dart:convert';

import '../models/general/App_Enum.dart';
import '../models/general/Enum_Data.dart';

class QueryRepo {
  QueryClient _queryClient;

  QueryClient getQueryClient() {
    if (_queryClient == null) _queryClient = new QueryClient();
    return _queryClient;
  }

  static final QueryRepo _instance = QueryRepo();

  static QueryRepo get instance => _instance;

  Future<Tuple2<FeedResponse, String>> getOrderFeedData(
      FeedRequest feedRequest) async {
    int retry = 0;
    while (retry++ < 2) {
      try {
        final String jwtToken = Store.instance.appState.user.loginToken;
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
                ..viewCardType = OrderEnum.FEED_ITEM_ORDER_CARD)
              .toList()
          ..response = ClientEnum.RESPONSE_SUCCESS
          ..error = false;

        // Dummy Response Add
        // int x = 0;
        // final FeedResponse dummyOrderFeedResponse =
        //     await getDummyFeed(feedRequest);
        // dummyOrderFeedResponse.feedItems.forEach((singleFeedItem) {
        //   orderFeedResponse.feedItems.insert(x, singleFeedItem);
        //   x = x + 1;
        // });
        // return Tuple2(dummyOrderFeedResponse, ClientEnum.RESPONSE_SUCCESS);
        // End Dummy Response

        return Tuple2(orderFeedResponse, ClientEnum.RESPONSE_SUCCESS);
      } catch (err) {
        print("Error in getOrderFeedData() in QueryRepo");
        print(err);
      }
    }
    return Tuple2(null, ClientEnum.RESPONSE_CONNECTION_ERROR);
  }

  Future<Tuple2<FeedResponse, String>> getRepeatOrderFeedData(
      FeedRequest feedRequest) async {
    int retry = 0;
    while (retry++ < 2) {
      try {
        final String jwtToken = Store.instance.appState.user.loginToken;
        final int userId = Store.instance.appState.user.id;

        final feedResponse = await QueryRepo.instance
            .getQueryClient()
            .getRepeatOrderFeed(jwtToken, feedRequest, userId);

        final List<Order> allOrders = List<dynamic>.from(
                feedResponse.map((singleOrder) => Order.fromJson(singleOrder)))
            .cast<Order>();

        final orderFeedResponse = FeedResponse()
          ..status = true
          ..lastFeed = false
          ..feedItems = allOrders
              .map((singleOrder) => FeedItem()
                ..order = singleOrder
                ..viewCardType = OrderEnum.FEED_ITEM_REPEAT_ORDER_CARD)
              .toList()
          ..response = ClientEnum.RESPONSE_SUCCESS
          ..error = false;

        return Tuple2(orderFeedResponse, ClientEnum.RESPONSE_SUCCESS);
      } catch (err) {
        print("Error in getRepeatOrderFeedData() in QueryRepo");
        print(err);
      }
    }
    return Tuple2(null, ClientEnum.RESPONSE_CONNECTION_ERROR);
  }

  Future<Tuple2<FeedResponse, String>> getRequestOrderFeedData(
      FeedRequest feedRequest) async {
    int retry = 0;
    while (retry++ < 2) {
      try {
        final String jwtToken = Store.instance.appState.user.loginToken;
        final int userId = Store.instance.appState.user.id;

        final feedResponse = await QueryRepo.instance
            .getQueryClient()
            .getRequestOrderFeed(jwtToken, feedRequest, userId);

        final List<RequestOrder> allRequestOrders = List<dynamic>.from(
                feedResponse.map((singleRequestOrder) =>
                    RequestOrder.fromJson(singleRequestOrder)))
            .cast<RequestOrder>();

        final orderFeedResponse = FeedResponse()
          ..status = true
          ..lastFeed = false
          ..feedItems = allRequestOrders
              .map((singleRequestOrder) => FeedItem()
                ..requestOrder = singleRequestOrder
                ..viewCardType = OrderEnum.FEED_ITEM_REQUEST_ORDER_CARD)
              .toList()
          ..response = ClientEnum.RESPONSE_SUCCESS
          ..error = false;

        return Tuple2(orderFeedResponse, ClientEnum.RESPONSE_SUCCESS);
      } catch (err) {
        print("Error in getOrderFeedData() in QueryRepo");
        print(err);
      }
    }
    return Tuple2(null, ClientEnum.RESPONSE_CONNECTION_ERROR);
  }

  Future<Tuple2<FeedResponse, String>> getNotificationFeed(
      FeedRequest feedRequest) async {
    int retry = 0;
    while (retry++ < 2) {
      try {
        final String jwtToken = Store.instance.appState.user.loginToken;

        final String notificationRequest = jsonEncode(<String, dynamic>{
          'status': ClientEnum.NOTIFICATION_UNSEEN,
        });

        final feedResponse = await QueryRepo.instance
            .getQueryClient()
            .getNotificationsFeed(jwtToken, notificationRequest);

        print(feedResponse);

        final List<NotificationItem> allNotifications = List<dynamic>.from(
                feedResponse.map((singleNotification) =>
                    NotificationItem.fromJson(singleNotification)))
            .cast<NotificationItem>();

        final notificationFeedResponse = FeedResponse()
          ..status = true
          ..lastFeed = false
          ..feedItems = allNotifications
              .map((singleNotificationItem) => FeedItem()
                ..notificationItem = singleNotificationItem
                ..viewCardType = OrderEnum.FEED_ITEM_NOTIFICATION_CARD)
              .toList()
          ..response = ClientEnum.RESPONSE_SUCCESS
          ..error = false;

        notificationFeedResponse.feedItems.forEach((singleFeedItem) {
          NotificationRepo.instance.changeNotificationStatus(
              id: singleFeedItem.notificationItem.id,
              notificationStatus: ClientEnum.NOTIFICATION_SEEN);
        });

        // Dummy Response Add
        // int x = 0;
        // final FeedResponse dummyNotificationFeedResponse =
        //     await getDummyFeed(feedRequest);
        // dummyNotificationFeedResponse.feedItems.forEach((singleFeedItem) {
        //   notificationFeedResponse.feedItems.insert(x, singleFeedItem);
        //   x = x + 1;
        // });
        // return Tuple2(
        //     dummyNotificationFeedResponse, ClientEnum.RESPONSE_SUCCESS);
        // End Dummy Response

        return Tuple2(notificationFeedResponse, ClientEnum.RESPONSE_SUCCESS);
      } catch (err) {
        print("Error in getNotificationFeed() in QueryRepo");
        print(err);
      }
    }
    return Tuple2(null, ClientEnum.RESPONSE_CONNECTION_ERROR);
  }

  Future<Tuple2<FeedResponse, String>> getFeed(FeedRequest feedRequest) async {
    if (feedRequest.feedInfo.feedType == OrderEnum.FEED_NOTIFICATION)
      return getNotificationFeed(feedRequest);
    if (feedRequest.feedInfo.feedType == OrderEnum.FEED_ORDER)
      return getOrderFeedData(feedRequest);
    if (feedRequest.feedInfo.feedType == OrderEnum.FEED_REPEAT_ORDER)
      return getRepeatOrderFeedData(feedRequest);
    if (feedRequest.feedInfo.feedType == OrderEnum.FEED_REQUEST_ORDER)
      return getRequestOrderFeedData(feedRequest);

    return null;
  }

  Future<FeedResponse> getDummyFeed(FeedRequest feedRequest) async {
    switch (feedRequest.feedInfo.feedType) {
      case OrderEnum.FEED_NOTIFICATION:
        return FeedResponse(status: true, feedItems: [
          FeedItem(
              viewCardType: OrderEnum.FEED_ITEM_NOTIFICATION_CARD,
              notificationItem:
                  NotificationItem(message: "Your Order has been confirmed")),
          FeedItem(
              viewCardType: OrderEnum.FEED_ITEM_NOTIFICATION_CARD,
              notificationItem: NotificationItem(
                  message:
                      "Please wait some time. Aamar pharma is on the processing of your order. You will get it shortly")),
        ]);
        break;

      case OrderEnum.FEED_ORDER:
        return FeedResponse(status: true, feedItems: [
          FeedItem(
            viewCardType: OrderEnum.FEED_ITEM_ORDER_CARD,
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
              idAddress: 0,
              name: "ABC",
              mobileNo: "01528285415",
              email: "abc@gmail.com",
              deliveryDate: '2021-02-29',
              deliveryTime: '10:15 AM-12:08 PM',
              deliveryAddressDetails: DeliveryAddressDetails()
                ..area = 'Banani'
                ..id = 1
                ..address = '39/A Banani',
              deliveryCharge: '20.00',
              invoiceItemList: [
                InvoiceItem()
                  ..itemName = 'Napa'
                  ..itemQuantity = 12
                  ..itemUnitPrice = 2
              ],
            ),
          ),
          FeedItem(
            viewCardType: OrderEnum.FEED_ITEM_ORDER_CARD,
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
              idAddress: 0,
              name: "ABC",
              mobileNo: "01528285415",
              email: "abc@gmail.com",
              deliveryDate: '2021-02-29',
              deliveryTime: '10:15 AM-12:08 PM',
              deliveryAddressDetails: DeliveryAddressDetails()
                ..area = 'Gulshan'
                ..id = 1
                ..address = '39/A Gulshan',
              deliveryCharge: '150.00',
            ),
          ),
          FeedItem(
            viewCardType: OrderEnum.FEED_ITEM_ORDER_CARD,
            order: Order(
              id: 1024,
              items: [
                OrderManualItem(itemName: "ABC", unit: "mg", quantity: 10),
                OrderManualItem(itemName: "XYZ", unit: "g", quantity: 20)
              ],
              orderedWith: OrderEnum.ORDER_WITH_ITEM_NAME,
              status: OrderEnum.ORDER_STATUS_INVOICE_SENT,
              idAddress: 0,
              name: "ABC",
              mobileNo: "01528285415",
              email: "abc@gmail.com",
              deliveryDate: '2021-02-29',
              deliveryTime: '10:15 AM-12:08 PM',
              deliveryAddressDetails: DeliveryAddressDetails()
                ..area = 'Mirpur'
                ..id = 1
                ..address = '39/A Mirpur',
              deliveryCharge: '25.00',
              invoiceItemList: [
                InvoiceItem()
                  ..itemName = 'Napa'
                  ..itemQuantity = 12
                  ..itemUnitPrice = 2,
                InvoiceItem()
                  ..itemName = 'Dexpoten'
                  ..itemQuantity = 2
                  ..itemUnitPrice = 50
              ],
            ),
          )
        ]);
        break;
    }
  }
}
