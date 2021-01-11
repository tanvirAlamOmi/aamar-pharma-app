import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pharmacy_app/src/component/buttons/add_delivery_address_button.dart';
import 'package:pharmacy_app/src/component/buttons/general_action_round_button.dart';
import 'package:pharmacy_app/src/component/cards/all_address_card.dart';
import 'package:pharmacy_app/src/component/cards/order_delivery_time_card.dart';
import 'package:pharmacy_app/src/component/cards/order_repeat_order_card.dart';
import 'package:pharmacy_app/src/component/cards/personal_details_card.dart';
import 'package:pharmacy_app/src/component/general/app_bar_back_button.dart';
import 'package:pharmacy_app/src/models/general/Enum_Data.dart';
import 'package:pharmacy_app/src/models/order/order.dart';
import 'package:pharmacy_app/src/models/user/user_details.dart';
import 'package:pharmacy_app/src/pages/verification_page.dart';
import 'package:pharmacy_app/src/store/store.dart';
import 'package:pharmacy_app/src/util/util.dart';
import 'package:pharmacy_app/src/models/order/order_manual_item.dart';
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

  List<String> deliveryTimeDay = ["Today", "Tomorrow"];
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

  DateTime selectedRepeatDeliveryTime;

  bool checkedRepeatOrder = false;

  int selectedDeliveryAddressIndex = 0;

  final TextEditingController fullAddressController =
      new TextEditingController();
  final TextEditingController nameController = new TextEditingController();
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController phoneController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    setSelectionData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void setSelectionData() {
    selectedDeliveryTimeDay = deliveryTimeDay[0];
    createDeliveryTimeTime();
    selectedRepeatDeliveryLongGap = repeatDeliveryLongGap[0];
    selectedRepeatDeliveryDayBar = repeatDeliveryDayBar[0];
    selectedRepeatDeliveryTime = DateTime.now();
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
              selectedRepeatDeliveryTime: selectedRepeatDeliveryTime,
              setSelectedRepeatDeliveryTime: setSelectedRepeatDeliveryTime,
            ),
            AddDeliveryAddressButton(callBack: refreshUI),
            AllAddressCard(
                selectedDeliveryAddressIndex: selectedDeliveryAddressIndex,
                setSelectedDeliveryAddressIndex:
                    setSelectedDeliveryAddressIndex,
                callBackRefreshUI: refreshUI),
            PersonalDetailsCard(
                nameController: nameController,
                phoneController: phoneController,
                emailController: emailController),
            GeneralActionRoundButton(
              title: "SUBMIT",
              isProcessing: false,
              callBackOnSubmit: submitOrder,
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

  void setSelectedRepeatDeliveryTime(DateTime value) {
    selectedRepeatDeliveryTime = value;
  }

  void setSelectedDeliveryAddressIndex(int index) {
    selectedDeliveryAddressIndex = index;
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
    if (Store.instance.appState.allDeliveryAddress.length == 0) {
      Util.showSnackBar(
          scaffoldKey: _scaffoldKey, message: "Please add a delivery address");
      return;
    }

    if (phoneController.text.length != 11) {
      Util.showSnackBar(
          scaffoldKey: _scaffoldKey,
          message: "Please provide a valid 11 digit Bangladshi Number");
      return;
    }

    Order order = new Order()
      ..id = "009"
      ..orderType = ClientEnum.ORDER_TYPE_LIST_IMAGES
      ..orderStatus =
          ClientEnum.ORDER_STATUS_PENDING_INVOICE_RESPONSE_FROM_PHARMA
      ..deliveryAddressDetails = (new DeliveryAddressDetails()
        ..fullAddress = fullAddressController.text)
      ..userDetails = (new UserDetails()
        ..name = nameController.text
        ..phoneNumber = phoneController.text
        ..email = emailController.text);

    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => VerificationPage(
                order: order,
            arrivedFromConfirmOrderPage: true,
              )),
    );
  }

  void refreshUI() {
    if (mounted) setState(() {});
  }
}
