import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pharmacy_app/src/models/general/Client_Enum.dart';
import 'package:pharmacy_app/src/models/general/App_Enum.dart';
import 'package:pharmacy_app/src/models/order/order.dart';
import 'package:pharmacy_app/src/models/states/ui_state.dart';
import 'package:pharmacy_app/src/pages/confirm_invoice_page.dart';
import 'package:pharmacy_app/src/pages/order_details_page.dart';
import 'package:pharmacy_app/src/util/en_bn_dict.dart';
import 'package:pharmacy_app/src/util/util.dart';

class RepeatOrderCard extends StatefulWidget {
  final Order order;
  RepeatOrderCard({this.order, Key key}) : super(key: key);

  @override
  _RepeatOrderCardState createState() => _RepeatOrderCardState();
}

class _RepeatOrderCardState extends State<RepeatOrderCard> {
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
        buildNextDeliveryDate(),
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
                Text(
                    EnBnDict.en_bn_convert(text: 'Every') +
                        ' ' +
                        EnBnDict.en_bn_number_convert(number: order.every) +
                        ' ' +
                        EnBnDict.en_bn_convert(text: 'Day(s)') +
                        ', ' +
                        EnBnDict.time_bn_convert_with_time_type(
                            text: order.time),
                    style: TextStyle(color: new Color.fromARGB(255, 4, 72, 71)))
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

  Widget buildNextDeliveryDate() {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      width: double.infinity,
      height: 35,
      child: RaisedButton(
        shape: Border.all(width: 1.0, color: Colors.transparent),
        onPressed: () {},
        child: Text(
          EnBnDict.en_bn_convert(text: 'NEXT DELIVERY ON') +
              ' - ' +
              EnBnDict.en_bn_number_convert(
                  number: Util.formatDateToDD_MM_YY(order.nextOrderDay)),
          style: TextStyle(color: Colors.white, fontSize: 12),
          textAlign: TextAlign.center,
        ),
        color: Util.purplishColor(),
      ),
    );
  }

  void navigateToSpecificPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => OrderDetailsPage(
                order: order,
                showRepeatOrderCancelButton: true,
              )),
    );
  }

  void refreshUI() {
    if (mounted) setState(() {});
  }
}
