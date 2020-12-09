import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pharmacy_app/src/component/buttons/time_choose_button.dart';
import 'package:pharmacy_app/src/component/cards/homepage_slider_single_card.dart';
import 'package:pharmacy_app/src/component/general/app_bar_back_button.dart';
import 'package:pharmacy_app/src/component/general/drawerUI.dart';
import 'package:pharmacy_app/src/store/store.dart';
import 'package:pharmacy_app/src/util/util.dart';
import 'package:tuple/tuple.dart';
import 'package:pharmacy_app/src/component/cards/carousel_slider_card.dart';
import 'package:pharmacy_app/src/component/buttons/general_action_button.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pharmacy_app/src/pages/upload_prescription_verify_page.dart';
import 'package:pharmacy_app/src/models/order/order_manual_item.dart';
import 'package:pharmacy_app/src/pages/add_new_address.dart';
import 'package:pharmacy_app/src/models/order/deliver_address_details.dart';

class ConfirmOrderPage extends StatefulWidget {
  final String note;
  final PickedFile prescriptionImageFile;
  final List<OrderManualItem> orderManualItemList;

  ConfirmOrderPage(
      {this.note,
      this.orderManualItemList,
      this.prescriptionImageFile,
      Key key})
      : super(key: key);

  @override
  _ConfirmOrderPageState createState() => _ConfirmOrderPageState();
}

