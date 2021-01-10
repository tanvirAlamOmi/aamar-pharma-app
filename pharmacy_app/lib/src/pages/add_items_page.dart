import 'dart:io';
import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pharmacy_app/src/component/cards/homepage_slider_single_card.dart';
import 'package:pharmacy_app/src/component/general/app_bar_back_button.dart';
import 'package:pharmacy_app/src/component/general/custom_message_box.dart';
import 'package:pharmacy_app/src/component/general/drawerUI.dart';
import 'package:pharmacy_app/src/models/general/Enum_Data.dart';
import 'package:pharmacy_app/src/store/store.dart';
import 'package:pharmacy_app/src/util/util.dart';
import 'package:tuple/tuple.dart';
import 'package:pharmacy_app/src/component/cards/carousel_slider_card.dart';
import 'package:pharmacy_app/src/component/buttons/general_action_round_button.dart';
import 'package:pharmacy_app/src/component/buttons/general_action_button.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pharmacy_app/src/pages/confirm_order_page.dart';
import 'package:pharmacy_app/src/models/order/order_manual_item.dart';
import 'package:pharmacy_app/src/util/util.dart';
import 'package:pharmacy_app/src/component/buttons/circle_cross_button.dart';

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
    return GestureDetector(
      onTap: () => Util.removeFocusNode(context),
      child: Scaffold(
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
          body: buildBody(context)),
    );
  }

  Widget buildBody(BuildContext context) {
    return Container(
        child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: ListView(
            children: [
              Stack(
                children: [
                  Column(
                    children: <Widget>[
                      SizedBox(height: 10),
                      buildAddItemBox(),
                      SizedBox(height: 13),
                      buildTitle(),
                      SizedBox(height: 7),
                      buildItemList(),
                    ],
                  ),
                  buildTutorialBox()
                ],
              )
            ],
          ),
        ),
        buildSubmitButton()
      ],
    ));
  }

  Widget buildTutorialBox() {
    final size = MediaQuery.of(context).size;
    switch (Store.instance.appState.tutorialBoxNumberAddItemsPage) {
      case 0:
        return Positioned(
          top: 45,
          right: 30,
          child: CustomMessageBox(
            width: size.width - 200,
            height: 120,
            startPoint: 40,
            midPoint: 50,
            endPoint: 60,
            arrowDirection: ClientEnum.ARROW_BOTTOM,
            callBackAction: updateTutorialBox,
            callBackRefreshUI: refreshUI,
            messageTitle:
            "The items you add will be listed under this",
          ),
        );
        break;
      default:
        return Container();
        break;
    }
  }

  void updateTutorialBox() async {
    Store.instance.appState.tutorialBoxNumberAddItemsPage += 1;
    await Store.instance.putAppData();
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
        elevation: 7,
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
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Util.purplishColor())),
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
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Util.purplishColor())),
                        SizedBox(height: 3),
                        SizedBox(
                          height: 35, // set this
                          child: TextField(
                            controller: itemUnitController,
                            decoration: new InputDecoration(
                              isDense: true,
                              hintText: "e.g. mg,ml",
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
                            keyboardType: TextInputType.number,
                            controller: itemQuantityController,
                            decoration: new InputDecoration(
                              isDense: true,
                              hintText: "e.g. 10,15",
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
              color: Util.greenishColor(),
              height: 40,
              child: GeneralActionButton(
                title: "ADD ITEM",
                height: 40,
                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                color: Util.greenishColor(),
                isProcessing: false,
                callBack: addItemsToList,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildTitle() {
    if (orderManualItemList.length == 0) return Container();
    return Container(
      child: Text(
        "ADDED ITEMS",
        style:
            TextStyle(color: Util.greenishColor(), fontWeight: FontWeight.bold),
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
            trailing: buildRemoveItemButton(singleItem),
          ),
        ),
      ));
    });

    return Column(children: children);
  }

  Widget buildRemoveItemButton(OrderManualItem singleItem) {
    return Container(
      width: 80,
      alignment: Alignment.center,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleCrossButton(
            callBackDeleteItem: removeItemFromList,
            refreshUI: refreshUI,
            objectIdentifier: singleItem,
          ),
          SizedBox(height: 5),
          Text(
            "REMOVE",
            style: TextStyle(color: Colors.red, fontSize: 10),
          )
        ],
      ),
    );
  }

  Widget buildSubmitButton() {
    if (orderManualItemList.length == 0) return Container();
    return GeneralActionRoundButton(
      title: "SUBMIT",
      height: 40,
      isProcessing: false,
      callBackOnSubmit: proceedToConfirmOrderPage,
    );
  }

  void removeItemFromList(dynamic item) {
    orderManualItemList.remove(item);
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
