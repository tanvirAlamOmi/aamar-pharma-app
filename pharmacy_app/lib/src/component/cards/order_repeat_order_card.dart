import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pharmacy_app/src/component/buttons/circle_cross_button.dart';
import 'package:pharmacy_app/src/component/buttons/time_choose_button.dart';
import 'package:pharmacy_app/src/component/cards/homepage_slider_single_card.dart';
import 'package:pharmacy_app/src/component/general/common_ui.dart';
import 'package:pharmacy_app/src/component/general/drop_down_item.dart';
import 'package:pharmacy_app/src/models/order/deliver_address_details.dart';
import 'package:pharmacy_app/src/store/store.dart';
import 'package:pharmacy_app/src/util/util.dart';

class OrderRepeatOrderCard extends StatelessWidget {
  final Function() callBackRefreshUI;

  final bool checkedRepeatOrder;
  final Function(dynamic value) setRepeatOrder;

  final Function(dynamic value) setRepeatDeliveryLongGap;
  final List<String> repeatDeliveryLongGap;
  final String selectedRepeatDeliveryLongGap;

  final Function(dynamic value) setSelectedRepeatDeliveryDayBar;
  final List<String> repeatDeliveryDayBar;
  final String selectedRepeatDeliveryDayBar;

  final DateTime selectedRepeatDeliveryTime;
  final Function(DateTime value) setSelectedRepeatDeliveryTime;

  const OrderRepeatOrderCard(
      {Key key,
      this.callBackRefreshUI,
      this.repeatDeliveryDayBar,
      this.selectedRepeatDeliveryDayBar,
      this.setSelectedRepeatDeliveryDayBar,
      this.setRepeatDeliveryLongGap,
      this.repeatDeliveryLongGap,
      this.selectedRepeatDeliveryLongGap,
      this.checkedRepeatOrder,
      this.setRepeatOrder,
      this.selectedRepeatDeliveryTime,
      this.setSelectedRepeatDeliveryTime})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: Material(
        shadowColor: Colors.grey[100].withOpacity(0.4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0.0)),
        elevation: 0,
        clipBehavior: Clip.antiAlias,
        // Add This
        child: buildBody(context),
      ),
    );
  }

  Widget buildBody(BuildContext context) {
    return buildRepeatOrderWithDropDown(context);
  }

  Widget buildRepeatOrderWithDropDown(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(30, 7, 30, 7),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CustomText('Every',
                  fontWeight: FontWeight.bold, color: Util.purplishColor()),
              DropDownItem(
                dropDownList: repeatDeliveryLongGap,
                selectedItem: selectedRepeatDeliveryLongGap,
                setSelectedItem: setRepeatDeliveryLongGap,
                callBackRefreshUI: callBackRefreshUI,
              ),
            ],
          ),
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
                    CustomText('Day',
                        fontWeight: FontWeight.bold,
                        color: Util.purplishColor()),
                    SizedBox(height: 1),
                    DropDownItem(
                      dropDownList: repeatDeliveryDayBar,
                      selectedItem: selectedRepeatDeliveryDayBar,
                      setSelectedItem: setSelectedRepeatDeliveryDayBar,
                      callBackRefreshUI: callBackRefreshUI,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 30),
            Expanded(
              child: TimeChooseButton(
                  callBackRefreshUI: callBackRefreshUI,
                  selectedTime: selectedRepeatDeliveryTime,
                  setSelectedTime: setSelectedRepeatDeliveryTime),
            )
          ],
        )
      ],
    );
  }
}
