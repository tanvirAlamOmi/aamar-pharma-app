import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pharmacy_app/src/component/buttons/general_action_button.dart';
import 'package:pharmacy_app/src/component/buttons/general_action_round_button.dart';
import 'package:pharmacy_app/src/component/general/common_ui.dart';
import 'package:pharmacy_app/src/models/feed/feed_item.dart';
import 'package:pharmacy_app/src/models/general/App_Enum.dart';
import 'package:pharmacy_app/src/models/general/Client_Enum.dart';
import 'package:pharmacy_app/src/component/general/drop_down_item.dart';
import 'package:pharmacy_app/src/models/general/App_Enum.dart';
import 'package:pharmacy_app/src/models/states/app_vary_states.dart';
import 'package:pharmacy_app/src/models/states/ui_state.dart';
import 'package:pharmacy_app/src/pages/add_items_page.dart';
import 'package:pharmacy_app/src/pages/special_request_product_page.dart';
import 'package:pharmacy_app/src/pages/upload_prescription_verify_page.dart';
import 'package:pharmacy_app/src/util/util.dart';
import 'package:pharmacy_app/src/store/store.dart';

class RepeatOrderPageButtonCard extends StatelessWidget {
  RepeatOrderPageButtonCard({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(25, 10, 25, 10),
      width: double.infinity,
      child: Material(
        shadowColor: Colors.grey[100].withOpacity(0.4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2.0)),
        elevation: 0,
        clipBehavior: Clip.antiAlias, // Add This
        child: Column(
          children: [
            GeneralActionRoundButton(
              padding: EdgeInsets.fromLTRB(5, 5, 5, 0),
              title: "ADD A NEW REPEAT ORDER",
              height: 40,
              isProcessing: false,
              color: Util.greenishColor(),
              callBackOnSubmit: () => showAlertDialog(),
            ),
            SizedBox(height: 10),
            CustomText('YOU CAN CANCEL ANYTIME',
                color: Util.greenishColor(), fontWeight: FontWeight.bold)
          ],
        ),
      ),
    );
  }

  void showAlertDialog() {
    showDialog(
        context: UIState.instance.scaffoldKey.currentContext,
        builder: (BuildContext dialogContext) {
          return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0)), //this right here
              child: Container(
                height: 400,
                child: buildBody(
                    UIState.instance.scaffoldKey.currentContext, dialogContext),
              ));
        });
  }

  Widget buildBody(BuildContext context, BuildContext dialogContext) {
    return Column(children: [
      SizedBox(height: 20),
      buildCrossButton(context, dialogContext),
      SizedBox(height: 20),
      buildTitle(),
      SizedBox(height: 20),
      buildProcessBox(context, dialogContext),
      SizedBox(height: 20),
    ]);
  }

  Widget buildCrossButton(BuildContext context, BuildContext dialogContext) {
    return Container(
      alignment: Alignment.centerRight,
      padding: EdgeInsets.fromLTRB(0, 5, 10, 0),
      child: ClipOval(
        child: Material(
          color: Util.purplishColor(), // button color
          child: InkWell(
            splashColor: Util.purplishColor(), // inkwell color
            child: SizedBox(
                width: 25,
                height: 25,
                child: Icon(
                  Icons.clear,
                  size: 18,
                  color: Colors.white,
                )),
            onTap: () {
              Navigator.pop(dialogContext);
            },
          ),
        ),
      ),
    );
  }

  Widget buildTitle() {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.only(top: 10),
          child: CustomText(
            'ORDER MEDICINES AND MORE',
            textAlign: TextAlign.center,
            fontWeight: FontWeight.bold,
            fontSize: 15,
            color: Util.greenishColor(),
          ),
        ),
        Container(
          width: 250,
          height: 50,
          padding: EdgeInsets.only(top: 10),
          child: CustomText(
              'All medicines except OTC medicines require prescription*',
              textAlign: TextAlign.center,
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Colors.red),
        )
      ],
    );
  }

  Widget buildProcessBox(BuildContext context, BuildContext dialogContext) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        buildContainer(
            context,
            dialogContext,
            'UPLOAD PRESCRIPTION / PHOTO',
            Icon(Icons.add_shopping_cart, color: Colors.white),
            uploadPrescriptionOption),
        SizedBox(width: 10),
        buildContainer(
            context,
            dialogContext,
            'ADD ITEMS MANUALLY',
            Icon(Icons.add_shopping_cart, color: Colors.white),
            navigateToAddItems)
      ],
    );
  }

  Widget buildContainer(
      BuildContext context,
      BuildContext dialogContext,
      String title,
      Icon icon,
      Function(BuildContext context, BuildContext dialogContext) callBack) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => callBack(context, dialogContext),
      child: Container(
        height: 175,
        width: size.width / 2 - 60,
        child: Material(
          shadowColor: Colors.grey[100].withOpacity(0.4),
          color: Util.purplishColor(),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          elevation: 3,
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                    color: Util.greenishColor(),
                    borderRadius: BorderRadius.all(Radius.circular(8))),
                width: 40,
                height: 40,
                alignment: Alignment.center,
                child: icon,
              ),
              SizedBox(height: 10),
              Container(
                  width: 100,
                  height: 50,
                  child: CustomText(title,
                      textAlign: TextAlign.center,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 13))
            ],
          ),
        ),
      ),
    );
  }

  void uploadPrescriptionOption(
      BuildContext context, BuildContext dialogContext) async {
    var cameraStatus = await Permission.camera.status;
    var storageStatus = await Permission.storage.status;
    if (cameraStatus == PermissionStatus.permanentlyDenied ||
        storageStatus == PermissionStatus.permanentlyDenied) {
      Util.showSnackBar(
          scaffoldKey: UIState.instance.scaffoldKey,
          message:
              "Please provide Camera and Storage permissions from Settings");
    } else {
      try {
        Navigator.pop(dialogContext);
        List<Asset> resultList = List<Asset>();
        final List<Uint8List> prescriptionImageFileList = new List();

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

        for (int i = 0; i < resultList.length; i++) {
          prescriptionImageFileList.add(Util.convertToUIntListFromByTeData(
              await resultList[i].getByteData(quality: 100)));
        }

        navigateToUploadPrescriptionPage(context, prescriptionImageFileList);
      } catch (e) {}
    }
  }

  void navigateToAddItems(BuildContext context, BuildContext dialogContext) {
    Navigator.pop(dialogContext);
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => AddItemsPage(isRepeatOrder: true)),
    );
  }

  void navigateToUploadPrescriptionPage(
      BuildContext context, List<Uint8List> prescriptionImageFileList) {
    if (prescriptionImageFileList.length == 0) return;
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => UploadPrescriptionVerifyPage(
                prescriptionImageFileList: prescriptionImageFileList,
                isRepeatOrder: true,
                nextStep: AppEnum.HOME_PAGE,
              )),
    );
  }
}
