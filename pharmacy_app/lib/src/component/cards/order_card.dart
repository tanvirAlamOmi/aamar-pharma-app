import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pharmacy_app/src/models/general/Enum_Data.dart';
import 'package:pharmacy_app/src/models/order/order.dart';
import 'package:pharmacy_app/src/models/states/ui_state.dart';

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
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(2.0)),
          elevation: 3,
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
        SizedBox(height: 20),
        Container(
            width: double.infinity,
            padding: EdgeInsets.only(left: 20),
            child: buildList()),
        SizedBox(height: 15),
      ],
    );
  }

  Widget buildTitle() {
    return Container(
      color: new Color.fromARGB(125, 4, 150, 150),
      padding: EdgeInsets.all(10),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.electric_car_rounded),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Order ID: " + order.id,
                style:
                TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
              Text(
                order.orderDate + ", " + order.orderTime,
                style: TextStyle(color: new Color.fromARGB(255, 4, 72, 71)),
              )
            ],
          ),
          Row(
            children: [
              Icon(
                Icons.av_timer,
                color: Colors.yellow,
              ),
              Text(
                order.collectionDateTime ?? "N/A",
                style: TextStyle(
                  color: Colors.yellow,
                ),
              ),
              Icon(Icons.chevron_right, size: 28.0),
            ],
          )
        ],
      ),
    );
  }

  Widget buildList() {
    final children = List<Widget>();

    children.add(Row(
      children: [
        Icon(Icons.location_on),
        SizedBox(width: 15),
        getAddress(),
      ],
    ));
    children.add(SizedBox(height: 5));

    children.add(Row(
      children: [
        Icon(Icons.monetization_on),
        SizedBox(width: 15),
        Text(
            "${double.parse(order.grandTotal).toStringAsFixed(2)} - ${order.paymentMethod}"),
      ],
    ));
    children.add(SizedBox(height: 5));

    return Column(
      children: children,
    );
  }

  Widget getAddress() {
    if (order.addressLine1 == null || order.addressLine1.isEmpty) {
      return Text("N/A");
    }
    return Text(order.addressLine1);
  }

  void refreshUI() {
    if (mounted) setState(() {});
  }
}
