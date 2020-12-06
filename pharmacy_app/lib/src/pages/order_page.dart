import 'package:flutter/material.dart';
import 'package:pharmacy_app/src/component/feed/feed_container.dart';
import 'package:pharmacy_app/src/models/feed/feed_info.dart';
import 'package:pharmacy_app/src/models/general/Enum_Data.dart';

class OrderPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
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
        title: Text("ORDERS"),

      ),
      body: FeedContainer(FeedInfo(
          ClientEnum.FEED_PENDING), key: key),
    );
  }
}
