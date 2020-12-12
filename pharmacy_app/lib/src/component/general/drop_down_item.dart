import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pharmacy_app/src/component/buttons/circle_cross_button.dart';
import 'package:pharmacy_app/src/component/cards/homepage_slider_single_card.dart';
import 'package:pharmacy_app/src/models/order/deliver_address_details.dart';
import 'package:pharmacy_app/src/store/store.dart';
import 'package:pharmacy_app/src/util/util.dart';

class DropDownItem extends StatelessWidget {
  final List<dynamic> dropDownList;
  final dynamic selectedItem;
  final Function() callBackRefreshUI;
  final Function(dynamic value) setSelectedItem;
  final Function() callBackAdditional;

  const DropDownItem(
      {Key key,
      this.callBackRefreshUI,
      this.dropDownList,
      this.selectedItem,
      this.setSelectedItem,
      this.callBackAdditional})
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
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1, color: Colors.black),
            ),
            color: Colors.transparent,
          ),
          height: 35,
          child: DropdownButtonHideUnderline(
            child: DropdownButton<dynamic>(
              dropdownColor: const Color.fromARGB(255, 45, 65, 89),
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
            child: Text(
              menuItem,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}
