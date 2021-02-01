import 'package:flutter/material.dart';
import 'package:pharmacy_app/src/component/general/common_ui.dart';
import 'package:pharmacy_app/src/pages/add_new_address.dart';
import 'package:pharmacy_app/src/util/en_bn_dict.dart';
import 'package:pharmacy_app/src/util/util.dart';

class AddDeliveryAddressButton extends StatelessWidget {
  final Function() callBack;
  AddDeliveryAddressButton({this.callBack, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(28, 10, 28, 10),
      child: Material(
        shadowColor: Colors.grey[100].withOpacity(0.4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0.0)),
        elevation: 5,
        clipBehavior: Clip.antiAlias, // Add This
        child: buildBody(context),
      ),
    );
  }

  Widget buildBody(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => AddNewAddressPage(
                    callBack: callBack,
                  )),
        );
      },
      title: CustomText('Add New Address',
          fontWeight: FontWeight.bold, fontSize: 12),
      trailing: Icon(Icons.keyboard_arrow_right),
    );
  }
}
