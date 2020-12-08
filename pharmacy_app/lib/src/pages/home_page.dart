import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
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
    return SingleChildScrollView(
      child: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            CarouselSliderCard(),
            buildText(),
            SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildContainer("UPLOAD PRESCRIPTION/ PHOTO",
                    Icon(Icons.add_shopping_cart), uploadPrescriptionOption),
                SizedBox(width: 10),
                buildContainer("ADD ITEMS MANUALLY",
                    Icon(Icons.add_shopping_cart), navigateToAddItems)
              ],
            ),
            SizedBox(height: 20),
            buildHotlineText(),
            SizedBox(height: 20),
          ],
        ),
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

  Widget buildContainer(String title, Icon icon, Function() callBack) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: callBack,
      child: Container(
        height: 200,
        width: size.width / 2 - 20,
        child: Material(
          shadowColor: Colors.grey[100].withOpacity(0.4),
          color: Colors.blueAccent,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          elevation: 3,
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icon,
              SizedBox(height: 10),
              Container(
                  width: 100,
                  height: 50,
                  child: Text(
                    title,
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ))
            ],
          ),
        ),
      ),
    );
  }

  Widget buildHotlineText() {
    final size = MediaQuery.of(context).size;
    return Container(
      alignment: Alignment.center,
      width: size.width - 20,
      height: 70,
      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: Material(
        shadowColor: Colors.grey[100].withOpacity(0.4),
        color: Colors.white,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        elevation: 3,
        clipBehavior: Clip.antiAlias, // Add This
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              color: Colors.blueAccent,
              width: 70,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_call),
                  Text(
                    "CALL US",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            SizedBox(width: 50),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "ORDER DELIVERY TIME",
                  style:
                      TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                Text(
                  "10 AM TO 10 PM",
                  style:
                      TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                )
              ],
            )
          ],
        ),
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
      try {
        List<Asset> resultList = List<Asset>();
        final List<Uint8List> prescriptionImageFileList = new List();

        resultList = await MultiImagePicker.pickImages(
          maxImages: 10,
          enableCamera: true,
          cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
          materialOptions: MaterialOptions(
            actionBarColor: "#000000",
            actionBarTitle: "Amar Pharma",
            allViewTitle: "All Photos",
            useDetailsView: false,
            selectCircleStrokeColor: "#000000",
          ),
        );

        for (int i = 0; i < resultList.length; i++) {
          prescriptionImageFileList.add(convertToUIntListFromByTeData(
              await resultList[i].getByteData(quality: 100)));
        }

        navigateToUploadPrescriptionPage(prescriptionImageFileList);
      } catch (e) {}
    }
  }

  Uint8List convertToUIntListFromByTeData(ByteData imageBinaryData) {
    Uint8List imageData = imageBinaryData.buffer.asUint8List(
        imageBinaryData.offsetInBytes, imageBinaryData.lengthInBytes);
    return imageData;
  }

  navigateToUploadPrescriptionPage(List<Uint8List> prescriptionImageFileList ) {
    if (prescriptionImageFileList.length == 0) return;
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => UploadPrescriptionVerifyPage(
            prescriptionImageFileList: prescriptionImageFileList,
              )),
    );
  }

  navigateToAddItems() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddItemsPage()),
    );
  }

  void refreshUI() {
    if (mounted) setState(() {});
  }
}
