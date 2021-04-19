import 'package:pharmacy_app/src/models/feed/feed_item.dart';

class FeedResponse {
  bool status;
  bool lastFeed;
  String response;
  int nextFromId;
  String session;
  String feedType;
  List<FeedItem> feedItems;
  bool error;

  FeedResponse(
      {this.status,
      this.lastFeed,
      this.nextFromId,
      this.session,
      this.feedType,
      this.response,
      this.feedItems,
      this.error});

  factory FeedResponse.fromJson(Map<String, dynamic> json) {
    return FeedResponse(
      status: json['status'],
      lastFeed: json['lastfeed'],
      nextFromId: json['nextFromId'],
      session: json['session'],
      feedType: json['feedType_Enum'],
      response: json['response'],
      error: json['error'],
      feedItems: (json['feedItems'] as List)
          .map((item) => FeedItem.fromJson(item))
          .toList(),
    );
  }
}
