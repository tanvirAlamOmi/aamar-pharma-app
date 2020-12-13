import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pharmacy_app/src/component/buttons/circle_cross_button.dart';
import 'package:pharmacy_app/src/component/buttons/general_action_round_button.dart';
import 'package:pharmacy_app/src/component/cards/homepage_slider_single_card.dart';
import 'package:pharmacy_app/src/component/cards/order_invoice_table_card.dart';
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
            OrderInvoiceTableCard(
              subTotal: subTotal,
              deliveryFee: deliveryFee,
              totalAmount: totalAmount,
              order: widget.order,
              dynamicTable: true,
              callBackIncrementItemQuantity: incrementItemQuantity,
              callBackDecrementItemQuantity: decrementItemQuantity,
              callBackCalculatePricing: calculatePricing,
              callBackRemoveItem: removeItem,
              callBackRefreshUI: refreshUI,
            ),
            SizedBox(height: 20),
            buildCashWarningTitle(),
            SizedBox(height: 20),
            GeneralActionRoundButton(
              title: "CONFIRM ORDER",
              isProcessing: false,
            )
          ],
        ),
      ),
    );
  }

  Widget buildCashWarningTitle() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 10, 22, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            child: Text(
              "We only accept cash on delivery.",
              style: TextStyle(
                  color: Util.greenishColor(),
                  fontWeight: FontWeight.bold,
                  fontSize: 12),
            ),
          ),
          Container(
            child: Text(
              "Please keep cash ready upon delivery.",
              style: TextStyle(
                  color: Util.greenishColor(),
                  fontWeight: FontWeight.bold,
                  fontSize: 12),
            ),
          )
        ],
      ),
    );
  }

  Widget buildViewOrderDetailsButton() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 7, 20, 7),
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
          title: Text("View Order Details",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Util.greenishColor(),
                  fontSize: 14)),
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
              color: Colors.red, fontWeight: FontWeight.bold, fontSize: 12),
        ),
      ),
    );
  }

  void removeItem(dynamic singleItem) {
    widget.order.invoice.invoiceItemList.remove(singleItem);
  }

  void incrementItemQuantity(InvoiceItem invoiceItem) {
    for (final singleItem in widget.order.invoice.invoiceItemList) {
      if (singleItem == invoiceItem) {
        singleItem.itemQuantity =
            (int.parse(singleItem.itemQuantity) + 1).toString();
        break;
      }
    }
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

  void refreshUI() {
    if (mounted) setState(() {});
  }
}
