import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pharmacy_app/src/component/buttons/add_delivery_address_button.dart';
import 'package:pharmacy_app/src/component/buttons/general_action_round_button.dart';
import 'package:pharmacy_app/src/component/buttons/time_choose_button.dart';
import 'package:pharmacy_app/src/component/cards/all_address_card.dart';
import 'package:pharmacy_app/src/component/cards/homepage_slider_single_card.dart';
import 'package:pharmacy_app/src/component/cards/order_delivery_time_card.dart';
import 'package:pharmacy_app/src/component/cards/personal_details_card.dart';
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
  int currentIndex = 0;

  List<String> deliveryTimeDay = ["Today", " Tomorrow"];
  String selectedDeliveryTimeDay;

  List<String> deliveryTimeTime = [];
  String selectedDeliveryTimeTime;

  List<String> repeatDeliveryTime = ["Week", "15 Days", "1 Month"];
  String selectedRepeatDeliveryTime;

  List<String> areaList = ["Mirupur", "Banani", "Gulshan"];
  String selectedArea;

  final TextEditingController fullAddressController =
      new TextEditingController();

  final TextEditingController nameController = new TextEditingController();
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController phoneController = new TextEditingController();
  final TextEditingController addressIndexController =
      new TextEditingController(text: "0");

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
    createDeliveryTimeTime();
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
            OrderDeliveryAddressCard(
              callBackRefreshUI: refreshUI,
              deliveryTimeDay: deliveryTimeDay,
              selectedDeliveryTimeDay: selectedDeliveryTimeDay,
              setSelectedDeliveryTimeDay: setSelectedDeliveryTimeDay,
              deliveryTimeTime: deliveryTimeTime,
              selectedDeliveryTimeTime: selectedDeliveryTimeTime,
              setSelectedDeliveryTimeTime: setSelectedDeliveryTimeTime,
            ),
            AddDeliveryAddressButton(callBack: refreshUI),
            AllAddressCard(
                addressIndexController: addressIndexController,
                callBackRefreshUI: refreshUI),
            PersonalDetailsCard(
                nameController: nameController,
                phoneController: phoneController,
                emailController: emailController),
            GeneralActionRoundButton(
              title: "SUBMIT",
              isProcessing: false,
              callBack: submitOrder,
            ),
            SizedBox(height: 20)
          ],
        ),
      ),
    );
  }

  void setSelectedDeliveryTimeDay(dynamic value) {
    selectedDeliveryTimeDay = value;
    createDeliveryTimeTime();
  }

  void setSelectedDeliveryTimeTime(dynamic value) {
    selectedDeliveryTimeTime = value;
  }

  void createDeliveryTimeTime() {
    deliveryTimeTime.clear();
    DateTime currentTime = DateTime.now();
    DateTime officeTime = DateTime(
        currentTime.year, currentTime.month, currentTime.day, 10, 00, 00);
    final DateTime timeLimit = DateTime(
        currentTime.year, currentTime.month, currentTime.day, 22, 00, 00);
    int x = 0;

    if (selectedDeliveryTimeDay == deliveryTimeDay[0]) {
      while (currentTime.isBefore(timeLimit)) {
        if (currentTime.add(Duration(minutes: 90)).isAfter(timeLimit)) break;

        deliveryTimeTime.add(
            Util.formatDateToStringOnlyHourMinute(currentTime) +
                "-" +
                Util.formatDateToStringOnlyHourMinute(
                    currentTime.add(Duration(minutes: 90))));
        currentTime = currentTime.add(Duration(minutes: 90));
      }
    }

    if (selectedDeliveryTimeDay == deliveryTimeDay[1]) {
      while (officeTime.isBefore(timeLimit)) {
        if (officeTime.add(Duration(minutes: 90)).isAfter(timeLimit)) break;

        deliveryTimeTime.add(Util.formatDateToStringOnlyHourMinute(officeTime) +
            "-" +
            Util.formatDateToStringOnlyHourMinute(
                officeTime.add(Duration(minutes: 90))));
        officeTime = officeTime.add(Duration(minutes: 90));
      }
    }

    selectedDeliveryTimeTime = deliveryTimeTime[0];
    if (mounted) setState(() {});
  }

  void submitOrder() {
    if (Store.instance.appState.allDeliveryAddress.length == 0)
      Util.showSnackBar(
          scaffoldKey: _scaffoldKey, message: "Please add a delivery address");
  }

  Widget buildRepeatOrder() {
    if (checkedRepeatOrder == true) return Container();
    return CheckboxListTile(
      dense: true,
      contentPadding: const EdgeInsets.fromLTRB(20, 7, 0, 7),
      title: Text(
        "Repeat Order",
        style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Util.greenishColor()),
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
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Util.greenishColor()),
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
                    Text("Every",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Util.purplishColor())),
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
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.fromLTRB(32, 7, 0, 7),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("Day",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Util.purplishColor())),
                    SizedBox(height: 1),
                    buildDropdown(repeatDeliveryDay, selectedRepeatDeliveryDay,
                        CHOICE_ENUM.REPEAT_DELIVERY_DAY),
                  ],
                ),
              ),
            ),
            SizedBox(width: 30),
            Expanded(
              child: TimeChooseButton(),
            )
          ],
        )
      ],
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
                if (choice_enum == CHOICE_ENUM.DELIVERY_DAY) {
                  selectedDeliveryTimeDay = value;
                  createDeliveryTimeTime();
                }

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
