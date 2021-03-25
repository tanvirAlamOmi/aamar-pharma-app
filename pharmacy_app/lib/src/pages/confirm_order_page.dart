import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:pharmacy_app/src/bloc/stream.dart';
import 'package:pharmacy_app/src/component/buttons/add_delivery_address_button.dart';
import 'package:pharmacy_app/src/component/buttons/general_action_round_button.dart';
import 'package:pharmacy_app/src/component/cards/all_address_card.dart';
import 'package:pharmacy_app/src/component/cards/order_delivery_time_card.dart';
import 'package:pharmacy_app/src/component/cards/order_invoice_table_card.dart';
import 'package:pharmacy_app/src/component/cards/order_repeat_order_card.dart';
import 'package:pharmacy_app/src/component/cards/personal_details_card.dart';
import 'package:pharmacy_app/src/component/general/app_bar_back_button.dart';
import 'package:pharmacy_app/src/component/general/common_ui.dart';
import 'package:pharmacy_app/src/component/general/drawerUI.dart';
import 'package:pharmacy_app/src/component/general/loading_widget.dart';
import 'package:pharmacy_app/src/models/general/App_Enum.dart';
import 'package:pharmacy_app/src/models/general/Client_Enum.dart';
import 'package:pharmacy_app/src/models/general/App_Enum.dart';
import 'package:pharmacy_app/src/models/order/invoice_item.dart';
import 'package:pharmacy_app/src/models/order/order.dart';
import 'package:pharmacy_app/src/models/states/app_vary_states.dart';
import 'package:pharmacy_app/src/models/states/event.dart';
import 'package:pharmacy_app/src/models/states/ui_state.dart';
import 'package:pharmacy_app/src/pages/repeat_order_choice_page.dart';
import 'package:pharmacy_app/src/pages/request_received_success_page.dart';
import 'package:pharmacy_app/src/pages/verification_page.dart';
import 'package:pharmacy_app/src/repo/auth_repo.dart';
import 'package:pharmacy_app/src/repo/order_repo.dart';
import 'package:pharmacy_app/src/store/store.dart';
import 'package:pharmacy_app/src/util/util.dart';
import 'package:pharmacy_app/src/models/order/order_manual_item.dart';
import 'package:pharmacy_app/src/component/general/custom_message_box.dart';
import 'package:tuple/tuple.dart';
import 'package:pharmacy_app/src/util/en_bn_dict.dart';

