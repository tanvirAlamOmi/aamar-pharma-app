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
import 'package:pharmacy_app/src/component/buttons/general_action_round_button.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pharmacy_app/src/pages/confirm_order_page.dart';
import 'package:pharmacy_app/src/component/general/custom_caousel_slider.dart';

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
    return GestureDetector(
      onTap: () {},
      child: Scaffold(
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
          body: buildBody(context)),
    );
  }

  Widget buildBody(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            SizedBox(height: 30),
            buildTitle(),
            SizedBox(height: 20),
            buildPrescriptionImageList(),
            buildNoteBox(),
            GeneralActionRoundButton(
              title: "SUBMIT",
              isProcessing: isProcessing,
              callBack: proceedToConfirmOrderPage,
              padding: const EdgeInsets.fromLTRB(20, 7, 20, 7),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTitle() {
    return Container(
      alignment: Alignment.center,
      child: Text(
        widget.prescriptionImageFileList.length.toString() +
            " UPLOADED PHOTO(s)",
        style: TextStyle(
            color: Util.greenishColor(),
            fontSize: 15,
            fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget buildPrescriptionImageList() {
    final children =
        widget.prescriptionImageFileList.map((singleImageUInt8List) {
      return Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: Image.memory(
          singleImageUInt8List,
          fit: BoxFit.cover,
          width: double.infinity,
          height: 200,
        ),
      );
    }).toList();

    return CustomCarouselSlider(
      carouselListWidget: children,
      showRemoveImageButton: true,
      height: 110,
      autoPlay: false,
      refreshUI: refreshUI,
      removeItemFunction: removeItem,
    );
  }

  Widget buildNoteBox() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 7, 20, 7),
      color: Colors.white,
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            "Add Notes",
            style: TextStyle(
                color: Util.purplishColor(),
                fontSize: 12,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 5),
          TextFormField(
            autofocus: false,
            controller: noteBoxController,
            maxLines: 3,
            style: new TextStyle(
                fontWeight: FontWeight.normal,
                color: Colors.black,
                fontSize: 17),
            decoration: new InputDecoration(
              hintText: "Notes e.g. I need all the medicines",
              hintStyle: TextStyle(fontSize: 13),
              fillColor: Colors.white,
              border: new OutlineInputBorder(
                borderRadius: new BorderRadius.circular(5.0),
              ),
            ),
          )
        ],
      ),
    );
  }

  void removeItem(dynamic index) {
    if (widget.prescriptionImageFileList.length == 1) return;
    widget.prescriptionImageFileList
        .remove(widget.prescriptionImageFileList[index]);
    refreshUI();
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
