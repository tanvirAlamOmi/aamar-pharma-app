import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pharmacy_app/src/component/buttons/general_action_round_button.dart';
import 'package:pharmacy_app/src/component/general/app_bar_back_button.dart';
import 'package:pharmacy_app/src/component/general/common_ui.dart';
import 'package:pharmacy_app/src/component/general/drop_down_item.dart';
import 'package:pharmacy_app/src/component/general/loading_widget.dart';
import 'package:pharmacy_app/src/models/general/App_Enum.dart';
import 'package:pharmacy_app/src/models/general/Client_Enum.dart';
import 'package:pharmacy_app/src/models/order/order.dart';
import 'package:pharmacy_app/src/models/states/app_vary_states.dart';
import 'package:pharmacy_app/src/repo/order_repo.dart';
import 'package:pharmacy_app/src/util/util.dart';
import 'package:tuple/tuple.dart';

class RepeatOrderChoicePage extends StatefulWidget {
  final String pageName;
  final Order order;

  const RepeatOrderChoicePage({Key key, this.pageName, this.order})
      : super(key: key);

  @override
  _RepeatOrderChoicePageState createState() => _RepeatOrderChoicePageState();
}

class _RepeatOrderChoicePageState extends State<RepeatOrderChoicePage> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool isProcessing = false;

  List<String> deliveryDayInterval =
      new List<String>.generate(30, (i) => (i + 1).toString());
  String selectedDeliveryDayInterval = '7';

  List<String> deliveryTimeTime = [];
  String selectedDeliveryTimeTime;

  DateTime currentTime;
  DateTime officeTime;
  DateTime timeLimit;

  @override
  void initState() {
    super.initState();
    setTime();
    AppVariableStates.instance.pageName = AppEnum.PAGE_REPEAT_ORDER_CHOICE;
  }

  void setTime() {
    currentTime = DateTime.now();
    officeTime = DateTime(
        currentTime.year, currentTime.month, currentTime.day, 10, 00, 00);
    timeLimit = DateTime(
        currentTime.year, currentTime.month, currentTime.day, 22, 00, 00);

    while (officeTime.isBefore(timeLimit)) {
      if (officeTime.add(Duration(minutes: 90)).isAfter(timeLimit)) break;

      deliveryTimeTime.add(Util.formatDateToStringOnlyHourMinute(officeTime) +
          "-" +
          Util.formatDateToStringOnlyHourMinute(
              officeTime.add(Duration(minutes: 90))));
      officeTime = officeTime.add(Duration(minutes: 90));
    }

    selectedDeliveryTimeTime = deliveryTimeTime[0];
  }

  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          leading: AppBarBackButton(),
          elevation: 1,
          centerTitle: true,
          title: CustomText('REPEAT ORDER',
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500),
        ),
        body: buildBody());
  }

  Widget buildBody() {
    if (isProcessing) return buildLoadingWidget();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        buildTitles(),
        SizedBox(height: 10),
        buildRepeatOrderDayInterval(),
        SizedBox(height: 10),
        buildRepeatOrderDeliveryTime(),
        SizedBox(height: 10),
        GeneralActionRoundButton(
          isProcessing: isProcessing,
          title: 'SUBMIT',
          callBackOnSubmit: submit,
        ),
      ],
    );
  }

  Widget buildTitles() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        child: CustomText(
            'Please select the interval and time you would like to get this order delivered on regular basis',
            color: Colors.grey,
            fontWeight: FontWeight.bold,
            fontSize: 15),
      ),
    );
  }

  Widget buildLoadingWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        LoadingWidget(status: 'Processing...'),
      ],
    );
  }

  Widget buildRepeatOrderDayInterval() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomText('Deliver every', color: Util.purplishColor()),
        SizedBox(width: 15),
        Container(
          width: 50,
          child: DropDownItem(
            dropDownList: deliveryDayInterval,
            selectedItem: selectedDeliveryDayInterval,
            setSelectedItem: setSelectedDeliveryDayInterval,
            callBackRefreshUI: refreshUI,
            dropDownTextColor: Util.greenishColor(),
          ),
        ),
        SizedBox(width: 15),
        CustomText('Day(s)', color: Util.purplishColor()),
      ],
    );
  }

  Widget buildRepeatOrderDeliveryTime() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomText('Select Time', color: Util.purplishColor()),
        SizedBox(width: 10),
        Container(
          width: 160,
          child: DropDownItem(
            dropDownList: deliveryTimeTime,
            selectedItem: selectedDeliveryTimeTime,
            setSelectedItem: setSelectedDeliveryTimeTime,
            callBackRefreshUI: refreshUI,
            dropDownTextColor: Util.greenishColor(),
          ),
        ),
      ],
    );
  }

  void submit() async {
    switch (widget.pageName) {
      case AppEnum.CONFIRM_ORDER_PAGE:
        AppVariableStates.instance.order.repeatOrder = ClientEnum.YES;
        AppVariableStates.instance.order.every = selectedDeliveryDayInterval;
        AppVariableStates.instance.order.time = selectedDeliveryTimeTime;
        Navigator.pop(context);
        AppVariableStates.instance.submitFunction();
        break;

      case AppEnum.CONFIRM_INVOICE_PAGE:
        isProcessing = true;
        refreshUI();
        Tuple2<void, String> allowRepeatOrderResponse = await OrderRepo.instance
            .allowRepeatOrder(
                orderId: widget.order.id,
                dayInterval: selectedDeliveryDayInterval,
                deliveryTime: selectedDeliveryTimeTime);

        if (allowRepeatOrderResponse.item2 == ClientEnum.RESPONSE_SUCCESS) {
          Util.showSnackBar(
              scaffoldKey: _scaffoldKey,
              message: "Repeat order submission success.",
              duration: 1500);
          await Future.delayed(Duration(seconds: 2));
          Navigator.pop(context);
        } else {
          Util.showSnackBar(
              scaffoldKey: _scaffoldKey,
              message: "Something went wrong. Please try again.",
              duration: 1500);
        }

        isProcessing = false;
        refreshUI();
        break;
    }
  }

  void setSelectedDeliveryDayInterval(dynamic value) {
    selectedDeliveryDayInterval = value;
  }

  void setSelectedDeliveryTimeTime(dynamic value) {
    selectedDeliveryTimeTime = value;
  }

  void refreshUI() {
    if (mounted) setState(() {});
  }
}
