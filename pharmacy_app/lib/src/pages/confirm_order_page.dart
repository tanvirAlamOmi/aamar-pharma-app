import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:pharmacy_app/src/bloc/stream.dart';
import 'package:pharmacy_app/src/component/buttons/add_delivery_address_button.dart';
import 'package:pharmacy_app/src/component/buttons/general_action_round_button.dart';
import 'package:pharmacy_app/src/component/cards/all_address_card.dart';
import 'package:pharmacy_app/src/component/cards/order_delivery_time_card.dart';
import 'package:pharmacy_app/src/component/cards/order_repeat_order_card.dart';
import 'package:pharmacy_app/src/component/cards/personal_details_card.dart';
import 'package:pharmacy_app/src/component/general/app_bar_back_button.dart';
import 'package:pharmacy_app/src/component/general/loading_widget.dart';
import 'package:pharmacy_app/src/models/general/Enum_Data.dart';
import 'package:pharmacy_app/src/models/general/Order_Enum.dart';
import 'package:pharmacy_app/src/models/order/order.dart';
import 'package:pharmacy_app/src/models/states/app_vary_states.dart';
import 'package:pharmacy_app/src/models/states/event.dart';
import 'package:pharmacy_app/src/pages/verification_page.dart';
import 'package:pharmacy_app/src/repo/auth_repo.dart';
import 'package:pharmacy_app/src/repo/order_repo.dart';
import 'package:pharmacy_app/src/store/store.dart';
import 'package:pharmacy_app/src/util/util.dart';
import 'package:pharmacy_app/src/models/order/order_manual_item.dart';
import 'package:pharmacy_app/src/component/general/custom_message_box.dart';
import 'package:tuple/tuple.dart';

class ConfirmOrderPage extends StatefulWidget {
  final String note;
  final String orderType;
  final List<Uint8List> prescriptionImageFileList;
  final List<OrderManualItem> orderManualItemList;
  final Order order; // Only for Reorder Case

  ConfirmOrderPage(
      {this.note,
      this.orderManualItemList,
      Key key,
      this.prescriptionImageFileList,
      this.orderType,
      this.order})
      : super(key: key);

  @override
  _ConfirmOrderPageState createState() => _ConfirmOrderPageState();
}

