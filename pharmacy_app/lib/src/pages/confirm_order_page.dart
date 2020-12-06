import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pharmacy_app/src/component/cards/homepage_slider_single_card.dart';
import 'package:pharmacy_app/src/component/general/app_bar_back_button.dart';
import 'package:pharmacy_app/src/component/general/drawerUI.dart';
import 'package:pharmacy_app/src/util/util.dart';
import 'package:tuple/tuple.dart';
import 'package:pharmacy_app/src/component/cards/carousel_slider_card.dart';
import 'package:pharmacy_app/src/component/buttons/general_action_button.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pharmacy_app/src/pages/upload_prescription_verify_page.dart';

class ConfirmOrderPage extends StatefulWidget {
  final String note;
  final PickedFile prescriptionImageFile;
  ConfirmOrderPage({this.note, this.prescriptionImageFile, Key key}) : super(key: key);

  @override
  _ConfirmOrderPageState createState() => _ConfirmOrderPageState();
}

class _ConfirmOrderPageState extends State<ConfirmOrderPage> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool isProcessing = false;
  PickedFile pickedImageFile;

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
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          elevation: 1,
          centerTitle: true,
          leading: AppBarBackButton(),
          title: Text(
            'CONFIRM ORDER',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: buildBody(context));
  }

  Widget buildBody(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[],
      ),
    );
  }

  Widget buildDeliveryTime() {
    return Container(
      padding: EdgeInsets.only(top: 20),
      child: Text(
        "ORDER MEDICINES AND MORE",
        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget buildHotlineText() {
    return Container(
      padding: EdgeInsets.only(top: 20),
      child: Text(
        "HOTLINE\n"
        "+88-0126823410",
        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }


  pushRouteToUploadPrescriptionPage(PickedFile pickedPrescriptionImage) {

    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => UploadPrescriptionVerifyPage(
                prescriptionImageFile: pickedPrescriptionImage,
              )),
    );
  }

  void refreshUI() {
    if (mounted) setState(() {});
  }
}
