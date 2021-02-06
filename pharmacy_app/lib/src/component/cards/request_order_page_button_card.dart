import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pharmacy_app/src/component/buttons/general_action_button.dart';
import 'package:pharmacy_app/src/component/buttons/general_action_round_button.dart';
import 'package:pharmacy_app/src/models/feed/feed_item.dart';
import 'package:pharmacy_app/src/models/general/Enum_Data.dart';
import 'package:pharmacy_app/src/component/general/drop_down_item.dart';
import 'package:pharmacy_app/src/models/general/Order_Enum.dart';
import 'package:pharmacy_app/src/models/states/app_vary_states.dart';
import 'package:pharmacy_app/src/pages/special_request_product_page.dart';
import 'package:pharmacy_app/src/util/util.dart';
import 'package:pharmacy_app/src/store/store.dart';

class RequestOrderPageButtonCard extends StatelessWidget {
  RequestOrderPageButtonCard({Key key}) : super(key: key);

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
        child: GeneralActionRoundButton(
          title: "SUBMIT",
          height: 40,
          isProcessing: false,
          callBackOnSubmit: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SpecialRequestProductPage()),
            );
          },
        ),
      ),
    );
  }
}
