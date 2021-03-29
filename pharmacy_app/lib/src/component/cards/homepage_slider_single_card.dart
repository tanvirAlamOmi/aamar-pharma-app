import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pharmacy_app/src/component/general/common_ui.dart';
import 'package:pharmacy_app/src/models/general/ui_view_data.dart';
import 'package:pharmacy_app/src/util/util.dart';

class HomePageSliderSingleCard extends StatelessWidget {
  final UIViewData uiViewData;

  const HomePageSliderSingleCard({Key key, this.uiViewData}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      color: Colors.transparent,
      child: Material(
        shadowColor: Colors.grey[100].withOpacity(0.4),
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        elevation: 0,
        clipBehavior: Clip.antiAlias, // Add This
        child: Container(
          width: double.infinity,
          alignment: Alignment.center,
          child: Image.asset(
            uiViewData.imageUrl,
            width: size.width - 10,
            height: 200,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
