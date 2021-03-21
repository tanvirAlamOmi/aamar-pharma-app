import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pharmacy_app/src/component/general/app_bar_back_button.dart';
import 'package:pharmacy_app/src/component/general/common_ui.dart';
import 'package:pharmacy_app/src/util/util.dart';
import 'package:tuple/tuple.dart';

import '../component/buttons/general_action_round_button.dart';
import '../component/general/common_ui.dart';
import '../component/general/drop_down_item.dart';
import '../models/general/Enum_Data.dart';
import '../repo/order_repo.dart';

class ConfirmOrderSuccessWithRepeatOrder extends StatefulWidget {
  final int orderId;

  const ConfirmOrderSuccessWithRepeatOrder({Key key, this.orderId})
      : super(key: key);

  @override
  _ConfirmOrderSuccessWithRepeatOrderState createState() =>
      _ConfirmOrderSuccessWithRepeatOrderState();
}

class _ConfirmOrderSuccessWithRepeatOrderState
    extends State<ConfirmOrderSuccessWithRepeatOrder> {
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
          leading: AppBarBackButtonCross(),
          elevation: 1,
          centerTitle: true,
          title: CustomText('ORDER CONFIRMED',
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500),
        ),
        body: buildBody());
  }

  Widget buildBody() {
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
    return Column(
      children: [
        Container(
          alignment: Alignment.center,
          child: Icon(
            Icons.lock,
            size: 80,
            color: Util.greenishColor(),
          ),
        ),
        SizedBox(height: 30),
        Container(
          child: CustomText('Your invoice is confirmed',
              color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 17),
        ),
        SizedBox(height: 30),
        Container(
          alignment: Alignment.center,
          child: CustomText('You can also get this order on a regular basis',
              textAlign: TextAlign.center, color: Colors.grey),
        ),
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
    isProcessing = true;
    refreshUI();

    Tuple2<void, String> allowRepeatOrderResponse = await OrderRepo.instance
        .allowRepeatOrder(
            orderId: widget.orderId,
            dayInterval: selectedDeliveryDayInterval,
            deliveryTime: selectedDeliveryTimeTime);

    if (allowRepeatOrderResponse.item2 == ClientEnum.RESPONSE_SUCCESS) {
      Util.showSnackBar(
          scaffoldKey: _scaffoldKey,
          message:
              "You will receive this order every ${selectedDeliveryDayInterval} day(s) interval",
          duration: 3000);
      await Future.delayed(Duration(milliseconds: 3000));
      Navigator.of(context).pop();
    } else {
      Util.showSnackBar(
          scaffoldKey: _scaffoldKey,
          message: "Something went wrong. Please try again.",
          duration: 1500);
    }
    isProcessing = false;
    refreshUI();
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
