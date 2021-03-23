import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pharmacy_app/src/component/buttons/general_action_round_button.dart';
import 'package:pharmacy_app/src/component/general/common_ui.dart';
import 'package:pharmacy_app/src/models/general/App_Enum.dart';
import 'package:pharmacy_app/src/models/general/Client_Enum.dart';
import 'package:pharmacy_app/src/models/general/App_Enum.dart';
import 'package:pharmacy_app/src/models/order/order.dart';
import 'package:pharmacy_app/src/models/states/ui_state.dart';
import 'package:pharmacy_app/src/pages/confirm_invoice_page.dart';
import 'package:pharmacy_app/src/pages/order_details_page.dart';
import 'package:pharmacy_app/src/pages/upload_prescription_verify_page.dart';
import 'package:pharmacy_app/src/util/en_bn_dict.dart';
import 'package:pharmacy_app/src/util/util.dart';

class UploadPrescriptionOrderCard extends StatefulWidget {
  final Order order;
  final bool collectPrescriptionOnDelivery;
  final Function(dynamic) setCollectPrescriptionOnDelivery;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final List<Uint8List> prescriptionImageFileList;
  final Function refreshUI;
  UploadPrescriptionOrderCard(
      {this.order,
      Key key,
      this.scaffoldKey,
      this.prescriptionImageFileList,
      this.refreshUI,
      this.collectPrescriptionOnDelivery,
      this.setCollectPrescriptionOnDelivery})
      : super(key: key);

  @override
  _UploadPrescriptionOrderCardState createState() =>
      _UploadPrescriptionOrderCardState();
}

class _UploadPrescriptionOrderCardState
    extends State<UploadPrescriptionOrderCard> {
  Order order;
  bool isProcessing = false;

  @override
  void initState() {
    super.initState();
    order = widget.order;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Util.removeFocusNode(context),
      child: Container(
        padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
        width: double.infinity,
        child: Material(
          shadowColor: Colors.grey[100].withOpacity(0.4),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          elevation: 0,
          clipBehavior: Clip.antiAlias, // Add This
          child: buildBody(context),
        ),
      ),
    );
  }

  Widget buildBody(BuildContext context) {
    return Column(
      children: [
        buildCollectPrescriptionOnDelivery(),
        buildUploadPrescriptionButton(),
        buildTotalUploadedPrescriptionNumber(),
      ],
    );
  }

  Widget buildCollectPrescriptionOnDelivery() {
    return CheckboxListTile(
      contentPadding: const EdgeInsets.fromLTRB(20, 0, 40, 0),
      title: CustomText('Collect Prescription during delivery',
          color: Colors.orangeAccent,
          fontSize: 17,
          fontWeight: FontWeight.bold),
      value: widget.collectPrescriptionOnDelivery,
      onChanged: (newValue) {
        widget.setCollectPrescriptionOnDelivery(newValue);
        widget.prescriptionImageFileList.clear();
        widget.refreshUI();
      },
      controlAffinity: ListTileControlAffinity.leading,
    );
  }

  Widget buildUploadPrescriptionButton() {
    return GeneralActionRoundButton(
      title: 'UPLOAD PRESCRIPTION',
      isProcessing: widget.collectPrescriptionOnDelivery,
      color: Colors.orangeAccent,
      callBackOnSubmit: uploadPrescriptionOption,
    );
  }

  Widget buildTotalUploadedPrescriptionNumber() {
    if (widget.prescriptionImageFileList.length > 0)
      return CustomText(
          '${widget.prescriptionImageFileList.length} Prescription(s) selected',
          color: Colors.grey,
          fontSize: 12);

    return Container();
  }

  void uploadPrescriptionOption() async {
    isProcessing = true;
    refreshUI();

    var cameraStatus = await Permission.camera.status;
    var storageStatus = await Permission.storage.status;
    if (cameraStatus == PermissionStatus.permanentlyDenied ||
        storageStatus == PermissionStatus.permanentlyDenied) {
      Util.showSnackBar(
          scaffoldKey: widget.scaffoldKey,
          message:
              "Please provide Camera and Storage permissions from Settings");
      isProcessing = false;
      refreshUI();
    } else {
      try {
        List<Asset> resultList = List<Asset>();

        resultList = await MultiImagePicker.pickImages(
          maxImages: 10,
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

        widget.prescriptionImageFileList.clear();
        for (int i = 0; i < resultList.length; i++) {
          widget.prescriptionImageFileList.add(
              Util.convertToUIntListFromByTeData(
                  await resultList[i].getByteData(quality: 100)));
        }
        widget.refreshUI();
        navigateToUploadPrescriptionPage(widget.prescriptionImageFileList);
      } catch (e) {}
    }
  }

  void navigateToUploadPrescriptionPage(
      List<Uint8List> prescriptionImageFileList) {
    if (prescriptionImageFileList.length == 0) return;
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => UploadPrescriptionVerifyPage(
                prescriptionImageFileList: prescriptionImageFileList,
                nextStep: AppEnum.CONFIRM_INVOICE_PAGE,
              )),
    );
  }

  void refreshUI() {
    if (mounted) setState(() {});
  }
}
