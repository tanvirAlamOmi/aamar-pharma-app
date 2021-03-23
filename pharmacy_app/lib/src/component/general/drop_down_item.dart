import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pharmacy_app/src/component/buttons/circle_cross_button.dart';
import 'package:pharmacy_app/src/component/cards/homepage_slider_single_card.dart';
import 'package:pharmacy_app/src/models/general/Client_Enum.dart';
import 'package:pharmacy_app/src/models/order/deliver_address_details.dart';
import 'package:pharmacy_app/src/store/store.dart';
import 'package:pharmacy_app/src/util/en_bn_dict.dart';
import 'package:pharmacy_app/src/util/util.dart';

import 'common_ui.dart';

class DropDownItem extends StatelessWidget {
  final List<dynamic> dropDownList;
  final dynamic selectedItem;
  final Function() callBackRefreshUI;
  final Function(dynamic value) setSelectedItem;
  final Function() callBackAdditional;
  final BoxDecoration boxDecoration;
  final double height;
  final Color dropDownContainerColor;
  final Color dropDownTextColor;
  final EdgeInsets padding;
  final double iconSize;
  final Color iconColor;

  const DropDownItem(
      {Key key,
      this.callBackRefreshUI,
      this.dropDownList,
      this.selectedItem,
      this.setSelectedItem,
      this.callBackAdditional,
      this.boxDecoration,
      this.height,
      this.dropDownContainerColor,
      this.dropDownTextColor,
      this.padding,
      this.iconSize,
      this.iconColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return buildDropdown();
  }

  Widget buildDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Container(
          alignment: Alignment.center,
          padding: padding ?? EdgeInsets.all(0),
          decoration: boxDecoration ??
              BoxDecoration(
                border: Border(
                  bottom: BorderSide(width: 1, color: Colors.black),
                ),
                color: Colors.transparent,
              ),
          height: height ?? 35,
          child: DropdownButtonHideUnderline(
            child: DropdownButton<dynamic>(
              iconSize: iconSize ?? 26,
              iconEnabledColor: iconColor ?? Util.greenishColor(),
              dropdownColor: dropDownContainerColor ??
                  const Color.fromARGB(255, 45, 65, 89),
              isDense: true,
              isExpanded: true,
              value: selectedItem,
              onChanged: (value) {
                if (value == null) return;
                setSelectedItem(value);
                callBackRefreshUI();
                if (callBackAdditional != null) {
                  callBackAdditional();
                }
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
            child: CustomText(processEnBn(text: menuItem),
                textAlign: TextAlign.start,
                overflow: TextOverflow.ellipsis,
                color: dropDownTextColor ?? Colors.grey,
                fontSize: 15),
          ),
        ],
      ),
    );
  }

  String processEnBn({String text}) {
    if (Store.instance.appState.language == ClientEnum.LANGUAGE_ENGLISH) {
      return text;
    }
    if (text.contains('PM') || text.contains('AM')) {
      final String timeDeliveryStartHour = text.split('-')[0];
      final String timeDeliveryEndHour = text.split('-')[1];

      final String timeDeliveryScheduleInBangla =
          EnBnDict.time_bn_convert_with_time_type(text: timeDeliveryStartHour) +
              '-' +
              EnBnDict.time_bn_convert_with_time_type(
                  text: timeDeliveryEndHour);

      return timeDeliveryScheduleInBangla;
    }
    return text;
  }
}
