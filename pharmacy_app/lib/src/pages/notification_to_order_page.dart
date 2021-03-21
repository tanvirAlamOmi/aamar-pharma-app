import 'package:flutter/material.dart';
import 'package:pharmacy_app/src/component/buttons/general_action_round_button.dart';
import 'package:pharmacy_app/src/component/general/app_bar_back_button.dart';
import 'package:pharmacy_app/src/component/general/common_ui.dart';
import 'package:pharmacy_app/src/component/general/drop_down_item.dart';
import 'package:pharmacy_app/src/component/general/loading_widget.dart';
import 'package:pharmacy_app/src/models/general/Enum_Data.dart';
import 'package:pharmacy_app/src/models/order/deliver_address_details.dart';
import 'package:pharmacy_app/src/repo/delivery_repo.dart';
import 'package:pharmacy_app/src/util/en_bn_dict.dart';
import 'package:pharmacy_app/src/util/util.dart';
import 'package:tuple/tuple.dart';
import 'package:pharmacy_app/src/pages/notification_to_order_page.dart';
import '../models/general/Order_Enum.dart';
import '../models/notification.dart';
import '../models/order/order.dart';
import '../repo/order_repo.dart';
import 'confirm_invoice_page.dart';
import 'order_details_page.dart';
import 'order_final_invoice_page.dart';

class NotificationToOrderPage extends StatefulWidget {
  final NotificationItem notificationItem;
  NotificationToOrderPage({this.notificationItem, Key key}) : super(key: key);

  @override
  _NotificationToOrderPageState createState() =>
      _NotificationToOrderPageState();
}

class _NotificationToOrderPageState extends State<NotificationToOrderPage> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

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
    return GestureDetector(
      onTap: () => Util.removeFocusNode(context),
      child: Scaffold(
          key: _scaffoldKey,
          body: FutureBuilder(
              future: OrderRepo.instance
                  .singleOrder(orderId: widget.notificationItem.idOrder),
              builder: (_, snapshot) {
                if (snapshot.data == null) {
                  return Scaffold(
                      appBar: AppBar(
                        elevation: 1,
                        centerTitle: true,
                        leading: AppBarBackButton(),
                        title: CustomText('ORDER DETAILS',
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w500),
                      ),
                      body: LoadingWidget(status: "Loading Data"));
                } else if (snapshot.data != null) {
                  Tuple2<Order, String> singleOrderResponse = snapshot.data;

                  final Order order = singleOrderResponse.item1;
                  if (order == null)
                    return LoadingWidget(
                      status: "Error in getting Order Data",
                      displayRetry: true,
                    );
                  return navigateToSpecificPage(order: order);
                }
                return Scaffold(
                    appBar: AppBar(
                      elevation: 1,
                      centerTitle: true,
                      leading: AppBarBackButton(),
                      title: CustomText('ORDER DETAILS',
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w500),
                    ),
                    body: LoadingWidget(status: "Loading Data"));
              })),
    );
  }

  Widget navigateToSpecificPage({Order order}) {
    if (order.status == OrderEnum.ORDER_STATUS_PENDING) {
      return OrderDetailsPage(
        order: order,
        showRepeatOrderCancelButton: false,
      );
    }

    if (order.status == OrderEnum.ORDER_STATUS_INVOICE_SENT) {
      return ConfirmInvoicePage(order: order);
    }

    if (order.status == OrderEnum.ORDER_STATUS_CONFIRMED) {
      return OrderFinalInvoicePage(order: order);
    }

    if (order.status == OrderEnum.ORDER_STATUS_DELIVERED) {
      return OrderFinalInvoicePage(order: order);
    }

    if (order.status == OrderEnum.ORDER_STATUS_CANCELED) {
      return OrderDetailsPage(showRepeatOrderCancelButton: false, order: order);
    }

    return Scaffold(
        appBar: AppBar(
          elevation: 1,
          centerTitle: true,
          leading: AppBarBackButton(),
          title: CustomText('ORDER DETAILS',
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500),
        ),
        body: LoadingWidget(status: "Loading Data"));
  }

  void closePage() {
    Navigator.pop(context);
  }

  void refreshUI() {
    if (mounted) setState(() {});
  }
}
