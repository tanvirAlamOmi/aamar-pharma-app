import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pharmacy_app/src/component/cards/homepage_slider_single_card.dart';
import 'package:pharmacy_app/src/component/general/app_bar_back_button.dart';
import 'package:pharmacy_app/src/component/general/drawerUI.dart';
import 'package:pharmacy_app/src/models/order/order.dart';
import 'package:pharmacy_app/src/util/util.dart';
import 'package:tuple/tuple.dart';
import 'package:pharmacy_app/src/component/cards/carousel_slider_card.dart';
import 'package:pharmacy_app/src/component/buttons/general_action_button.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pharmacy_app/src/pages/upload_prescription_verify_page.dart';
import 'package:pharmacy_app/src/models/order/order_manual_item.dart';
import 'package:pharmacy_app/src/pages/add_new_address.dart';

class OrderDetailsPage extends StatefulWidget {
  final Order order;

  OrderDetailsPage({this.order, Key key}) : super(key: key);

  @override
  _OrderDetailsPageState createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  Order order;
  final TextStyle textStyle = new TextStyle(fontSize: 11);

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
            buildDeliveryAddressBox(),
            buildAllAddresses(),
            buildPersonalDetails(),
            SizedBox(height: 20)
          ],
        ),
      ),
    );
  }

  Widget buildDeliveryAddressBox() {
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
              MaterialPageRoute(builder: (context) => AddNewAddressPage()),
            );
          },
          title: Text("Add New Address",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
          trailing: Icon(Icons.keyboard_arrow_right),
        ),
      ),
    );
  }

  Widget buildAllAddresses() {
    return Container(
      padding: const EdgeInsets.fromLTRB(27, 7, 27, 7),
      color: Colors.transparent,
      width: double.infinity,
      child: Material(
        shadowColor: Colors.grey[100].withOpacity(0.4),
        shape: RoundedRectangleBorder(
            side: const BorderSide(color: Colors.purpleAccent, width: 0.5),
            borderRadius: BorderRadius.circular(10.0)),
        elevation: 3,
        clipBehavior: Clip.antiAlias, // Add This
        child: ListTile(
            title: Text(
              "Home",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
            subtitle: Text(
              "39/A Kumarpara, Sylhet Housing Estate, Kumarpara, Sylhet",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
            trailing: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Icon(Icons.edit)],
            ),
            isThreeLine: true),
      ),
    );
  }

  Widget buildPersonalDetails() {
    return Container(
      padding: const EdgeInsets.fromLTRB(32, 7, 32, 7),
      child: Column(
        children: [
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text("Name"),
                SizedBox(height: 3),
                SizedBox(
                  height: 35, // set this
                  child: TextField(
                    style: textStyle,
                    controller:
                        TextEditingController(text: order.userDetails.name),
                    enabled: false,
                    decoration: new InputDecoration(
                      isDense: true,
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
          SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text("Email"),
                      SizedBox(height: 3),
                      SizedBox(
                        height: 35, // set this
                        child: TextField(
                          controller: TextEditingController(
                              text: order.userDetails.email),
                          style: textStyle,
                          enabled: false,
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
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text("Phone Number"),
                      SizedBox(height: 3),
                      SizedBox(
                        height: 35, // set this
                        child: TextField(
                          controller: TextEditingController(
                              text: order.userDetails.phoneNumber),
                          enabled: false,
                          style: textStyle,
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
          )
        ],
      ),
    );
  }

  pushRouteToUploadPrescriptionPage(PickedFile pickedPrescriptionImage) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => UploadPrescriptionVerifyPage(
                prescriptionImageFile: pickedPrescriptionImage,
              )),
    );
  }

  void refreshUI() {
    if (mounted) setState(() {});
  }
}

enum CHOICE_ENUM { DELIVERY_DAY, DELIVERY_TIME }
