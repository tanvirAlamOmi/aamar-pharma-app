import 'package:flutter/material.dart';
import 'package:pharmacy_app/src/component/feed/feed_container.dart';
import 'package:pharmacy_app/src/component/general/common_ui.dart';
import 'package:pharmacy_app/src/component/general/drawerUI.dart';
import 'package:pharmacy_app/src/models/feed/feed_info.dart';
import 'package:pharmacy_app/src/models/general/App_Enum.dart';
import 'package:pharmacy_app/src/models/states/event.dart';
import 'package:pharmacy_app/src/models/states/ui_state.dart';
import 'package:pharmacy_app/src/bloc/stream.dart';

class NotificationPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  Key key = UniqueKey();
  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    UIState.instance.scaffoldKey = scaffoldKey;
  }

  void eventChecker() async {
    Streamer.getEventStream().listen((data) {
      if (data.eventType == EventType.REFRESH_NOTIFICATION_PAGE ||
          data.eventType == EventType.REFRESH_ALL_PAGES) {
        refreshUI();
      }
    });
  }

  void refreshUI() {
    if (mounted) {
      setState(() {
        key = UniqueKey();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        elevation: 1,
        centerTitle: true,
        title: CustomText('NOTIFICATIONS',
            color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500),
      ),
      body: FeedContainer(FeedInfo(AppEnum.FEED_NOTIFICATION), key: key),
    );
  }
}
