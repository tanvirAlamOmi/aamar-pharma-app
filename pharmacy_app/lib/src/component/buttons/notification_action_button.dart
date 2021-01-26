import 'package:flutter/material.dart';
import 'package:pharmacy_app/src/bloc/stream.dart';
import 'package:pharmacy_app/src/pages/notification_page.dart';
import 'package:pharmacy_app/src/util/util.dart';

class NotificationActionButton extends StatefulWidget {
  NotificationActionButton();
  @override
  State<StatefulWidget> createState() {
    return _NotificationActionButton();
  }
}

class _NotificationActionButton extends State<NotificationActionButton> {
  @override
  void initState() {
    super.initState();
    eventChecker();
  }

  void eventChecker() {}

  void refreshUI() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: buildIcon(2),
      onPressed: () => handleCartAction(context),
    );
  }

  Widget buildIcon(int count) {
    return Stack(
      fit: StackFit.expand,
      overflow: Overflow.visible,
      alignment: Alignment.center,
      children: <Widget>[
        Icon(
          Icons.notifications,
          color: Colors.white,
          size: 25,
        ),
        Positioned(
          top: -5.0,
          right: -5.0,
          child: (count <= 0) ? buildBadgeText(count) : Container(),
        ),
      ],
    );
  }

  Widget buildBadgeText(count) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50.0),
      ),
      margin: EdgeInsets.all(0.0),
      color: Colors.red[800],
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: 3.0,
          horizontal: count < 10 ? 6.0 : 3.0,
        ),
        child: Text(
          count < 100 ? '$count' : '99+',
          overflow: TextOverflow.fade,
          style: TextStyle(
            fontSize: 12.0,
            color: Colors.white,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }

  void handleCartAction(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NotificationPage()),
    );
  }
}
