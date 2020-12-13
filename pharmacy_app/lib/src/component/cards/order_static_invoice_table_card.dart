import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pharmacy_app/src/models/general/Enum_Data.dart';
import 'package:pharmacy_app/src/models/order/invoice_item.dart';
import 'package:pharmacy_app/src/models/order/order.dart';
import 'package:pharmacy_app/src/models/states/ui_state.dart';
import 'package:pharmacy_app/src/pages/confirm_invoice_page.dart';
import 'package:pharmacy_app/src/pages/order_details_page.dart';
import 'package:pharmacy_app/src/pages/order_final_invoice_page.dart';
import 'package:pharmacy_app/src/util/util.dart';

class OrderStaticInvoiceTableCard extends StatefulWidget {
  final Order order;

  OrderStaticInvoiceTableCard({this.order, Key key}) : super(key: key);

  @override
  _OrderStaticInvoiceTableCardState createState() =>
      _OrderStaticInvoiceTableCardState();
}

class _OrderStaticInvoiceTableCardState
    extends State<OrderStaticInvoiceTableCard> {
  bool isProcessing = false;
  double subTotal = 0;
  double deliveryFee = 20;
  double totalAmount = 0;

  final TextStyle textStyle = new TextStyle(fontSize: 12, color: Colors.black);

  @override
  void initState() {
    super.initState();
    calculatePricing();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) currentFocus.unfocus();
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
        width: double.infinity,
        child: Material(
          shadowColor: Colors.grey[100].withOpacity(0.4),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          elevation: 0,
          clipBehavior: Clip.antiAlias, // Add This
          child: buildBody(context),
        ),
      ),
    );
  }

  Widget buildBody(BuildContext context) {
    return buildInvoice();
  }

  Widget buildInvoice() {
    final children = List<TableRow>();
    final TextStyle columnTextStyle = new TextStyle(
        fontSize: 12, color: Util.purplishColor(), fontWeight: FontWeight.bold);

    final TextStyle dataTextStyle = new TextStyle(
        fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold);

    children.add(TableRow(children: [
      customTableCell(Text("Item", style: columnTextStyle),
          alignment: Alignment.centerLeft),
      customTableCell(Text("Unit Cost", style: columnTextStyle)),
      customTableCell(Text("Quantity", style: columnTextStyle)),
      customTableCell(Text("Amount", style: columnTextStyle),
          alignment: Alignment.centerRight),
    ]));

    widget.order.invoice.invoiceItemList.forEach((singleItem) {
      children.add(TableRow(children: [
        customTableCell(Text(singleItem.itemName, style: dataTextStyle),
            alignment: Alignment.centerLeft),
        customTableCell(Text(singleItem.itemUnitPrice, style: dataTextStyle)),
        customTableCell(Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Container(
              alignment: Alignment.center,
              width: 25,
              child: Text(singleItem.itemQuantity, style: dataTextStyle)),
        )),
        customTableCell(Text(getPrice(singleItem), style: textStyle),
            alignment: Alignment.centerRight),
      ]));
    });

    children.add(TableRow(children: [
      customTableCell(Divider(height: 2, thickness: 2)),
      customTableCell(Divider(height: 2, thickness: 2)),
      customTableCell(Divider(height: 2, thickness: 2)),
      customTableCell(Divider(height: 2, thickness: 2)),
    ]));

    children.add(TableRow(children: [
      customTableCell(Text("", style: columnTextStyle),
          alignment: Alignment.centerLeft),
      customTableCell(Text("", style: columnTextStyle)),
      customTableCell(Text("Subtotal", style: columnTextStyle)),
      customTableCell(Text(subTotal.toString(), style: columnTextStyle),
          alignment: Alignment.centerRight),
    ]));

    children.add(TableRow(children: [
      customTableCell(Text("", style: columnTextStyle),
          alignment: Alignment.centerLeft),
      customTableCell(Text("", style: columnTextStyle)),
      customTableCell(Text("Delivery Fee", style: columnTextStyle)),
      customTableCell(Text(deliveryFee.toString(), style: columnTextStyle),
          alignment: Alignment.centerRight),
    ]));

    children.add(TableRow(children: [
      customTableCell(Divider(height: 2, thickness: 2)),
      customTableCell(Divider(height: 2, thickness: 2)),
      customTableCell(Divider(height: 2, thickness: 2)),
      customTableCell(Divider(height: 2, thickness: 2)),
    ]));

    children.add(TableRow(children: [
      customTableCell(Text("", style: columnTextStyle),
          alignment: Alignment.centerLeft),
      customTableCell(Text("", style: columnTextStyle)),
      customTableCell(Text("Total",
          style: TextStyle(
              color: Util.purplishColor(),
              fontSize: 15,
              fontWeight: FontWeight.bold))),
      customTableCell(
          Text(totalAmount.toString(),
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.bold)),
          alignment: Alignment.centerRight),
    ]));

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
      child: Container(
        alignment: Alignment.center,
        width: double.infinity,
        padding: EdgeInsets.fromLTRB(5, 0, 10, 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          border: Border(
            left: BorderSide(color: Colors.grey, width: 0.7),
            top: BorderSide(color: Colors.grey, width: 0.7),
            right: BorderSide(color: Colors.grey, width: 0.7),
            bottom: BorderSide(color: Colors.grey, width: 0.7),
          ),
        ),
        child: Table(
          columnWidths: {
            0: FlexColumnWidth(0.3),
            1: FlexColumnWidth(0.2),
            2: FlexColumnWidth(0.3),
            3: FlexColumnWidth(0.2),
          },
          children: children,
        ),
      ),
    );
  }

  TableCell customTableCell(Widget singleWidget,
      {AlignmentGeometry alignment}) {
    return TableCell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 10),
          Container(
            alignment: alignment ?? Alignment.center,
            child: singleWidget,
          )
        ],
      ),
    );
  }

  String getPrice(InvoiceItem singleItem) {
    final unitPrice = double.parse(singleItem.itemUnitPrice);
    final quantity = double.parse(singleItem.itemQuantity);
    final price = (unitPrice * quantity).toString();
    return price;
  }

  void calculatePricing() {
    subTotal = 0;
    totalAmount = 0;
    for (final singleItem in widget.order.invoice.invoiceItemList) {
      final unitPrice = double.parse(singleItem.itemUnitPrice);
      final quantity = double.parse(singleItem.itemQuantity);
      subTotal = subTotal + (unitPrice * quantity);
    }

    totalAmount = subTotal + deliveryFee;
    if (mounted) setState(() {});
  }
}
