import 'dart:convert';
import 'dart:typed_data';
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

  final TextStyle textStyle = new TextStyle(fontSize: 12, color: Colors.black);

  @override
  void initState() {
    super.initState();
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
            SizedBox(height: 20),
            buildInvoice(),
            SizedBox(height: 20)
          ],
        ),
      ),
    );
  }

  TableCell customTableCell(Widget singleWidget) {
    return TableCell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 10),
          Center(
            child: singleWidget,
          )
        ],
      ),
    );
  }

  Widget buildInvoice() {
    final children = List<TableRow>();

    children.add(TableRow(children: [
      customTableCell(Text("Item", style: textStyle)),
      customTableCell(Text("Unit Cost", style: textStyle)),
      customTableCell(Text("Quantity", style: textStyle)),
      customTableCell(Text("Amount", style: textStyle)),
    ]));

    widget.order.invoice.invoiceItemList.forEach((singleItem) {
      children.add(TableRow(children: [
        customTableCell(Text(singleItem.itemName, style: textStyle)),
        customTableCell(Text(singleItem.itemUnitPrice, style: textStyle)),
        customTableCell(Padding(
          padding: const EdgeInsets.only(bottom:8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                child: Container(
                    width: 15,
                    height: 15,
                    child: Icon(Icons.remove, color: Colors.black, size: 10),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.blueAccent))),
              ),
              Text(singleItem.itemQuantity, style: textStyle),
              GestureDetector(
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
        customTableCell(Text(getPrice(singleItem), style: textStyle)),
      ]));
    });

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        alignment: Alignment.center,
        width: double.infinity,
        padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(color: Colors.black, width: 2.0),
            top: BorderSide(color: Colors.black, width: 2.0),
            right: BorderSide(color: Colors.black, width: 2.0),
            bottom: BorderSide(color: Colors.black, width: 2.0),
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

  String getPrice(InvoiceItem singleItem) {
    final unitPrice = double.parse(singleItem.itemUnitPrice);
    final quantity = double.parse(singleItem.itemQuantity);
    final price = (unitPrice * quantity).toString();
    return price;
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

  void refreshUI() {
    if (mounted) setState(() {});
  }
}

enum CHOICE_ENUM { DELIVERY_DAY, DELIVERY_TIME }
