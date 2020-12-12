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
import 'package:pharmacy_app/src/component/cards/order_repeat_order_card.dart';
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

  List<String> repeatDeliveryLongGap = ["Week", "15 Days", "1 Month"];
  String selectedRepeatDeliveryLongGap;

  List<String> repeatDeliveryDayBar = [
    "Saturday",
    "Sunday",
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday"
  ];
  String selectedRepeatDeliveryDayBar;

  bool checkedRepeatOrder = false;

  final TextEditingController fullAddressController =
      new TextEditingController();
  final TextEditingController nameController = new TextEditingController();
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController phoneController = new TextEditingController();
  final TextEditingController addressIndexController =
      new TextEditingController(text: "0");

  @override
  void initState() {
    super.initState();
    selectedDeliveryTimeDay = deliveryTimeDay[0];
    createDeliveryTimeTime();
    selectedRepeatDeliveryLongGap = repeatDeliveryLongGap[0];
    selectedRepeatDeliveryDayBar = repeatDeliveryDayBar[0];
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
            OrderRepeatOrderCard(
              callBackRefreshUI: refreshUI,
              checkedRepeatOrder: checkedRepeatOrder,
              setRepeatOrder: setRepeatOrder,
              repeatDeliveryLongGap: repeatDeliveryLongGap,
              selectedRepeatDeliveryLongGap: selectedRepeatDeliveryLongGap,
              setRepeatDeliveryLongGap: setSelectedRepeatDeliveryLongGap,
              repeatDeliveryDayBar: repeatDeliveryDayBar,
              selectedRepeatDeliveryDayBar: selectedRepeatDeliveryDayBar,
              setSelectedRepeatDeliveryDayBar: setSelectedRepeatDeliveryDayBar,
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

  void setSelectedRepeatDeliveryLongGap(dynamic value) {
    selectedRepeatDeliveryLongGap = value;
  }

  void setSelectedRepeatDeliveryDayBar(dynamic value) {
    selectedRepeatDeliveryDayBar = value;
  }

  void setRepeatOrder(value) {
    checkedRepeatOrder = value;
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

  void refreshUI() {
    if (mounted) setState(() {});
  }
}
