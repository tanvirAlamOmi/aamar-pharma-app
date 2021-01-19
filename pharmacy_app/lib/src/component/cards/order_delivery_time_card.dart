import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pharmacy_app/src/component/buttons/circle_cross_button.dart';
import 'package:pharmacy_app/src/component/cards/homepage_slider_single_card.dart';
import 'package:pharmacy_app/src/component/general/drop_down_item.dart';
import 'package:pharmacy_app/src/models/order/deliver_address_details.dart';
import 'package:pharmacy_app/src/store/store.dart';
import 'package:pharmacy_app/src/util/util.dart';

class OrderDeliveryAddressCard extends StatelessWidget {
  final Function() callBackRefreshUI;

  final Function(dynamic value) setSelectedDeliveryTimeDay;
  final List<String> deliveryTimeDay;
  final String selectedDeliveryTimeDay;

  final Function(dynamic value) setSelectedDeliveryTimeTime;
  final List<String> deliveryTimeTime;
  final String selectedDeliveryTimeTime;

  const OrderDeliveryAddressCard(
      {Key key,
      this.callBackRefreshUI,
      this.deliveryTimeTime,
      this.selectedDeliveryTimeTime,
      this.setSelectedDeliveryTimeTime,
      this.setSelectedDeliveryTimeDay,
      this.deliveryTimeDay,
      this.selectedDeliveryTimeDay})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
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
    return Container(
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            "DELIVERY TIME (EVERYDAY 10 AM TO 10 PM)",
            style: TextStyle(
                fontWeight: FontWeight.bold, color: Util.greenishColor()),
          ),
          SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Day",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Util.purplishColor()),
                    ),
                    DropDownItem(
                      dropDownList: deliveryTimeDay,
                      selectedItem: selectedDeliveryTimeDay,
                      setSelectedItem: setSelectedDeliveryTimeDay,
                      callBackRefreshUI: callBackRefreshUI,
                    ),
                  ],
                ),
              ),
              SizedBox(width: 30),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Time",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Util.purplishColor()),
                    ),
                    DropDownItem(
                        dropDownList: deliveryTimeTime,
                        selectedItem: selectedDeliveryTimeTime,
                        setSelectedItem: setSelectedDeliveryTimeTime,
                        callBackRefreshUI: callBackRefreshUI),
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
