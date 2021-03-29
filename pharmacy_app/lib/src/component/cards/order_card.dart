import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pharmacy_app/src/models/general/Client_Enum.dart';
import 'package:pharmacy_app/src/models/general/App_Enum.dart';
import 'package:pharmacy_app/src/models/order/order.dart';
import 'package:pharmacy_app/src/util/en_bn_dict.dart';
import 'package:pharmacy_app/src/pages/confirm_invoice_page.dart';
import 'package:pharmacy_app/src/pages/order_details_page.dart';
import 'package:pharmacy_app/src/pages/order_final_invoice_page.dart';
import 'package:pharmacy_app/src/util/util.dart';
import 'package:pharmacy_app/src/store/store.dart';
import 'package:pharmacy_app/src/component/general/common_ui.dart';

class OrderCard extends StatefulWidget {
  final Order order;
  OrderCard({this.order, Key key}) : super(key: key);

  @override
  _OrderCardState createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  Order order;
  bool isProcessing = false;

  @override
  void initState() {
    super.initState();
    order = widget.order;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Util.removeFocusNode(context),
      child: Container(
        padding: EdgeInsets.fromLTRB(25, 10, 25, 10),
        width: double.infinity,
        child: Material(
          shadowColor: Colors.grey[100].withOpacity(0.4),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          elevation: 5,
          clipBehavior: Clip.antiAlias, // Add This
          child: buildBody(context),
        ),
      ),
    );
  }

  Widget buildBody(BuildContext context) {
    return Column(
      children: [
        buildTitle(),
        buildOrderStatus(),
      ],
    );
  }

  Widget buildTitle() {
    return GestureDetector(
      onTap: navigateToSpecificPage,
      child: Container(
        height: 90,
        color: Colors.white,
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    EnBnDict.en_bn_convert(text: 'Order ID: ') +
                        EnBnDict.en_bn_number_convert(number: order.id),
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold)),
                SizedBox(height: 5),
                Text(getDeliveryTimeText(),
                    style: TextStyle(
                        fontSize: 13,
                        color: new Color.fromARGB(255, 4, 72, 71)))
              ],
            ),
            Row(
              children: [
                Icon(Icons.chevron_right, size: 28.0),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget buildOrderStatus() {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      width: double.infinity,
      height: 35,
      child: RaisedButton(
        shape: Border.all(width: 1.0, color: Colors.transparent),
        onPressed: () {},
        child: CustomText(
          order.status.toUpperCase(),
          color: Colors.white,
          fontSize: 13,
          textAlign: TextAlign.center,
        ),
        color: getOrderStatusColor(),
      ),
    );
  }

  Color getOrderStatusColor() {
    switch (order.status) {
      case AppEnum.ORDER_STATUS_PENDING:
        return Util.purplishColor();
        break;

      case AppEnum.ORDER_STATUS_INVOICE_SENT:
        return Colors.orangeAccent;
        break;

      case AppEnum.ORDER_STATUS_CONFIRMED:
        return Util.greenishColor();
        break;

      case AppEnum.ORDER_STATUS_DELIVERED:
        return Util.colorFromHex('#72D67A');
        break;

      case AppEnum.ORDER_STATUS_CANCELED:
        return Util.colorFromHex('#FA5353');
        break;

      case AppEnum.ORDER_STATUS_REJECTED:
        return Util.colorFromHex('#FA0000');
        break;

      default:
        return Util.purplishColor();
        break;
    }
  }

  String getDeliveryTimeText() {
    if (Store.instance.appState.language == ClientEnum.LANGUAGE_ENGLISH) {
      return 'Delivery: ${Util.formatDateToDD_MM_YY(order.deliveryDate)} (${order.deliveryTime})';
    }
    return EnBnDict.en_bn_convert(text: 'Delivery: ') +
        EnBnDict.en_bn_number_convert(
            number: Util.formatDateToDD_MM_YY(order.deliveryDate)) +
        "(${EnBnDict.time_bn_convert_with_time_type(text: order.deliveryTime.split('-')[0]) + '-' + EnBnDict.time_bn_convert_with_time_type(text: order.deliveryTime.split('-')[1])}) ";
  }

  void navigateToSpecificPage() {
    switch (order.status) {
      case AppEnum.ORDER_STATUS_PENDING:
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => OrderDetailsPage(
                    order: order,
                    showRepeatOrderCancelButton: false,
                  )),
        );
        break;

      case AppEnum.ORDER_STATUS_INVOICE_SENT:
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ConfirmInvoicePage(order: order)),
        );
        break;

      case AppEnum.ORDER_STATUS_CONFIRMED:
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => OrderFinalInvoicePage(
                    order: order,
                    showReOrder: false,
                    showOrderDetails: true,
                    showDoneButton: false,
                  )),
        );
        break;

      case AppEnum.ORDER_STATUS_DELIVERED:
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => OrderFinalInvoicePage(
                    order: order,
                    showReOrder: true,
                    showOrderDetails: true,
                    showDoneButton: false,
                  )),
        );
        break;

      case AppEnum.ORDER_STATUS_CANCELED:
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => OrderDetailsPage(
                  showRepeatOrderCancelButton: false, order: order)),
        );
        break;

      case AppEnum.ORDER_STATUS_REJECTED:
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => OrderDetailsPage(
                  showRepeatOrderCancelButton: false, order: order)),
        );
        break;

      default:
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => OrderDetailsPage(
                  showRepeatOrderCancelButton: false, order: order)),
        );
        break;
    }
  }

  void refreshUI() {
    if (mounted) setState(() {});
  }
}
