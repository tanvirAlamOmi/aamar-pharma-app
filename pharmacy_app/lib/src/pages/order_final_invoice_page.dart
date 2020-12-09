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
import 'package:pharmacy_app/src/models/general/Enum_Data.dart';
import 'package:pharmacy_app/src/component/buttons/general_action_button.dart';

class OrderFinalInvoicePage extends StatefulWidget {
  final Order order;

  OrderFinalInvoicePage({this.order, Key key}) : super(key: key);

  @override
  _OrderFinalInvoicePageState createState() => _OrderFinalInvoicePageState();
}

class _OrderFinalInvoicePageState extends State<OrderFinalInvoicePage> {
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
            buildReOrderButton(),
            buildPharmaAddress(),
            buildDivider(),
            buildOrderAddress(),
            buildDivider(),
            buildViewOrderDetailsButton(),
            SizedBox(height: 20),
            buildInvoice(),
            SizedBox(height: 20)
          ],
        ),
      ),
    );
  }

  Widget buildReOrderButton() {
    if (widget.order.orderStatus != ClientEnum.ORDER_STATUS_DELIVERED)
      return Container();
    return GeneralActionButton(
      title: "REORDER",
      isProcessing: isProcessing,
      callBack: () {},
    );
  }

  Widget buildPharmaAddress() {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 10, 22, 0),
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              "Amar Pharma",
              style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                  fontSize: 15),
            ),
          ),
          SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  "31 Street, Mirpur DOHS\n"
                  "Dhaka, Bangladesh",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                      fontSize: 11),
                ),
              ),
              Container(
                width: size.width / 2 - 50,
                alignment: Alignment.centerLeft,
                child: Text(
                  "+88012-35359552\n"
                  "arbree@amarpharma.com",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                      fontSize: 11),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget buildOrderAddress() {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 10, 22, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Invoice Number",
                  style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 13),
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  "0001",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                      fontSize: 12),
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Date Of Issue",
                  style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 13),
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  "20/02/15",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                      fontSize: 12),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Container(
            width: size.width / 2 - 50,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Client Infomation",
                    style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                        fontSize: 11),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    widget.order.deliveryAddressDetails.fullAddress,
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.normal,
                        fontSize: 11),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    widget.order.deliveryAddressDetails.areaName,
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.normal,
                        fontSize: 11),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    widget.order.userDetails.phoneNumber,
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.normal,
                        fontSize: 11),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget buildViewOrderDetailsButton() {
    if (widget.order.orderStatus != ClientEnum.ORDER_STATUS_DELIVERED)
      return Container();
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

  Widget buildInvoice() {
    final children = List<TableRow>();
    final TextStyle columnTextStyle = new TextStyle(
        fontSize: 12, color: Colors.black, fontWeight: FontWeight.bold);

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

  Widget buildDivider() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: Divider(height: 3, thickness: 2),
    );
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
