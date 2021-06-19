import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pharmacy_app/src/bloc/stream.dart';
import 'package:pharmacy_app/src/models/general/Client_Enum.dart';
import 'package:pharmacy_app/src/models/notification.dart';
import 'package:pharmacy_app/src/models/states/event.dart';
import 'package:pharmacy_app/src/util/util.dart';
import 'package:pharmacy_app/src/pages/notification_to_order_page.dart';

class NotificationCard extends StatefulWidget {
  final NotificationItem notificationItem;
  NotificationCard({this.notificationItem, Key key}) : super(key: key);

  @override
  _NotificationCardState createState() => _NotificationCardState();
}

class _NotificationCardState extends State<NotificationCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Util.removeFocusNode(context),
      child: Container(
        padding: EdgeInsets.fromLTRB(25, 10, 25, 10),
        width: double.infinity,
        child: Material(
          shadowColor: Colors.grey[100].withOpacity(0.4),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          elevation: 5,
          clipBehavior: Clip.antiAlias, // Add This
          child: buildBody(context),
        ),
      ),
    );
  }

  Widget buildBody(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        buildTitle(context),
      ],
    );
  }

  Widget buildTitle(BuildContext context) {
    return GestureDetector(
      onTap: () {
        switch (widget.notificationItem.status) {
          case ClientEnum.NOTIFICATION_SEEN:
            Navigator.pop(context);
            Streamer.putEventStream(
                Event(EventType.SWITCH_TO_ORDER_NAVIGATION_PAGE));
            break;
          case ClientEnum.NOTIFICATION_UNSEEN:
            widget.notificationItem.status = ClientEnum.NOTIFICATION_SEEN;
            if (mounted) setState(() {});
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => NotificationToOrderPage(
                        notificationItem: widget.notificationItem,
                      )),
            );
        }
      },
      child: Container(
        height: 90,
        color: Colors.white,
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 30,
              child: Icon(
                Icons.shopping_bag,
                color: (widget.notificationItem.status ==
                        ClientEnum.NOTIFICATION_SEEN)
                    ? Colors.grey
                    : Util.greenishColor(),
                size: 28,
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      widget.notificationItem.orderStatus +
                          (' (Order #${widget.notificationItem.idOrder})'),
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: (widget.notificationItem.status ==
                                  ClientEnum.NOTIFICATION_SEEN)
                              ? Colors.grey[600]
                              : Colors.black,
                          fontWeight: FontWeight.bold)),
                  Text(widget.notificationItem.message ?? '',
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: (widget.notificationItem.status ==
                                  ClientEnum.NOTIFICATION_SEEN)
                              ? Colors.grey[600]
                              : Colors.black,
                          fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            (widget.notificationItem.status == ClientEnum.NOTIFICATION_SEEN)
                ? Container()
                : Container(
                    width: 30,
                    child: Icon(Icons.chevron_right, size: 28.0),
                  )
          ],
        ),
      ),
    );
  }
}