class ConfirmOrderPage extends StatefulWidget {
  final bool isRepeatOrder;
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
      this.order,
      this.isRepeatOrder})
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

  List<String> deliveryTimeDay = [AppEnum.DAY_TODAY, AppEnum.DAY_TOMORROW];
  String selectedDeliveryTimeDay;

  List<String> deliveryTimeTime = [];
  String selectedDeliveryTimeTime;

  int selectedDeliveryAddressIndex = 0;

  TextEditingController nameController;
  TextEditingController emailController;
  TextEditingController phoneController;

  @override
  void initState() {
    super.initState();
    eventChecker();
    setTime();
    setSelectionData();
    setUserTextControllerData();
    UIState.instance.scaffoldKey = _scaffoldKey;
  }

  @override
  void dispose() {
    super.dispose();
  }

  void eventChecker() async {
    Streamer.getEventStream().listen((data) {
      if (data.eventType == EventType.REFRESH_CONFIRM_ORDER_PAGE ||
          data.eventType == EventType.REFRESH_ALL_PAGES) {
        refreshUI();
      }

      if (data.eventType == EventType.CHANGE_LANGUAGE) {
        refreshUI();
      }
    });
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
  }

  void setDeliveryDayOnTimeLimitCross() {
    if (currentTime.isAfter(timeLimit)) {
      selectedDeliveryTimeDay = deliveryTimeDay[1];
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Util.removeFocusNode(context),
      child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            leading: AppBarBackButton(),
            elevation: 1,
            centerTitle: true,
            title: CustomText('CONFIRM ORDER',
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500),
          ),
          body: buildBody(context)),
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
                OrderDeliveryTimeScheduleCard(
                  callBackRefreshUI: refreshUI,
                  deliveryTimeDay: deliveryTimeDay,
                  selectedDeliveryTimeDay: selectedDeliveryTimeDay,
                  setSelectedDeliveryTimeDay: setSelectedDeliveryTimeDay,
                  deliveryTimeTime: deliveryTimeTime,
                  selectedDeliveryTimeTime: selectedDeliveryTimeTime,
                  setSelectedDeliveryTimeTime: setSelectedDeliveryTimeTime,
                ),
                SizedBox(height: 10),
                buildReOrderInvoiceTable(),
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
                  callBackOnSubmit: () {
                    Util.removeFocusNode(context);
                    showAlertDialog(
                        context: context,
                        message: "CONFIRM SUBMITTING ORDER?",
                        acceptFunc: processOrder);
                  },
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

  Widget buildLoadingWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        LoadingWidget(status: 'Submitting Order...'),
        SizedBox(height: 10),
        CustomText(uploadStatus, textAlign: TextAlign.center)
      ],
    );
  }

  Widget buildReOrderInvoiceTable() {
    if (widget.orderType != AppEnum.ORDER_WITH_ITEM_NAME_REORDER)
      return Container();
    return OrderInvoiceTableCard(
      order: widget.order,
      callBackIncrementItemQuantity: incrementItemQuantity,
      callBackDecrementItemQuantity: decrementItemQuantity,
      callBackRemoveItem: removeItem,
      callBackRefreshUI: refreshUI,
      showCrossColumn: true,
      showItemNameColumn: true,
      showUnitCostColumn: false,
      showQuantityColumn: true,
      showIncDecButtons: true,
      showAmountColumn: false,
      showSubTotalRow: false,
      showGrandTotalRow: false,
      padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
    );
  }

  void removeItem(dynamic singleItem) {
    if (widget.order.invoiceItemList.length == 1) {
      Util.showSnackBar(
          message: 'You can not remove the last item',
          scaffoldKey: _scaffoldKey);
      return;
    }
    widget.order.invoiceItemList.remove(singleItem);
  }

  void incrementItemQuantity(InvoiceItem invoiceItem) {
    for (final singleItem in widget.order.invoiceItemList) {
      if (singleItem == invoiceItem) {
        singleItem.quantity = singleItem.quantity + 1;
        break;
      }
    }
  }

  void decrementItemQuantity(InvoiceItem invoiceItem) {
    for (final singleItem in widget.order.invoiceItemList) {
      if (singleItem == invoiceItem) {
        if (singleItem.quantity == 1) {
          return;
        }
        singleItem.quantity = singleItem.quantity - 1;
        break;
      }
    }
  }

  Widget buildTutorialBox() {
    final size = MediaQuery.of(context).size;
    switch (Store.instance.appState.tutorialBoxNumberConfirmOrderPage) {
      case 0:
        return Positioned(
          top: 20,
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
          top: 80,
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

  void setSelectedDeliveryAddressIndex(int index) {
    selectedDeliveryAddressIndex = index;
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

    if (nameController.text.isEmpty) {
      Util.showSnackBar(
          scaffoldKey: _scaffoldKey, message: "Please provide a name");
      return;
    }

    if (emailController.text.isNotEmpty &&
        !Util.isEmail(emailAddress: emailController.text)) {
      Util.showSnackBar(
          scaffoldKey: _scaffoldKey,
          message: "Please provide a valid email address");
      return;
    }

    if (phoneController.text.length != 11) {
      Util.showSnackBar(
          scaffoldKey: _scaffoldKey,
          message: "Please provide a valid 11 digit Bangladeshi Number");
      return;
    }

    if (!Util.verifyNumberDigitOnly(numberText: phoneController.text)) {
      Util.showSnackBar(
          scaffoldKey: _scaffoldKey,
          message: "Please provide a valid 11 digit Bangladeshi Number");
      return;
    }

    String deliveryDate = "";
    if (selectedDeliveryTimeDay == AppEnum.DAY_TODAY) {
      var todayDateTime = DateTime.now();
      deliveryDate = Util.formatDateToyyyy_MM_DD(todayDateTime);
    } else if (selectedDeliveryTimeDay == AppEnum.DAY_TOMORROW) {
      var todayDateTime = DateTime.now();
      todayDateTime = todayDateTime.add(Duration(days: 1));
      deliveryDate = Util.formatDateToyyyy_MM_DD(todayDateTime);
    }

    Order order = new Order()
      ..idAddress = Store
          .instance.appState.allDeliveryAddress[selectedDeliveryAddressIndex].id
      ..items = widget.orderManualItemList
      ..orderedWith = widget.orderType
      ..name = nameController.text
      ..email = emailController.text
      ..mobileNo = phoneController.text
      ..note = widget.note
      ..repeatOrder = (widget.isRepeatOrder) ? ClientEnum.YES : ClientEnum.NO
      ..deliveryTime = selectedDeliveryTimeTime
      ..deliveryDate = deliveryDate;

    AppVariableStates.instance.order = order;
    AppVariableStates.instance.submitFunction = submitOrder;

    if (Store.instance.appState.user.id == null) {
      final countryCode = "+88";
      final phone = countryCode + phoneController.text;
      await Store.instance.setPhoneNumber(phoneController.text);
      await AuthRepo.instance.sendSMSCode(phone);

      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => VerificationPage(
                  phoneNumber: phoneController.text,
                  onVerificationNextStep: AppEnum.ON_VERIFICATION_CONFIRM_ORDER,
                )),
      );
      return;
    }
    if (Store.instance.appState.user.id != null &&
        AppVariableStates.instance.order.repeatOrder == ClientEnum.YES) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                RepeatOrderChoicePage(pageName: AppEnum.CONFIRM_ORDER_PAGE)),
      );
      return;
    }
    AppVariableStates.instance.submitFunction();
    Streamer.putEventStream(Event(EventType.REFRESH_ALL_PAGES));
  }

  void submitOrder() async {
    isProcessing = true;
    refreshUI();

    Tuple2<void, String> orderSubmitResponse;

    AppVariableStates.instance.order.idCustomer =
        Store.instance.appState.user.id;

    switch (widget.orderType) {
      case AppEnum.ORDER_WITH_PRESCRIPTION:
        int imageNumber = 1;
        List<String> imageUrl = [];

        for (final image in widget.prescriptionImageFileList) {
          uploadStatus = EnBnDict.en_bn_number_convert(number: imageNumber) +
              ' ' +
              EnBnDict.en_bn_convert(text: 'UPLOADED PRESCRIPTION(s)');
          refreshUI();
          imageNumber += 1;

          imageUrl.add(await Util.uploadImageToFirebase(
              imageFile: image, folderPath: 'prescription/'));
        }

        final String prescription = Util.imageURLAsCSV(imageList: imageUrl);
        AppVariableStates.instance.order.prescription = prescription;
        orderSubmitResponse = await OrderRepo.instance
            .orderWithPrescription(order: AppVariableStates.instance.order);
        break;

      case AppEnum.ORDER_WITH_ITEM_NAME:
        orderSubmitResponse = await OrderRepo.instance
            .orderWithItemName(order: AppVariableStates.instance.order);
        break;

      case AppEnum.ORDER_WITH_ITEM_NAME_REORDER:
        final List<OrderManualItem> items = [];
        for (final invoiceItem in widget.order.invoiceItemList) {
          items.add(OrderManualItem()
            ..itemName = invoiceItem.itemName
            ..unit = ClientEnum.NA
            ..quantity = invoiceItem.quantity);
        }
        AppVariableStates.instance.order.items = items;
        orderSubmitResponse = await OrderRepo.instance
            .orderWithItemName(order: AppVariableStates.instance.order);
    }

    if (orderSubmitResponse.item2 == ClientEnum.RESPONSE_SUCCESS) {
      Util.showSnackBar(
          scaffoldKey: _scaffoldKey,
          message: "Order is submitted.",
          duration: 1500);
      await Future.delayed(Duration(milliseconds: 500));
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/main', (Route<dynamic> route) => false);
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => RequestReceivedSuccessPage(
                  icon: Icons.shopping_cart,
                  pageTitle: 'ORDER RECEIVED',
                  title: 'Your order has been placed.',
                  message: 'We will get back to you within 30 minutes.',
                )),
      );
      await Future.delayed(Duration(milliseconds: 500));
      Streamer.putEventStream(Event(EventType.SWITCH_TO_ORDER_NAVIGATION_PAGE));
    } else {
      Util.showSnackBar(
          scaffoldKey: _scaffoldKey,
          message: "Something went wrong. Please try again.",
          duration: 1500);
    }

    isProcessing = false;
    refreshUI();
  }

  void refreshUI() {
    if (mounted) setState(() {});
  }
}
