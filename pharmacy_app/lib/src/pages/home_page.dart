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
import 'package:pharmacy_app/src/pages/add_items_page.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
        drawer: MainDrawer(),
        key: _scaffoldKey,
        appBar: AppBar(
          elevation: 1,
          centerTitle: true,
          title: Text(
            'HOME',
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
        children: <Widget>[
          CarouselSliderCard(),
          buildText(),
          GeneralActionButton(
              title: "UPLOAD PRESCRIPTION",
              callBack: uploadPrescriptionOption,
              isProcessing: isProcessing),
          GeneralActionButton(
              title: "ADD ITEMS MANUALLY",
              callBack: navigateToAddItems,
              isProcessing: isProcessing),
          SizedBox(height: 20),
          buildHotlineText()
        ],
      ),
    );
  }

  Widget buildText() {
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

  void uploadPrescriptionOption() async {
    isProcessing = true;
    refreshUI();

    var cameraStatus = await Permission.camera.status;
    var storageStatus = await Permission.storage.status;
    if (cameraStatus == PermissionStatus.permanentlyDenied ||
        storageStatus == PermissionStatus.permanentlyDenied) {
      Util.showSnackBar(
          scaffoldKey: _scaffoldKey,
          message:
              "Please provide Camera and Storage permissions from Settings");
      isProcessing = false;
      refreshUI();
    } else {
      Util.imagePickAlertDialog(
          context: context, callBack: navigateToUploadPrescriptionPage);
      isProcessing = false;
      refreshUI();
    }
  }

  navigateToUploadPrescriptionPage(PickedFile pickedPrescriptionImage) {
    if (pickedPrescriptionImage == null) return ;
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => UploadPrescriptionVerifyPage(
                prescriptionImageFile: pickedPrescriptionImage,
              )),
    );
  }

  navigateToAddItems() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => AddItemsPage(
          )),
    );
  }

  void refreshUI() {
    if (mounted) setState(() {});
  }
}
