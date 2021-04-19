import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pharmacy_app/src/component/general/common_ui.dart';
import 'package:pharmacy_app/src/models/general/App_Enum.dart';
import 'package:pharmacy_app/src/models/notification.dart';
import 'package:pharmacy_app/src/util/util.dart';
import 'package:pharmacy_app/src/pages/notification_to_order_page.dart';

class AamarPharmaAddressCard extends StatelessWidget {
  AamarPharmaAddressCard({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Util.removeFocusNode(context),
      child: Container(
        padding: EdgeInsets.fromLTRB(18, 10, 18, 0),
        width: double.infinity,
        child: Material(
          shadowColor: Colors.grey[100].withOpacity(0.4),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(0.0)),
          elevation: 5,
          clipBehavior: Clip.antiAlias, // Add This
          child: buildBody(context),
        ),
      ),
    );
  }

  Widget buildBody(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      color: Util.purplishColor(),
      child: Row(
        children: [
          Container(
            child: Image.asset(
              'assets/images/amar_pharma_small_logo.png',
              alignment: Alignment.center,
              fit: BoxFit.cover,
              width: 100.0,
              height: 70.0,
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
              width: size.width / 2 - 50,
              alignment: Alignment.centerRight,
              child: Text(
                "${AppEnum.HOTLINE_NUMBER}\n"
                "info@aamarpharma.com\n"
                "aamarpharma.com\n",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.normal,
                    fontSize: 11),
              ),
            ),
          )
        ],
      ),
    );
  }
}
