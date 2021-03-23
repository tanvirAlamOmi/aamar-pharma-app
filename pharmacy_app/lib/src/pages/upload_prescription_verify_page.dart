import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:pharmacy_app/src/bloc/stream.dart';
import 'package:pharmacy_app/src/component/general/app_bar_back_button.dart';
import 'package:pharmacy_app/src/component/general/common_ui.dart';
import 'package:pharmacy_app/src/models/general/App_Enum.dart';
import 'package:pharmacy_app/src/models/general/App_Enum.dart';
import 'package:pharmacy_app/src/models/states/event.dart';
import 'package:pharmacy_app/src/util/en_bn_dict.dart';
import 'package:pharmacy_app/src/util/util.dart';
import 'package:pharmacy_app/src/component/buttons/general_action_round_button.dart';
import 'package:pharmacy_app/src/pages/confirm_order_page.dart';
import 'package:pharmacy_app/src/component/general/custom_caousel_slider.dart';
import 'package:pharmacy_app/src/models/general/Client_Enum.dart';
import 'package:pharmacy_app/src/store/store.dart';
import 'package:pharmacy_app/src/component/general/custom_message_box.dart';

class UploadPrescriptionVerifyPage extends StatefulWidget {
  final List<Uint8List> prescriptionImageFileList;
  final String nextStep;
  final bool isRepeatOrder;
  UploadPrescriptionVerifyPage(
      {this.prescriptionImageFileList,
      Key key,
      this.nextStep,
      this.isRepeatOrder})
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
    eventChecker();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void eventChecker() async {
    Streamer.getEventStream().listen((data) {
      if (data.eventType == EventType.REFRESH_UPLOAD_PRESCRIPTION_VERIFY_PAGE ||
          data.eventType == EventType.REFRESH_ALL_PAGES) {
        refreshUI();
      }

      if (data.eventType == EventType.CHANGE_LANGUAGE) {
        refreshUI();
      }
    });
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
            title: CustomText('UPLOAD PRESCRIPTION',
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500),
          ),
          body: buildBody(context)),
    );
  }

  Widget buildBody(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        color: Colors.white,
        child: Stack(
          children: [
            Column(
              children: <Widget>[
                SizedBox(height: 30),
                buildTitle(),
                SizedBox(height: 20),
                buildPrescriptionImageList(),
                buildNoteBox(),
                GeneralActionRoundButton(
                  title: buttonText(),
                  isProcessing: isProcessing,
                  callBackOnSubmit: proceedToConfirmOrderPage,
                  padding: const EdgeInsets.fromLTRB(20, 7, 20, 7),
                ),
              ],
            ),
            buildTutorialBox()
          ],
        ),
      ),
    );
  }

  Widget buildTutorialBox() {
    final size = MediaQuery.of(context).size;
    switch (
        Store.instance.appState.tutorialBoxNumberUploadPrescriptionVerifyPage) {
      case 0:
        return Positioned(
          top: 160,
          left: 40,
          child: CustomMessageBox(
            width: size.width - 150,
            height: 120,
            startPoint: 120,
            midPoint: 130,
            endPoint: 140,
            arrowDirection: ClientEnum.ARROW_BOTTOM,
            callBackAction: updateTutorialBox,
            callBackRefreshUI: refreshUI,
            messageTitle: "Tap to remove this uploaded photo",
          ),
        );
        break;
      default:
        return Container();
        break;
    }
  }

  Widget buildTitle() {
    return Container(
      alignment: Alignment.center,
      child: Text(
        EnBnDict.en_bn_number_convert(
                number: widget.prescriptionImageFileList.length) +
            ' ' +
            EnBnDict.en_bn_convert(text: 'UPLOADED PHOTO(s)'),
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
    if (widget.nextStep == AppEnum.CONFIRM_INVOICE_PAGE) return Container();
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 7, 20, 7),
      color: Colors.white,
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CustomText('Add Notes',
              color: Util.purplishColor(),
              fontSize: 13,
              fontWeight: FontWeight.bold),
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
              hintText: EnBnDict.en_bn_convert(
                  text: "Notes e.g. I need all the medicines"),
              hintStyle:
                  TextStyle(fontFamily: EnBnDict.en_bn_font(), fontSize: 13),
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

  void updateTutorialBox() async {
    Store.instance.appState.tutorialBoxNumberUploadPrescriptionVerifyPage += 1;
    await Store.instance.putAppData();
  }

  void removeItem(dynamic index) {
    if (widget.prescriptionImageFileList.length == 1) {
      Util.showSnackBar(
          message: '1 image is mandatory for the prescription',
          scaffoldKey: _scaffoldKey);
      return;
    }
    widget.prescriptionImageFileList
        .remove(widget.prescriptionImageFileList[index]);
    refreshUI();
  }

  void proceedToConfirmOrderPage() {
    switch (widget.nextStep) {
      case AppEnum.CONFIRM_INVOICE_PAGE:
        Navigator.pop(context);
        break;
      case AppEnum.HOME_PAGE:
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ConfirmOrderPage(
                    isRepeatOrder: widget.isRepeatOrder,
                    note: noteBoxController.text,
                    orderType: AppEnum.ORDER_WITH_PRESCRIPTION,
                    prescriptionImageFileList: widget.prescriptionImageFileList,
                  )),
        );
        break;
    }
  }

  String buttonText() {
    switch (widget.nextStep) {
      case AppEnum.CONFIRM_INVOICE_PAGE:
        return 'CONFIRM';
        break;
      case AppEnum.HOME_PAGE:
        return 'PROCEED';
        break;
    }
  }

  void refreshUI() {
    if (mounted) setState(() {});
  }
}
