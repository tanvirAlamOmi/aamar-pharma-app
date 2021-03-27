import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pharmacy_app/src/component/general/common_ui.dart';
import 'package:pharmacy_app/src/models/notification.dart';
import 'package:pharmacy_app/src/models/order/order.dart';
import 'package:pharmacy_app/src/util/en_bn_dict.dart';
import 'package:pharmacy_app/src/util/util.dart';
import 'package:pharmacy_app/src/pages/notification_to_order_page.dart';

class OrderInvoiceAddressCard extends StatelessWidget {
  final Order order;
  OrderInvoiceAddressCard({Key key, this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Util.removeFocusNode(context),
      child: Container(
        padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
        width: double.infinity,
        child: Material(
          shadowColor: Colors.grey[100].withOpacity(0.4),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(0.0)),
          elevation: 0,
          clipBehavior: Clip.antiAlias, // Add This
          child: buildBody(context),
        ),
      ),
    );
  }

  Widget buildBody(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        buildFirstCol(context),
        buildSecondCol(context),
        buildThirdCol(context),
      ],
    );
  }

  Widget buildThirdCol(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Column(
      children: [
        Container(
          width: size.width / 3 - 20,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                alignment: Alignment.centerLeft,
                child: CustomText(
                  'INVOICE TOTAL',
                  color: Util.purplishColor(),
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
              SizedBox(height: 2),
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  '৳' + EnBnDict.en_bn_number_convert(number: order.grandTotal),
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                      fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildSecondCol(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Column(
      children: [
        Container(
          width: size.width / 3 - 20,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                alignment: Alignment.centerLeft,
                child: CustomText(
                  'Billed to',
                  color: Util.purplishColor(),
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  order.deliveryAddressDetails.address,
                  style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.normal,
                      fontSize: 11),
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  order.deliveryAddressDetails.area,
                  style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.normal,
                      fontSize: 11),
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  order.mobileNo,
                  style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.normal,
                      fontSize: 11),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget buildFirstCol(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Column(
      children: [
        Container(
          width: size.width / 3 - 20,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                alignment: Alignment.centerLeft,
                child: CustomText(
                  'Invoice Number',
                  color: Util.purplishColor(),
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
              SizedBox(height: 2),
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  EnBnDict.en_bn_number_convert(number: order.id),
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                      fontSize: 11),
                ),
              ),
              SizedBox(height: 5),
              Container(
                alignment: Alignment.centerLeft,
                child: CustomText(
                  'Date Of Issue',
                  color: Util.purplishColor(),
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
              SizedBox(height: 2),
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  EnBnDict.en_bn_number_convert(
                      number: Util.formatDateToDD_MM_YY(order.deliveryDate)),
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                      fontSize: 11),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