class _ConfirmOrderPageState extends State<ConfirmOrderPage> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool isProcessing = false;
  String uploadStatus = "";

  DateTime currentTime;
  DateTime officeTime;
  DateTime timeLimit;

  List<String> deliveryTimeDay = [OrderEnum.DAY_TODAY, OrderEnum.DAY_TOMORROW];
  String selectedDeliveryTimeDay;

  List<String> deliveryTimeTime = [];
  String selectedDeliveryTimeTime;

  List<String> repeatDeliveryLongGap = [
    OrderEnum.REPEAT_1_WEEK,
    OrderEnum.REPEAT_15_DAYS,
    OrderEnum.REPEAT_1_MONTH
  ];
  String selectedRepeatDeliveryLongGap;

  List<String> repeatDeliveryDayBar = [
    OrderEnum.DAY_SATURDAY,
    OrderEnum.DAY_SUNDAY,
    OrderEnum.DAY_MONDAY,
    OrderEnum.DAY_TUESDAY,
    OrderEnum.DAY_WEDNESDAY,
    OrderEnum.DAY_THURSDAY,
    OrderEnum.DAY_FRIDAY,
  ];
  String selectedRepeatDeliveryDayBar;

  DateTime selectedRepeatDeliveryTime;

  bool checkedRepeatOrder = false;

  int selectedDeliveryAddressIndex = 0;

  TextEditingController nameController;
  TextEditingController emailController;
  TextEditingController phoneController;

  @override
  void initState() {
    super.initState();
    setTime();
    setSelectionData();
    setUserTextControllerData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void setUserTextControllerData() {
    String name = "";
    String email = "";
    String phone = "";

    if (widget.order != null) {
      name = widget.order.name;
      email = widget.order.email;
      phone = widget.order.mobileNo;
    } else if (Store.instance.appState.user != null) {
      name = Store.instance.appState.user.name;
      email = Store.instance.appState.user.email;
      phone = Store.instance.appState.user.phone;
    }
    nameController = new TextEditingController(text: name);
    emailController = new TextEditingController(text: email);
    phoneController = new TextEditingController(text: phone);
  }

  void setTime() {
    currentTime = DateTime.now();
    officeTime = DateTime(
        currentTime.year, currentTime.month, currentTime.day, 10, 00, 00);
    timeLimit = DateTime(
        currentTime.year, currentTime.month, currentTime.day, 22, 00, 00);
  }

  void setSelectionData() {
    selectedDeliveryTimeDay = deliveryTimeDay[0];
    createDeliveryTimeTime();
    setDeliveryDayOnTimeLimitCross();
    selectedRepeatDeliveryLongGap = repeatDeliveryLongGap[0];
    selectedRepeatDeliveryDayBar = repeatDeliveryDayBar[0];
    selectedRepeatDeliveryTime = DateTime.now();
  }

  void setDeliveryDayOnTimeLimitCross() {
    if (currentTime.isAfter(timeLimit)) {
      selectedDeliveryTimeDay = deliveryTimeDay[1];
    }
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

  Widget buildLoadingWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        LoadingWidget(status: 'Confirming Order...'),
        SizedBox(height: 10),
        Text(uploadStatus, textAlign: TextAlign.center)
      ],
    );
  }

  Widget buildBody(BuildContext context) {
    if (isProcessing) return buildLoadingWidget();
    return SingleChildScrollView(
      child: Container(
        alignment: Alignment.center,
        child: Stack(
          children: [
            Column(
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
                  setSelectedRepeatDeliveryDayBar:
                      setSelectedRepeatDeliveryDayBar,
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
                  callBackOnSubmit: processOrder,
                ),
                SizedBox(height: 20)
              ],
            ),
            buildTutorialBox()
          ],
        ),
      ),
    );
  }

  Widget buildTutorialBox() {
    final size = MediaQuery.of(context).size;
    switch (Store.instance.appState.tutorialBoxNumberConfirmOrderPage) {
      case 0:
        return Positioned(
          top: 60,
          left: 20,
          child: CustomMessageBox(
            width: size.width - 100,
            height: 120,
            startPoint: 40,
            midPoint: 50,
            endPoint: 60,
            arrowDirection: ClientEnum.ARROW_BOTTOM,
            callBackAction: updateTutorialBox,
            callBackRefreshUI: refreshUI,
            messageTitle:
                "Add the address of the place you would like to get your order delivered to",
          ),
        );
        break;
      case 1:
        if (Store.instance.appState.allDeliveryAddress.length == 0) {
          return Container();
          break;
        }
        return Positioned(
          top: 120,
          left: 20,
          child: CustomMessageBox(
            width: size.width - 100,
            height: 150,
            startPoint: 40,
            midPoint: 50,
            endPoint: 60,
            arrowDirection: ClientEnum.ARROW_BOTTOM,
            callBackAction: updateTutorialBox,
            callBackRefreshUI: refreshUI,
            messageTitle:
                "Select the address you would want this particular order to get delivered to. Selected address will have Green Border",
          ),
        );
        break;
      default:
        return Container();
        break;
    }
  }

  void updateTutorialBox() async {
    Store.instance.appState.tutorialBoxNumberConfirmOrderPage += 1;
    await Store.instance.putAppData();
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
    setTime();
    setDeliveryDayOnTimeLimitCross();

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

  Future<void> processOrder() async {
    if (Store.instance.appState.allDeliveryAddress.length == 0) {
      Util.showSnackBar(
          scaffoldKey: _scaffoldKey, message: "Please add a delivery address");
      return;
    }

    if (phoneController.text.length != 10) {
      Util.showSnackBar(
          scaffoldKey: _scaffoldKey,
          message: "Please provide a valid 11 digit Bangladeshi Number");
      return;
    }

    String deliveryDate = "";
    if (selectedDeliveryTimeDay == OrderEnum.DAY_TODAY) {
      var todayDateTime = DateTime.now();
      deliveryDate = Util.formatDateToyyyy_MM_DD(todayDateTime);
    } else if (selectedDeliveryTimeDay == OrderEnum.DAY_TOMORROW) {
      var todayDateTime = DateTime.now();
      todayDateTime = todayDateTime.add(Duration(days: 1));
      deliveryDate = Util.formatDateToyyyy_MM_DD(todayDateTime);
    }

    final String repeatOrder = checkedRepeatOrder ? "Yes" : "No";
    final String every =
        checkedRepeatOrder ? selectedRepeatDeliveryLongGap : null;
    final String day = checkedRepeatOrder ? selectedRepeatDeliveryDayBar : null;
    final String time = checkedRepeatOrder
        ? Util.formatDateToStringOnlyHourMinute(selectedRepeatDeliveryTime)
        : null;

    Order order = new Order()
      ..orderedWith = widget.orderType
      ..name = nameController.text
      ..email = emailController.text
      ..mobileNo = phoneController.text
      ..note = widget.note
      ..repeatOrder = repeatOrder
      ..deliveryTime = selectedDeliveryTimeTime
      ..deliveryDate = deliveryDate
      ..every = every
      ..day = day
      ..time = time;

    if (Store.instance.appState.user.id == null) {
      AppVariableStates.instance.order = order;
      AppVariableStates.instance.submitOrder = submitOrder;
      final countryCode = "+88";
      final phone = countryCode + phoneController.text;
      await Store.instance.setPhoneNumber(phoneController.text);
      await AuthRepo.instance.sendSMSCode(phone);

      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => VerificationPage(
                  phoneNumber: phoneController.text,
                  arrivedFromConfirmOrderPage: true,
                )),
      );
    } else {
      submitOrder();
    }
  }

  void submitOrder() async {
    isProcessing = true;
    refreshUI();
    await Future.delayed(Duration(seconds: 1));

    AppVariableStates.instance.order.idCustomer =
        Store.instance.appState.user.id;

    if (widget.orderType == OrderEnum.ORDER_WITH_PRESCRIPTION) {
      int imageNumber = 1;
      List<String> imageUrl = [];
      for (final image in widget.prescriptionImageFileList) {
        uploadStatus = "Uploading ${imageNumber} prescription";
        refreshUI();

        imageUrl.add(await Util.uploadImageToFirebase(
            imageFile: image, folderPath: 'prescription/'));
      }

      final String prescription = Util.imageURLAsCSV(imageList: imageUrl);
      AppVariableStates.instance.order.prescription = prescription;

      Tuple2<void, String> orderWithPresciptionResponse = await OrderRepo
          .instance
          .orderWithPrescription(order: AppVariableStates.instance.order);

      if (orderWithPresciptionResponse.item2 == ClientEnum.RESPONSE_SUCCESS) {
        Util.showSnackBar(
            scaffoldKey: _scaffoldKey,
            message: "Order is submitted.",
            duration: 1500);
      } else {
        isProcessing = false;
        Util.showSnackBar(
            scaffoldKey: _scaffoldKey,
            message: "Something went wrong. Please try again.",
            duration: 1500);
        return;
      }
    } else if (widget.orderType == OrderEnum.ORDER_WITH_ITEM_NAME) {
    }

    isProcessing = false;
    refreshUI();
    Navigator.of(context)
        .pushNamedAndRemoveUntil('/main', (Route<dynamic> route) => false);
    await Future.delayed(Duration(milliseconds: 500));
    Streamer.putEventStream(Event(EventType.SWITCH_TO_ORDER_NAVIGATION_PAGE));
  }

  void refreshUI() {
    if (mounted) setState(() {});
  }
}
