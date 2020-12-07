import 'dart:convert';
import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pharmacy_app/src/component/cards/homepage_slider_single_card.dart';
import 'package:pharmacy_app/src/component/general/app_bar_back_button.dart';
import 'package:pharmacy_app/src/component/general/drawerUI.dart';
import 'package:pharmacy_app/src/models/general/Enum_Data.dart';
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
  double currentScrollIndex = 0;
  final scrollController = ScrollController();

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
              'ORDER DETAILS',
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
            SizedBox(height: 20),
            buildImageList(),
            buildItemList(),
            SizedBox(height: 20),
            buildDeliveryAddressDetails(),
            buildPersonalDetails(),
            SizedBox(height: 20)
          ],
        ),
      ),
    );
  }

  Widget buildImageList() {
    if (order.orderType != ClientEnum.ORDER_TYPE_LIST_IMAGES)
      return Container();
    final scrollQuantity = 270;
    final size = MediaQuery.of(context).size;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        IconButton(
            icon: Icon(Icons.chevron_left),
            onPressed: () {
              if (currentScrollIndex <= 0) {
                currentScrollIndex = 0;
                return;
              }

              currentScrollIndex = currentScrollIndex - scrollQuantity;
              scrollController.animateTo(currentScrollIndex,
                  duration: Duration(seconds: 1), curve: Curves.fastOutSlowIn);
            }),
        Container(
          alignment: Alignment.center,
          width: 250,
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(color: Colors.black, width: 2.0),
              top: BorderSide(color: Colors.black, width: 2.0),
              right: BorderSide(color: Colors.black, width: 2.0),
              bottom: BorderSide(color: Colors.black, width: 2.0),
            ),
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: order.imageList.map((singleImageUrl) {
                return Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                  child: CachedNetworkImage(
                    imageUrl: singleImageUrl,
                    placeholder: (context, url) =>
                        new CircularProgressIndicator(
                      backgroundColor: Colors.white,
                    ),
                    errorWidget: (context, url, error) => new Icon(Icons.error),
                    fit: BoxFit.contain,
                    width: 250,
                    height: 300,
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        IconButton(
            icon: Icon(Icons.chevron_right),
            onPressed: () {
              if (currentScrollIndex >= order.imageList.length * 270) return;

              currentScrollIndex = currentScrollIndex + scrollQuantity;
              scrollController.animateTo(currentScrollIndex,
                  duration: Duration(seconds: 1), curve: Curves.fastOutSlowIn);
            }),
      ],
    );
  }

  Widget buildItemList() {
    if (order.orderType != ClientEnum.ORDER_TYPE_LIST_ITEMS) return Container();
    final children = List<Widget>();

    order.itemList.forEach((singleItem) {
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
          ),
        ),
      ));
    });

    return Column(children: children);
  }

  Widget buildDeliveryAddressDetails() {
    return Container(
      padding: const EdgeInsets.fromLTRB(32, 7, 32, 7),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text("DELIVER ADDRESS"),
          SizedBox(height: 10),
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text("Area"),
                SizedBox(height: 3),
                SizedBox(
                  height: 35, // set this
                  child: TextField(
                    style: textStyle,
                    controller: TextEditingController(
                        text: order.deliveryAddressDetails.addressType),
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
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text("Address"),
                SizedBox(height: 3),
                SizedBox(
                  height: 35, // set this
                  child: TextField(
                    style: textStyle,
                    controller: TextEditingController(
                        text: order.deliveryAddressDetails.fullAddress),
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
        ],
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
                Text("PERSONAL DETAILS"),
                SizedBox(height: 20),
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
