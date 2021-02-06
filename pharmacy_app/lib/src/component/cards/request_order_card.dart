import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pharmacy_app/src/models/notification.dart';
import 'package:pharmacy_app/src/models/order/request_order.dart';
import 'package:pharmacy_app/src/util/util.dart';

class RequestOrderCard extends StatelessWidget {
  final RequestOrder requestOrder;
  RequestOrderCard({this.requestOrder, Key key}) : super(key: key);

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
        buildTitle(),
      ],
    );
  }

  Widget buildTitle() {
    return GestureDetector(
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
                color: Util.greenishColor(),
                size: 28,
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(requestOrder.itemName,
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold)),
                  SizedBox(height: 5),
                  Text(requestOrder.quantity.toString(),
                      style:
                      TextStyle(color: new Color.fromARGB(255, 4, 72, 71)))
                ],
              ),
            ),
            Container(
              width: 30,
              child: Icon(Icons.chevron_right, size: 28.0),
            )
          ],
        ),
      ),
    );
  }
}
