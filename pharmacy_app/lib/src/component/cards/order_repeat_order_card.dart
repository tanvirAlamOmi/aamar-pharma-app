import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pharmacy_app/src/component/buttons/circle_cross_button.dart';
import 'package:pharmacy_app/src/component/buttons/time_choose_button.dart';
import 'package:pharmacy_app/src/component/cards/homepage_slider_single_card.dart';
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
        child: buildBody(),
      ),
    );
  }

  Widget buildBody() {
    if (checkedRepeatOrder == false) return buildRepeatOrder();
    return buildRepeatOrderWithDropDown();
  }

  Widget buildRepeatOrder() {
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
        setRepeatOrder(newValue);
        callBackRefreshUI();
      },
      controlAffinity: ListTileControlAffinity.leading,
    );
  }

  Widget buildRepeatOrderWithDropDown() {
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
                  setRepeatOrder(newValue);
                  callBackRefreshUI();
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
                    DropDownItem(
                      dropDownList: repeatDeliveryLongGap,
                      selectedItem: selectedRepeatDeliveryLongGap,
                      setSelectedItem: setRepeatDeliveryLongGap,
                      callBackRefreshUI: callBackRefreshUI,
                    ),
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
