import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pharmacy_app/src/component/cards/homepage_slider_single_card.dart';
import 'package:pharmacy_app/src/component/general/app_bar_back_button.dart';
import 'package:pharmacy_app/src/component/general/drawerUI.dart';
import 'package:pharmacy_app/src/models/order/invoice_item.dart';
import 'package:pharmacy_app/src/models/order/order.dart';
import 'package:pharmacy_app/src/pages/order_details_page.dart';
import 'package:pharmacy_app/src/util/util.dart';
import 'package:tuple/tuple.dart';
import 'package:pharmacy_app/src/component/cards/carousel_slider_card.dart';
import 'package:pharmacy_app/src/component/buttons/general_action_button.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pharmacy_app/src/pages/upload_prescription_verify_page.dart';
import 'package:pharmacy_app/src/models/order/order_manual_item.dart';
import 'package:pharmacy_app/src/pages/add_new_address.dart';

class ConfirmInvoicePage extends StatefulWidget {
  final Order order;

  ConfirmInvoicePage({this.order, Key key}) : super(key: key);

  @override
  _ConfirmInvoicePageState createState() => _ConfirmInvoicePageState();
}

class _ConfirmInvoicePageState extends State<ConfirmInvoicePage> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
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
      child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            elevation: 1,
            centerTitle: true,
            leading: AppBarBackButton(),
            title: Text(
              'CONFIRM ORDER',
              style: TextStyle(color: Colors.white),
            ),
          ),
          body: buildBody(context)),
    );
  }

  Widget buildBody(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            buildViewOrderDetailsButton(),
            buildWarningTitle(),
            SizedBox(height: 20),
            buildInvoice(),
            SizedBox(height: 20)
          ],
        ),
      ),
    );
  }

  Widget buildViewOrderDetailsButton() {
    return Container(
      padding: const EdgeInsets.fromLTRB(27, 7, 27, 7),
      color: Colors.transparent,
      width: double.infinity,
      child: Material(
        shadowColor: Colors.grey[100].withOpacity(0.4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
        elevation: 3,
        clipBehavior: Clip.antiAlias, // Add This
        child: ListTile(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => OrderDetailsPage(
                        order: widget.order,
                      )),
            );
          },
          title: Text("View OrderDetails",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
          trailing: Icon(Icons.keyboard_arrow_right),
        ),
      ),
    );
  }

  Widget buildWarningTitle() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 10, 22, 0),
      child: Container(
        child: Text(
          "Before confirming order, please check invoice, edit quantity or remove items.",
          style: TextStyle(
              color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 12),
        ),
      ),
    );
  }

  Widget buildInvoice() {
    final children = List<TableRow>();
    final TextStyle columnTextStyle = new TextStyle(
        fontSize: 12, color: Colors.black, fontWeight: FontWeight.bold);

    final TextStyle dataTextStyle = new TextStyle(
        fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold);

    children.add(TableRow(children: [
      customTableCell(Text("", style: columnTextStyle)),
      customTableCell(Text("Item", style: columnTextStyle),
          alignment: Alignment.centerLeft),
      customTableCell(Text("Unit Cost", style: columnTextStyle)),
      customTableCell(Text("Quantity", style: columnTextStyle)),
      customTableCell(Text("Amount", style: columnTextStyle),
          alignment: Alignment.centerRight),
    ]));

    widget.order.invoice.invoiceItemList.forEach((singleItem) {
      children.add(TableRow(children: [
        customTableCell(
          GestureDetector(
            onTap: () => removeItem(singleItem),
            child: Container(
                width: 13,
                height: 13,
                child: Icon(Icons.clear, color: Colors.black, size: 8),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.blueAccent))),
          ),
        ),
        customTableCell(Text(singleItem.itemName, style: dataTextStyle),
            alignment: Alignment.centerLeft),
        customTableCell(Text(singleItem.itemUnitPrice, style: dataTextStyle)),
        customTableCell(Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: () => decrementItemQuantity(singleItem),
                child: Container(
                    width: 15,
                    height: 15,
                    child: Icon(Icons.remove, color: Colors.black, size: 10),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.blueAccent))),
              ),
              Container(
                  alignment: Alignment.center,
                  width: 25,
                  child: Text(singleItem.itemQuantity, style: dataTextStyle)),
              GestureDetector(
                onTap: () => incrementItemQuantity(singleItem),
                child: Container(
                    width: 15,
                    height: 15,
                    child: Icon(Icons.add, color: Colors.black, size: 10),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.blueAccent))),
              ),
            ],
          ),
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
      customTableCell(Divider(height: 2, thickness: 2)),
    ]));

    children.add(TableRow(children: [
      customTableCell(Text("", style: columnTextStyle)),
      customTableCell(Text("", style: columnTextStyle),
          alignment: Alignment.centerLeft),
      customTableCell(Text("", style: columnTextStyle)),
      customTableCell(Text("Subtotal", style: columnTextStyle)),
      customTableCell(Text(subTotal.toString(), style: columnTextStyle),
          alignment: Alignment.centerRight),
    ]));

    children.add(TableRow(children: [
      customTableCell(Text("", style: columnTextStyle)),
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
      customTableCell(Divider(height: 2, thickness: 2)),
    ]));

    children.add(TableRow(children: [
      customTableCell(Text("", style: columnTextStyle)),
      customTableCell(Text("", style: columnTextStyle),
          alignment: Alignment.centerLeft),
      customTableCell(Text("", style: columnTextStyle)),
      customTableCell(Text("Total", style: columnTextStyle)),
      customTableCell(Text(totalAmount.toString(), style: columnTextStyle),
          alignment: Alignment.centerRight),
    ]));

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
      child: Container(
        alignment: Alignment.center,
        width: double.infinity,
        padding: EdgeInsets.fromLTRB(5, 0, 10, 20),
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(color: Colors.grey, width: 1.0),
            top: BorderSide(color: Colors.grey, width: 1.0),
            right: BorderSide(color: Colors.grey, width: 1.0),
            bottom: BorderSide(color: Colors.grey, width: 1.0),
          ),
        ),
        child: Table(
          columnWidths: {
            0: FlexColumnWidth(0.1),
            1: FlexColumnWidth(0.29),
            2: FlexColumnWidth(0.2),
            3: FlexColumnWidth(0.3),
            4: FlexColumnWidth(0.2),
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

  void removeItem(dynamic invoiceItem) {
    widget.order.invoice.invoiceItemList.remove(invoiceItem);
    calculatePricing();
  }

  void incrementItemQuantity(InvoiceItem invoiceItem) {
    for (final singleItem in widget.order.invoice.invoiceItemList) {
      if (singleItem == invoiceItem) {
        singleItem.itemQuantity =
            (int.parse(singleItem.itemQuantity) + 1).toString();
        break;
      }
    }
    calculatePricing();
  }

  void decrementItemQuantity(InvoiceItem invoiceItem) {
    for (final singleItem in widget.order.invoice.invoiceItemList) {
      if (singleItem == invoiceItem) {
        singleItem.itemQuantity =
            (int.parse(singleItem.itemQuantity) - 1).toString();

        if (int.parse(singleItem.itemQuantity) == 0) {
          removeItem(invoiceItem);
        }
        break;
      }
    }
    calculatePricing();
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

  String getPrice(InvoiceItem singleItem) {
    final unitPrice = double.parse(singleItem.itemUnitPrice);
    final quantity = double.parse(singleItem.itemQuantity);
    final price = (unitPrice * quantity).toString();
    return price;
  }

  void refreshUI() {
    if (mounted) setState(() {});
  }
}

enum CHOICE_ENUM { DELIVERY_DAY, DELIVERY_TIME }
