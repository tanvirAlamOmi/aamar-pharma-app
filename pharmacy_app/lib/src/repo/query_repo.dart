import 'package:pharmacy_app/src/client/query_client.dart';
import 'package:pharmacy_app/src/models/feed/feed_item.dart';
import 'package:pharmacy_app/src/models/feed/feed_request.dart';
import 'package:pharmacy_app/src/models/feed/feed_response.dart';
import 'package:pharmacy_app/src/models/general/Enum_Data.dart';
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
        String jwtToken = Store.instance.appState.user.token;

        final feedResponse = await QueryRepo.instance
            .getQueryClient()
            .getFeed(jwtToken, feedRequest);

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

    // Sending Empty List
    // if (feedRequest.feedInfo.feedType == ClientEnum.FEED_ORDER) {
    //   return Tuple2(FeedResponse(status: true, feedItems: []),
    //       ClientEnum.RESPONSE_SUCCESS);
    // }
    if (feedRequest.feedInfo.feedType == ClientEnum.FEED_ORDER)
      return Tuple2(
          FeedResponse(status: true, feedItems: [
            FeedItem(
              viewCardType: ClientEnum.FEED_ITEM_ORDER_CARD,
              order: Order(
                  id: "1026",
                  imageList: [
                    Util.getStaticImageURL(),
                    Util.getStaticImageURL(),
                    Util.getStaticImageURL(),
                    Util.getStaticImageURL()
                  ],
                  invoice: Invoice(invoiceItemList: [
                    InvoiceItem()
                      ..itemName = "Napa"
                      ..itemQuantity = "10"
                      ..itemUnitPrice = "2",
                    InvoiceItem()
                      ..itemName = "Histasin"
                      ..itemQuantity = "3"
                      ..itemUnitPrice = "5",
                    InvoiceItem()
                      ..itemName = "Seclo 40"
                      ..itemQuantity = "5"
                      ..itemUnitPrice = "25",
                  ]),
                  orderType: ClientEnum.ORDER_TYPE_LIST_IMAGES,
                  orderStatus: ClientEnum.ORDER_STATUS_DELIVERED,
                  deliveryAddressDetails: DeliveryAddressDetails(
                      addressType: "HOME",
                      areaName: "MIRPUR",
                      fullAddress: "47/A Kashi Building"),
                  user: User(
                      name: "ABC",
                      phone: "+8801528 285415",
                      email: "abc@gmail.com")),
            ),
            FeedItem(
              viewCardType: ClientEnum.FEED_ITEM_ORDER_CARD,
              order: Order(
                  id: "1023",
                  imageList: [
                    Util.getStaticImageURL(),
                    Util.getStaticImageURL(),
                    Util.getStaticImageURL(),
                    Util.getStaticImageURL()
                  ],
                  orderType: ClientEnum.ORDER_TYPE_LIST_IMAGES,
                  orderStatus: ClientEnum
                      .ORDER_STATUS_PENDING_INVOICE_RESPONSE_FROM_PHARMA,
                  deliveryAddressDetails: DeliveryAddressDetails(
                      addressType: "HOME",
                      areaName: "MIRPUR",
                      fullAddress: "47/A Kashi Building"),
                  user: User(
                      name: "ABC",
                      phone: "+8801528 285415",
                      email: "abc@gmail.com")),
            ),
            FeedItem(
                viewCardType: ClientEnum.FEED_ITEM_ORDER_CARD,
                order: Order(
                    id: "1024",
                    itemList: [
                      OrderManualItem(
                          itemName: "ABC", itemUnit: "mg", itemQuantity: "10"),
                      OrderManualItem(
                          itemName: "XYZ", itemUnit: "g", itemQuantity: "20")
                    ],
                    invoice: Invoice(invoiceItemList: [
                      InvoiceItem()
                        ..itemName = "Napa"
                        ..itemQuantity = "10"
                        ..itemUnitPrice = "2",
                      InvoiceItem()
                        ..itemName = "Histasin"
                        ..itemQuantity = "3"
                        ..itemUnitPrice = "5",
                      InvoiceItem()
                        ..itemName = "Seclo 40"
                        ..itemQuantity = "5"
                        ..itemUnitPrice = "25",
                    ]),
                    orderType: ClientEnum.ORDER_TYPE_LIST_ITEMS,
                    orderStatus: ClientEnum
                        .ORDER_STATUS_PENDING_INVOICE_RESPONSE_FROM_CUSTOMER,
                    deliveryAddressDetails: DeliveryAddressDetails(
                        addressType: "OFFICE",
                        areaName: "MIRPUR",
                        fullAddress: "48/A Kashi Building"),
                    user: User(
                        name: "XYZ",
                        phone: "+88013 4541228 ",
                        email: "xyhz@gmail.com")))
          ]),
          ClientEnum.RESPONSE_SUCCESS);
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
}
