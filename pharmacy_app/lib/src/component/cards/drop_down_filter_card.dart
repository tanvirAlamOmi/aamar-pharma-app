import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pharmacy_app/src/models/feed/feed_item.dart';
import 'package:pharmacy_app/src/models/general/Enum_Data.dart';
import 'package:pharmacy_app/src/component/general/drop_down_item.dart';

class DropDownFilterCard extends StatefulWidget {
  final List<FeedItem> feedItems;
  final List<FeedItem> feedItemsPermData;
  final Function callBack;

  DropDownFilterCard(
      {this.feedItems, this.feedItemsPermData, this.callBack, Key key})
      : super(key: key);

  @override
  _DropDownFilterCardState createState() => _DropDownFilterCardState();
}

class _DropDownFilterCardState extends State<DropDownFilterCard> {
  final TextEditingController searchController = new TextEditingController();
  List<String> orderFilterStatusList = [
    "ALL",
    ClientEnum.ORDER_STATUS_PENDING_INVOICE_RESPONSE_FROM_PHARMA,
    ClientEnum.ORDER_STATUS_PENDING_INVOICE_RESPONSE_FROM_CUSTOMER,
    ClientEnum.ORDER_STATUS_INVOICE_CONFIRM_FROM_CUSTOMER,
    ClientEnum.ORDER_STATUS_PROCESSING,
    ClientEnum.ORDER_STATUS_ON_THE_WAY,
    ClientEnum.ORDER_STATUS_DELIVERED,
    ClientEnum.ORDER_STATUS_CANCELED,
    ClientEnum.ORDER_STATUS_REJECTED
  ];
  String selectedOrderFilterStatus = "ALL";

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(25, 10, 25, 10),
      width: double.infinity,
      child: Material(
        shadowColor: Colors.grey[100].withOpacity(0.4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2.0)),
        elevation: 3,
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
      callBackRefreshUI: refreshUI,
    );
  }

  updateFeedItemListOnFilter(dynamic value) {
    selectedOrderFilterStatus = value;
    if (value == "ALL") {
      widget.feedItems.clear();
      widget.feedItems.addAll(widget.feedItemsPermData);
    } else {
      // Preserve the Filter Card
      widget.feedItems.removeRange(1, widget.feedItems.length);
      for (final singleItem in widget.feedItemsPermData) {
        if (value == singleItem?.order?.orderStatus) {
          widget.feedItems.add(singleItem);
        }
      }
    }
    widget.callBack();
  }

  void refreshUI() {
    if (mounted) setState(() {});
  }
}
