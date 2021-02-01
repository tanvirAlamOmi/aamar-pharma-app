import 'package:flutter/material.dart';
import 'package:pharmacy_app/src/component/feed/feed_container.dart';
import 'package:pharmacy_app/src/component/general/common_ui.dart';
import 'package:pharmacy_app/src/models/feed/feed_info.dart';
import 'package:pharmacy_app/src/models/general/Enum_Data.dart';
import 'package:pharmacy_app/src/models/general/Order_Enum.dart';
import 'package:pharmacy_app/src/util/util.dart';

class NotificationPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  Key key = UniqueKey();

  @override
  void initState() {
    super.initState();
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
      appBar: AppBar(
        elevation: 1,
        centerTitle: true,
        title: CustomText('Notifications',
            color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500),
      ),
      body: FeedContainer(FeedInfo(OrderEnum.FEED_NOTIFICATION), key: key),
    );
  }
}
