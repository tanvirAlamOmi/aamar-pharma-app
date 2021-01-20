import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pharmacy_app/src/models/general/Enum_Data.dart';
import 'package:pharmacy_app/src/models/general/Order_Enum.dart';
import 'package:pharmacy_app/src/models/order/order.dart';
import 'package:pharmacy_app/src/models/states/ui_state.dart';
import 'package:pharmacy_app/src/pages/confirm_invoice_page.dart';
import 'package:pharmacy_app/src/pages/order_details_page.dart';
import 'package:pharmacy_app/src/pages/order_final_invoice_page.dart';

class OrderCard extends StatefulWidget {
  final Order order;
  OrderCard({this.order, Key key}) : super(key: key);

  @override
  _OrderCardState createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  Order order;
  bool isProcessing = false;

  @override
  void initState() {
    super.initState();
    order = widget.order;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) currentFocus.unfocus();
      },
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
      children: [
        buildTitle(),
        buildOrderStatus(),
      ],
    );
  }

  Widget buildTitle() {
    return GestureDetector(
      onTap: navigateToSpecificPage,
      child: Container(
        height: 90,
        color: Colors.white,
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Order ID: " + order.id,
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold)),
                SizedBox(height: 5),
                Text("Today: 10 AM",
                    style: TextStyle(color: new Color.fromARGB(255, 4, 72, 71)))
              ],
            ),
            Row(
              children: [
                Icon(Icons.chevron_right, size: 28.0),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget buildOrderStatus() {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      width: double.infinity,
      height: 35,
      child: RaisedButton(
        shape: Border.all(width: 1.0, color: Colors.transparent),
        onPressed: () {},
        child: Text(
          order.status.toUpperCase(),
          style: TextStyle(color: Colors.white, fontSize: 12),
          textAlign: TextAlign.center,
        ),
        color: Colors.black,
      ),
    );
  }

  void navigateToSpecificPage() {
    if (order.status ==
        OrderEnum.ORDER_STATUS_PENDING_INVOICE_RESPONSE_FROM_PHARMA) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => OrderDetailsPage(
                  order: order,
                )),
      );
    }

    if (order.status ==
        OrderEnum.ORDER_STATUS_PENDING_INVOICE_RESPONSE_FROM_CUSTOMER) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ConfirmInvoicePage(
                  order: order,
                )),
      );
    }

    if (order.status ==
        OrderEnum.ORDER_STATUS_DELIVERED) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => OrderFinalInvoicePage(
                  order: order,
                )),
      );
    }
  }

  void refreshUI() {
    if (mounted) setState(() {});
  }
}
