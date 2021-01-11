import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pharmacy_app/src/models/feed/feed_item.dart';
import 'package:pharmacy_app/src/models/general/Enum_Data.dart';
import 'package:pharmacy_app/src/component/general/drop_down_item.dart';
import 'package:pharmacy_app/src/util/util.dart';
import 'package:pharmacy_app/src/store/store.dart';

class DropDownFilterCard extends StatelessWidget {
  final List<FeedItem> feedItems;
  final List<FeedItem> feedItemsPermData;
  final Function callBack;
  final TextEditingController searchController = new TextEditingController();
  final List<String> orderFilterStatusList = [
    ClientEnum.ORDER_STATUS_ALL,
    ClientEnum.ORDER_STATUS_PENDING_INVOICE_RESPONSE_FROM_PHARMA,
    ClientEnum.ORDER_STATUS_PENDING_INVOICE_RESPONSE_FROM_CUSTOMER,
    ClientEnum.ORDER_STATUS_INVOICE_CONFIRM_FROM_CUSTOMER,
    ClientEnum.ORDER_STATUS_PROCESSING,
    ClientEnum.ORDER_STATUS_ON_THE_WAY,
    ClientEnum.ORDER_STATUS_DELIVERED,
    ClientEnum.ORDER_STATUS_CANCELED,
    ClientEnum.ORDER_STATUS_REJECTED
  ];
  String selectedOrderFilterStatus;

  DropDownFilterCard(
      {Key key, this.feedItems, this.feedItemsPermData, this.callBack}) {
    selectedOrderFilterStatus = Store.instance.appState.orderFilterStatus;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(25, 10, 25, 10),
      width: double.infinity,
      child: Material(
        shadowColor: Colors.grey[100].withOpacity(0.4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2.0)),
        elevation: 0,
        clipBehavior: Clip.antiAlias, // Add This
        child: buildDropDownList(),
      ),
    );
  }

  Widget buildDropDownList() {
    return DropDownItem(
      dropDownList: orderFilterStatusList,
      selectedItem: selectedOrderFilterStatus,
      setSelectedItem: updateFeedItemListOnFilter,
      callBackRefreshUI: callBack,
      height: 50,
      boxDecoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        color: Util.greenishColor(),
      ),
      dropDownContainerColor: Util.greenishColor(),
      dropDownTextColor: Colors.white,
      padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
    );
  }

  updateFeedItemListOnFilter(dynamic value) {
    if (value == orderFilterStatusList[0]) {
      feedItems.clear();
      feedItems.addAll(feedItemsPermData);
    } else {
      // Preserve the Filter Card
      feedItems.removeRange(1, feedItems.length);
      for (final singleItem in feedItemsPermData) {
        if (value == singleItem?.order?.orderStatus) {
          feedItems.add(singleItem);
        }
      }
    }
    Store.instance.appState.orderFilterStatus = value;
  }
}
