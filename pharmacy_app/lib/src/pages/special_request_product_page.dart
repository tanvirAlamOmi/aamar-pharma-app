import 'dart:io';
import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
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
import 'package:pharmacy_app/src/component/buttons/general_action_round_button.dart';
import 'package:pharmacy_app/src/component/buttons/general_action_button.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pharmacy_app/src/pages/confirm_order_page.dart';
import 'package:pharmacy_app/src/models/order/order_manual_item.dart';
import 'package:pharmacy_app/src/util/util.dart';
import 'package:pharmacy_app/src/component/buttons/circle_cross_button.dart';

class SpecialRequestProductPage extends StatefulWidget {
  SpecialRequestProductPage({Key key}) : super(key: key);

  @override
  _SpecialRequestProductPageState createState() =>
      _SpecialRequestProductPageState();
}

class _SpecialRequestProductPageState extends State<SpecialRequestProductPage> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final TextEditingController itemNameController = new TextEditingController();

  final TextEditingController itemQuantityController =
      new TextEditingController();
  final TextEditingController noteController = new TextEditingController();

  Uint8List imageData;

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
    return GestureDetector(
      onTap: () => Util.removeFocusNode(context),
      child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            elevation: 1,
            centerTitle: true,
            leading: AppBarBackButton(),
            title: Text(
              Util.en_bn_du(text: 'REQUEST PRODUCT'),
              style:
                  TextStyle(fontFamily: Util.en_bn_font(), color: Colors.white),
            ),
          ),
          body: buildBody(context)),
    );
  }

  Widget buildBody(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          SizedBox(height: 10),
          buildPickImageWidget(),
          SizedBox(height: 10),
          buildProductNameInputWidget(),
          SizedBox(height: 10),
          buildProductQuantityInputWidget(),
          SizedBox(height: 10),
          buildNoteInputWidget(),
          buildSubmitButton()
        ],
      ),
    );
  }

  Widget buildPickImageWidget() {
    return GestureDetector(
      onTap: pickSpecialRequestProductImage,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(27, 7, 27, 7),
        child: Container(
          height: 75,
          width: double.infinity,
          child: Material(
            color: Util.greenishColor(),
            shape: RoundedRectangleBorder(
                side: const BorderSide(color: Colors.transparent, width: 0.5),
                borderRadius: BorderRadius.circular(10.0)),
            child: Row(
              children: [
                (imageData == null)
                    ? Container()
                    : Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: 60,
                          height: 80,
                          alignment: Alignment.center,
                          child: Image.memory(
                            imageData,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.image,
                        color: Colors.white,
                        size: 20,
                      ),
                      SizedBox(height: 3),
                      Text(
                        Util.en_bn_du(text: 'ADD PHOTO'),
                        style: TextStyle(
                            fontFamily: Util.en_bn_font(),
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildProductNameInputWidget() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(27, 7, 27, 7),
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(Util.en_bn_du(text: 'Item Name'),
                style: TextStyle(
                    fontFamily: Util.en_bn_font(),
                    fontWeight: FontWeight.bold,
                    color: Util.purplishColor())),
            SizedBox(height: 3),
            SizedBox(
              height: 35, // set this
              child: TextField(
                controller: itemNameController,
                decoration: new InputDecoration(
                  isDense: true,
                  hintText: "Napa, Astesin",
                  hintStyle: TextStyle(fontSize: 13),
                  fillColor: Colors.white,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildProductQuantityInputWidget() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(27, 7, 27, 7),
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(Util.en_bn_du(text: 'Quantity'),
                style: TextStyle(
                    fontFamily: Util.en_bn_font(),
                    fontWeight: FontWeight.bold,
                    color: Util.purplishColor())),
            SizedBox(height: 3),
            SizedBox(
              height: 35, // set this
              child: TextField(
                controller: itemQuantityController,
                decoration: new InputDecoration(
                  isDense: true,
                  hintText: "20",
                  hintStyle: TextStyle(fontSize: 13),
                  fillColor: Colors.white,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildNoteInputWidget() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(27, 7, 27, 7),
      child: Container(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              Util.en_bn_du(text: 'Add Notes'),
              style: TextStyle(
                  fontFamily: Util.en_bn_font(),
                  color: Util.purplishColor(),
                  fontSize: 12,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            TextFormField(
              autofocus: false,
              controller: noteController,
              maxLines: 3,
              style: new TextStyle(
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                  fontSize: 15),
              decoration: new InputDecoration(
                hintText: "Notes e.g. I need all the medicines",
                hintStyle: TextStyle(fontSize: 13),
                fillColor: Colors.white,
                border: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(10.0),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildSubmitButton() {
    return GeneralActionRoundButton(
      title: "SUBMIT",
      height: 40,
      isProcessing: false,
      callBackOnSubmit: proceedToConfirmOrderPage,
    );
  }

  void pickSpecialRequestProductImage() async {
    var cameraStatus = await Permission.camera.status;
    var storageStatus = await Permission.storage.status;
    if (cameraStatus == PermissionStatus.permanentlyDenied ||
        storageStatus == PermissionStatus.permanentlyDenied) {
      Util.showSnackBar(
          scaffoldKey: _scaffoldKey,
          message:
              "Please provide Camera and Storage permissions from Settings");
      refreshUI();
    } else {
      try {
        List<Asset> resultList = List<Asset>();
        final List<Uint8List> prescriptionImageFileList = new List();

        resultList = await MultiImagePicker.pickImages(
          maxImages: 1,
          enableCamera: true,
          cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
          materialOptions: MaterialOptions(
            actionBarColor: "#473FA8",
            actionBarTitle: "Amar Pharma",
            allViewTitle: "All Photos",
            useDetailsView: false,
            selectCircleStrokeColor: "#000000",
          ),
        );

        imageData = Util.convertToUIntListFromByTeData(
            await resultList[0].getByteData(quality: 100));

        refreshUI();
      } catch (e) {}
    }
  }

  void proceedToConfirmOrderPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ConfirmOrderPage()),
    );
  }

  void refreshUI() {
    if (mounted) setState(() {});
  }
}
