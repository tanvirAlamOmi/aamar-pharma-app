import 'dart:io';
import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
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
import 'package:pharmacy_app/src/pages/confirm_order_page.dart';

class UploadPrescriptionVerifyPage extends StatefulWidget {
  final List<Uint8List> prescriptionImageFileList;
  UploadPrescriptionVerifyPage({this.prescriptionImageFileList, Key key})
      : super(key: key);

  @override
  _UploadPrescriptionVerifyPageState createState() =>
      _UploadPrescriptionVerifyPageState();
}

class _UploadPrescriptionVerifyPageState
    extends State<UploadPrescriptionVerifyPage> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool isProcessing = false;
  final TextEditingController noteBoxController = new TextEditingController();
  double currentScrollIndex = 0;
  final scrollController = ScrollController();

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
            'UPLOAD PRESCRIPTION',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: buildBody(context));
  }

  Widget buildBody(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: <Widget>[
            SizedBox(height: 30),
            buildPrescriptionImageList(),
            buildNoteBox(),
            GeneralActionButton(
                title: "SUBMIT",
                isProcessing: isProcessing,
                callBack: proceedToConfirmOrderPage,
                padding: const EdgeInsets.fromLTRB(32, 7, 30, 7)),
          ],
        ),
      ),
    );
  }

  Widget buildPrescriptionImageList() {
    final scrollQuantity = 290;
    final size = MediaQuery.of(context).size;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 30,
          height: 25,
          child: IconButton(
              padding: EdgeInsets.only(left: 3),
              iconSize: 25,
              splashRadius: 10,
              icon: Icon(Icons.chevron_left),
              onPressed: () {
                if (currentScrollIndex <= 0) {
                  currentScrollIndex = 0;
                  return;
                }

                currentScrollIndex = currentScrollIndex - scrollQuantity;
                scrollController.animateTo(currentScrollIndex,
                    duration: Duration(seconds: 1),
                    curve: Curves.fastOutSlowIn);
              }),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 2),
          child: Container(
            alignment: Alignment.center,
            width: size.width - 65,
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(color: Colors.black, width: 2.0),
                top: BorderSide(color: Colors.black, width: 2.0),
                right: BorderSide(color: Colors.black, width: 2.0),
                bottom: BorderSide(color: Colors.black, width: 2.0),
              ),
            ),
            child: SingleChildScrollView(
              controller: scrollController,
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: widget.prescriptionImageFileList
                    .map((singleImageUInt8List) {
                  return Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.fromLTRB(0, 0, 15, 0),
                    child: Image.memory(
                      singleImageUInt8List,
                      fit: BoxFit.cover,
                      width: 280,
                      height: 300,
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
        Container(
          width: 25,
          height: 25,
          child: IconButton(
              padding: EdgeInsets.only(right: 15),
              iconSize: 25,
              splashRadius: 10,
              icon: Icon(Icons.chevron_right),
              onPressed: () {
                if (currentScrollIndex >=
                    widget.prescriptionImageFileList.length * 270) return;

                currentScrollIndex = currentScrollIndex + scrollQuantity;
                scrollController.animateTo(currentScrollIndex,
                    duration: Duration(seconds: 1),
                    curve: Curves.fastOutSlowIn);
              }),
        ),
      ],
    );
  }

  Widget buildNoteBox() {
    return Container(
      padding: const EdgeInsets.fromLTRB(32, 7, 30, 7),
      color: Colors.white,
      width: double.infinity,
      child: TextFormField(
        autofocus: false,
        controller: noteBoxController,
        maxLines: 3,
        style: new TextStyle(
            fontWeight: FontWeight.normal, color: Colors.black, fontSize: 17),
        decoration: new InputDecoration(
          hintText: "Notes e.g. I need all the medicines",
          hintStyle: TextStyle(fontSize: 13),
          fillColor: Colors.white,
          border: new OutlineInputBorder(
            borderRadius: new BorderRadius.circular(5.0),
          ),
        ),
      ),
    );
  }

  void proceedToConfirmOrderPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ConfirmOrderPage(
                note: noteBoxController.text,
              )),
    );
  }

  void refreshUI() {
    if (mounted) setState(() {});
  }
}