class _ConfirmOrderPageState extends State<ConfirmOrderPage> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool isProcessing = false;
  PickedFile pickedImageFile;
  int currentINdex = 0;

  List<String> deliveryTimeDay = ["Today"];
  String selectedDeliveryTimeDay;

  List<String> deliveryTimeTime = ["ASAP", "AFTER 1 HOUR", "AFTER 2 HOURS"];
  String selectedDeliveryTimeTime;

  List<String> repeatDeliveryTime = ["Week", "15 Days", "1 Month"];
  String selectedRepeatDeliveryTime;

  List<String> areaList = ["Mirupur", "Banani", "Gulshan"];
  String selectedArea;

  final TextEditingController fullAddressController =
      new TextEditingController();

  List<String> repeatDeliveryDay = [
    "Saturday",
    "Sunday",
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday"
  ];
  String selectedRepeatDeliveryDay;

  bool checkedRepeatOrder = false;

  @override
  void initState() {
    super.initState();
    selectedDeliveryTimeDay = deliveryTimeDay[0];
    selectedDeliveryTimeTime = deliveryTimeTime[0];
    selectedRepeatDeliveryTime = repeatDeliveryTime[0];
    selectedRepeatDeliveryDay = repeatDeliveryDay[0];
    selectedArea = areaList[0];
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
            buildDeliveryTime(),
            buildRepeatOrder(),
            buildRepeatOrderWithDropDown(),
            buildInstantDeliveryAddressField(),
            buildDeliveryAddressBox(),
            buildAllAddresses(),
            buildPersonalDetails(),
            GeneralActionButton(title: "SUBMIT",isProcessing: false,),
            SizedBox(height: 20)
          ],
        ),
      ),
    );
  }

  Widget buildDeliveryTime() {
    return Container(
      padding: const EdgeInsets.fromLTRB(32, 7, 32, 7),
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text("DELIVERY TIME"),
          SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("Day"),
                    buildDropdown(deliveryTimeDay, selectedDeliveryTimeDay,
                        CHOICE_ENUM.DELIVERY_DAY),
                  ],
                ),
              ),
              SizedBox(width: 30),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("Time"),
                    buildDropdown(deliveryTimeTime, selectedDeliveryTimeTime,
                        CHOICE_ENUM.DELIVERY_TIME),
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget buildRepeatOrder() {
    if (checkedRepeatOrder == true) return Container();
    return CheckboxListTile(
      dense: true,
      contentPadding: const EdgeInsets.fromLTRB(20, 7, 0, 7),
      title: Text(
        "Repeat Order",
        style: TextStyle(fontSize: 13),
      ),
      value: checkedRepeatOrder,
      onChanged: (newValue) {
        if (mounted)
          setState(() {
            checkedRepeatOrder = newValue;
          });
      },
      controlAffinity: ListTileControlAffinity.leading,
    );
  }

  Widget buildRepeatOrderWithDropDown() {
    if (checkedRepeatOrder == false) return Container();
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: CheckboxListTile(
                contentPadding: const EdgeInsets.fromLTRB(20, 7, 0, 7),
                title: Text(
                  "Repeat Order",
                  style: TextStyle(fontSize: 13),
                ),
                value: checkedRepeatOrder,
                onChanged: (newValue) {
                  setState(() {
                    checkedRepeatOrder = newValue;
                  });
                },
                controlAffinity:
                    ListTileControlAffinity.leading, //  <-- leading Checkbox
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.fromLTRB(14, 7, 32, 7),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("Every"),
                    buildDropdown(
                        repeatDeliveryTime,
                        selectedRepeatDeliveryTime,
                        CHOICE_ENUM.REPEAT_DELIVER_TIME),
                  ],
                ),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Container(
              width: 165,
              padding: const EdgeInsets.fromLTRB(32, 7, 0, 7),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("Day"),
                  SizedBox(height: 1),
                  buildDropdown(repeatDeliveryDay, selectedRepeatDeliveryDay,
                      CHOICE_ENUM.REPEAT_DELIVERY_DAY),
                ],
              ),
            ),
            SizedBox(width: 30),
            TimeChooseButton(),
          ],
        )
      ],
    );
  }

  Widget buildInstantDeliveryAddressField() {
    if (Store.instance.appState.allDeliveryAddress.length > 0)
      return Container();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(27, 5, 27, 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text("Select Area"),
              buildDropdown(areaList, selectedArea, CHOICE_ENUM.AREA_SELECTION),
            ],
          ),
        ),
        buildFullAddressTextField(),
      ],
    );
  }

  Widget buildFullAddressTextField() {
    return Container(
      padding: const EdgeInsets.fromLTRB(27, 7, 27, 7),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text("Address", style: TextStyle(fontWeight: FontWeight.bold)),
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
              MaterialPageRoute(
                  builder: (context) => AddNewAddressPage(
                        callBack: refreshUI,
                      )),
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
    if (Store.instance.appState.allDeliveryAddress.length == 0)
      return Container();

    return Column(
        children: Store.instance.appState.allDeliveryAddress
            .map((singleDeliveryAddress) {
      return GestureDetector(
        onTap: () {
          setState(() {
            currentINdex = Store.instance.appState.allDeliveryAddress
                .indexOf(singleDeliveryAddress);
            print(currentINdex);
          });
        },
        child: Container(
          padding: const EdgeInsets.fromLTRB(27, 7, 27, 7),
          color: Colors.transparent,
          width: double.infinity,
          child: Material(
            shadowColor: Colors.grey[100].withOpacity(0.4),
            shape: RoundedRectangleBorder(
                side: BorderSide(
                    color: getSelectedColor(singleDeliveryAddress), width: 0.5),
                borderRadius: BorderRadius.circular(10.0)),
            elevation: 3,
            clipBehavior: Clip.antiAlias, // Add This
            child: ListTile(
                title: Text(
                  singleDeliveryAddress.addressType,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                ),
                subtitle: Text(
                  singleDeliveryAddress.fullAddress,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                ),
                trailing: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Icon(Icons.edit)],
                ),
                isThreeLine: true),
          ),
        ),
      );
    }).toList());
  }

  Color getSelectedColor(DeliveryAddressDetails deliveryAddressDetails) {
    if (currentINdex ==
        Store.instance.appState.allDeliveryAddress
            .indexOf(deliveryAddressDetails)) return Colors.purpleAccent;

    return Colors.transparent;
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
                    decoration: new InputDecoration(
                      isDense: true,
                      hintText: "Mr. XYZ",
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

  Widget buildDropdown(
      List<String> dropDownList, String selectedItem, CHOICE_ENUM choice_enum) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
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
              value: selectedItem,
              onChanged: (value) {
                if (value == null) return;
                if (choice_enum == CHOICE_ENUM.DELIVERY_DAY)
                  selectedDeliveryTimeDay = value;

                if (choice_enum == CHOICE_ENUM.DELIVERY_TIME)
                  selectedDeliveryTimeTime = value;

                if (choice_enum == CHOICE_ENUM.REPEAT_DELIVER_TIME)
                  selectedRepeatDeliveryTime = value;

                if (choice_enum == CHOICE_ENUM.REPEAT_DELIVERY_DAY)
                  selectedRepeatDeliveryDay = value;

                if (choice_enum == CHOICE_ENUM.AREA_SELECTION)
                  selectedArea = value;

                if (mounted) setState(() {});
              },
              items: dropDownList.map((item) {
                return buildDropDownMenuItem(item);
              }).toList(),
            ),
          ),
        )
      ],
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

  void refreshUI() {
    if (mounted) setState(() {});
  }
}

enum CHOICE_ENUM {
  DELIVERY_DAY,
  DELIVERY_TIME,
  REPEAT_DELIVER_TIME,
  REPEAT_DELIVERY_DAY,
  AREA_SELECTION
}
