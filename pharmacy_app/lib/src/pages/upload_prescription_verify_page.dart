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
  final PickedFile prescriptionImageFile;
  UploadPrescriptionVerifyPage({this.prescriptionImageFile, Key key})
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
            buildPrescriptionImage(),
            buildNoteBox(),
            GeneralActionButton(
                title: "SUBMIT",
                isProcessing: isProcessing,
                callBack: proceedToConfirmOrderPage,
                padding: const EdgeInsets.fromLTRB(32, 7, 32, 7)),
          ],
        ),
      ),
    );
  }

  Widget buildPrescriptionImage() {
    final size = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.fromLTRB(30, 7, 30, 7),
      child: Image.file(
        File(widget.prescriptionImageFile.path),
        fit: BoxFit.contain,
        width: double.infinity,
        height: size.height / 2,
      ),
    );
  }

  Widget buildNoteBox() {


    return Container(
      padding: const EdgeInsets.fromLTRB(32, 7, 32, 7),
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

    return Container(
      padding: const EdgeInsets.fromLTRB(32, 7, 32, 7),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: Colors.red)),
      child: TextField(
        autofocus: false,
        maxLines: 3,
        decoration: InputDecoration(
          border: InputBorder.none,
          labelText: "First Name",
        ),
        controller: noteBoxController,
      ),
    );
  }

  void proceedToConfirmOrderPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ConfirmOrderPage(
                note: noteBoxController.text,
                prescriptionImageFile: widget.prescriptionImageFile,
              )),
    );
  }

  void refreshUI() {
    if (mounted) setState(() {});
  }
}
