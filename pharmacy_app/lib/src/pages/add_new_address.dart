import 'dart:io';
import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pharmacy_app/src/component/buttons/general_action_round_button.dart';
import 'package:pharmacy_app/src/component/cards/homepage_slider_single_card.dart';
import 'package:pharmacy_app/src/component/general/app_bar_back_button.dart';
import 'package:pharmacy_app/src/component/general/drawerUI.dart';
import 'package:pharmacy_app/src/models/order/deliver_address_details.dart';
import 'package:pharmacy_app/src/store/store.dart';
import 'package:pharmacy_app/src/util/util.dart';
import 'package:tuple/tuple.dart';
import 'package:pharmacy_app/src/component/cards/carousel_slider_card.dart';
import 'package:pharmacy_app/src/component/buttons/general_action_button.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pharmacy_app/src/pages/confirm_order_page.dart';
import 'package:pharmacy_app/src/models/order/order_manual_item.dart';
import 'package:pharmacy_app/src/pages/order_page.dart';

class AddNewAddressPage extends StatefulWidget {
  final Function() callBack;
  AddNewAddressPage({this.callBack, Key key}) : super(key: key);

  @override
  _AddNewAddressPageState createState() => _AddNewAddressPageState();
}

class _AddNewAddressPageState extends State<AddNewAddressPage> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final TextEditingController addressTypeController =
      new TextEditingController();
  final TextEditingController fullAddressController =
      new TextEditingController();

  List<String> areaList = ["Mirupur", "Banani", "Gulshan"];
  String selectedArea;

  @override
  void initState() {
    super.initState();
    selectedArea = areaList[0];
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
            'ADD ADDRESS',
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
            buildAddressTypeTextField(),
            buildAreaSelectionDropDown(),
            buildFullAddressTextField(),
            GeneralActionRoundButton(
              title: "SUBMIT",
              height: 40,
              padding: const EdgeInsets.fromLTRB(27, 7, 27, 7),
              isProcessing: false,
              callBackOnSubmit: submitData,
            )
          ],
        ),
      ),
    );
  }

  Widget buildAddressTypeTextField() {
    return Container(
      padding: const EdgeInsets.fromLTRB(27, 7, 27, 7),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text("Address Type",
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: Util.purplishColor())),
          SizedBox(height: 3),
          SizedBox(
            height: 35, // set this
            child: TextField(
              controller: addressTypeController,
              decoration: new InputDecoration(
                isDense: true,
                hintText: "Home",
                hintStyle: TextStyle(fontSize: 13),
                fillColor: Colors.white,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 0, vertical: 5),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildFullAddressTextField() {
    return Container(
      padding: const EdgeInsets.fromLTRB(27, 7, 27, 7),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text("Address",
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: Util.purplishColor())),
          SizedBox(height: 3),
          SizedBox(
            height: 35, // set this
            child: TextField(
              controller: fullAddressController,
              decoration: new InputDecoration(
                isDense: true,
                hintText: "39/A Housing Estate...",
                hintStyle: TextStyle(fontSize: 13),
                fillColor: Colors.white,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 0, vertical: 5),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildAreaSelectionDropDown() {
    return Container(
      padding: const EdgeInsets.fromLTRB(27, 7, 27, 7),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text("Select Area",
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: Util.purplishColor())),
          SizedBox(height: 1),
          Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(width: 1, color: Colors.black),
              ),
              color: Colors.transparent,
            ),
            height: 35,
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                dropdownColor: const Color.fromARGB(255, 45, 65, 89),
                isDense: true,
                isExpanded: true,
                value: selectedArea,
                onChanged: (value) {
                  if (value == null) return;
                  selectedArea = value;
                  if (mounted) setState(() {});
                },
                items: areaList.map((item) {
                  return buildDropDownMenuItem(item);
                }).toList(),
              ),
            ),
          )
        ],
      ),
    );
  }

  DropdownMenuItem<String> buildDropDownMenuItem(String menuItem) {
    return DropdownMenuItem(
      value: menuItem,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
            child: Text(
              menuItem,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  void submitData() async {
    if (addressTypeController.text.isEmpty ||
        fullAddressController.text.isEmpty) {
      Util.showSnackBar(
          scaffoldKey: _scaffoldKey,
          message: "Please fill all the data",
          duration: 1500);
      return;
    }

    final DeliveryAddressDetails deliveryAddressDetails =
        new DeliveryAddressDetails()
          ..addressType = addressTypeController.text
          ..fullAddress = fullAddressController.text
          ..areaName = selectedArea;

    Store.instance.setDeliveryAddress(deliveryAddressDetails);

    widget.callBack();
    closePage();

    return;
  }

  void closePage() {
    Navigator.pop(context);
  }

  void refreshUI() {
    if (mounted) setState(() {});
  }
}
