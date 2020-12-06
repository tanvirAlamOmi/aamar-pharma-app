import 'dart:io';
import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pharmacy_app/src/component/cards/homepage_slider_single_card.dart';
import 'package:pharmacy_app/src/component/general/app_bar_back_button.dart';
import 'package:pharmacy_app/src/component/general/drawerUI.dart';
import 'package:pharmacy_app/src/util/util.dart';
import 'package:tuple/tuple.dart';
import 'package:pharmacy_app/src/component/cards/carousel_slider_card.dart';
import 'package:pharmacy_app/src/component/buttons/general_action_button.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pharmacy_app/src/pages/confirm_order_page.dart';
import 'package:pharmacy_app/src/models/order/order_manual_item.dart';

class AddItemsPage extends StatefulWidget {
  AddItemsPage({Key key}) : super(key: key);

  @override
  _AddItemsPageState createState() => _AddItemsPageState();
}

class _AddItemsPageState extends State<AddItemsPage> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final TextEditingController itemNameController = new TextEditingController();
  final TextEditingController itemUnitController = new TextEditingController();
  final TextEditingController itemQuantityController =
      new TextEditingController();
  final List<OrderManualItem> orderManualItemList = new List();

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
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          elevation: 1,
          centerTitle: true,
          leading: AppBarBackButton(),
          title: Text(
            'ADD ITEMS',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: buildBody(context));
  }

  Widget buildBody(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: <Widget>[
            buildAddItemBox(),
            buildItemList(),
            GeneralActionButton(
              title: "SUBMIT",
              height: 30,
              padding: const EdgeInsets.fromLTRB(27, 7, 27, 7),
              color: Colors.black,
              isProcessing: false,
              callBack: proceedToConfirmOrderPage,
            )
          ],
        ),
      ),
    );
  }

  Widget buildItemList() {
    final children = List<Widget>();

    orderManualItemList.forEach((singleItem) {
      children.add(Container(
        padding: const EdgeInsets.fromLTRB(27, 7, 27, 7),
        color: Colors.transparent,
        width: double.infinity,
        child: Material(
          shadowColor: Colors.grey[100].withOpacity(0.4),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
          elevation: 3,
          clipBehavior: Clip.antiAlias, // Add This
          child: ListTile(
            title: Text(singleItem.itemName,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
            subtitle: Text("QUANTITY: " + singleItem.itemQuantity),
            trailing: IconButton(
              icon: Icon(Icons.clear),
              onPressed: () {
                removeItemFromList(singleItem);
              },
            ),
          ),
        ),
      ));
    });

    return Column(children: children);
  }

  Widget buildAddItemBox() {
    return Container(
      padding: const EdgeInsets.fromLTRB(27, 7, 27, 7),
      color: Colors.transparent,
      width: double.infinity,
      child: Material(
        shadowColor: Colors.grey[100].withOpacity(0.4),
        shape: RoundedRectangleBorder(
            side: const BorderSide(color: Colors.transparent, width: 0.5),
            borderRadius: BorderRadius.circular(5.0)),
        elevation: 5,
        clipBehavior: Clip.antiAlias, // Add This
        child: Column(
          children: [
            SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.fromLTRB(15, 7, 15, 7),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("Item Name",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 3),
                  SizedBox(
                    height: 35, // set this
                    child: TextField(
                      controller: itemNameController,
                      decoration: new InputDecoration(
                        isDense: true,
                        hintText: "Napa, Astesin",
                        hintStyle: TextStyle(fontSize: 13),
                        fillColor: Colors.white,
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(15, 0, 10, 7),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text("Unit",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(height: 3),
                        SizedBox(
                          height: 35, // set this
                          child: TextField(
                            controller: itemUnitController,
                            decoration: new InputDecoration(
                              isDense: true,
                              hintText: "Notes e.g. I need all the medicines",
                              hintStyle: TextStyle(fontSize: 13),
                              fillColor: Colors.white,
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 0, vertical: 5),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(10, 0, 15, 7),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text("Quantity",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(height: 3),
                        SizedBox(
                          height: 35, // set this
                          child: TextField(
                            controller: itemQuantityController,
                            decoration: new InputDecoration(
                              isDense: true,
                              hintText: "Notes e.g. I need all the medicines",
                              hintStyle: TextStyle(fontSize: 13),
                              fillColor: Colors.white,
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 0, vertical: 5),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
            Container(
              alignment: Alignment.center,
              color: Colors.black,
              height: 40,
              child: GeneralActionButton(
                title: "ADD ITEM",
                height: 30,
                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                color: Colors.black,
                isProcessing: false,
                callBack: addItemsToList,
              ),
            )
          ],
        ),
      ),
    );
  }

  void addItemsToList() {
    if (itemNameController.text.isEmpty || itemQuantityController.text.isEmpty)
      return;
    orderManualItemList.add(OrderManualItem()
      ..itemName = itemNameController.text
      ..itemUnit = itemUnitController.text
      ..itemQuantity = itemQuantityController.text);

    itemNameController.clear();
    itemUnitController.clear();
    itemQuantityController.clear();

    if (mounted) setState(() {});
  }

  void removeItemFromList(OrderManualItem item) {
    orderManualItemList.remove(item);
    if (mounted) setState(() {});
  }

  void proceedToConfirmOrderPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ConfirmOrderPage(
            orderManualItemList: orderManualItemList,
          )),
    );
  }

  void refreshUI() {
    if (mounted) setState(() {});
  }
}
