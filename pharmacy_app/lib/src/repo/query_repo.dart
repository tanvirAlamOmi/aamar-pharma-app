import 'package:pharmacy_app/src/client/query_client.dart';
import 'package:pharmacy_app/src/models/feed/feed_item.dart';
import 'package:pharmacy_app/src/models/feed/feed_request.dart';
import 'package:pharmacy_app/src/models/feed/feed_response.dart';
import 'package:pharmacy_app/src/models/general/Enum_Data.dart';
import 'package:pharmacy_app/src/models/order/order.dart';
import 'package:pharmacy_app/src/store/store.dart';
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
    return Tuple2(
        FeedResponse(status: true, feedItems: [
          FeedItem(
              viewCardType: ClientEnum.FEED_ITEM_ORDER_CARD,
              order: Order(
                  id: "1023",
                  orderStatus: ClientEnum
                      .ORDER_STATUS_PENDING_INVOICE_RESPONSE_FROM_PHARMA)),
          FeedItem(
              viewCardType: ClientEnum.FEED_ITEM_ORDER_CARD,
              order: Order(
                  id: "1024",
                  orderStatus: ClientEnum
                      .ORDER_STATUS_PENDING_INVOICE_RESPONSE_FROM_CUSTOMER))
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
