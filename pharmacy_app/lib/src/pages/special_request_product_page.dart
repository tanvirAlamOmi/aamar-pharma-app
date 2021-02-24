import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pharmacy_app/src/bloc/stream.dart';
import 'package:pharmacy_app/src/component/general/app_bar_back_button.dart';
import 'package:pharmacy_app/src/component/general/common_ui.dart';
import 'package:pharmacy_app/src/models/general/App_Enum.dart';
import 'package:pharmacy_app/src/models/general/Enum_Data.dart';
import 'package:pharmacy_app/src/models/states/app_vary_states.dart';
import 'package:pharmacy_app/src/models/states/event.dart';
import 'package:pharmacy_app/src/pages/request_received_success_page.dart';
import 'package:pharmacy_app/src/pages/verification_page.dart';
import 'package:pharmacy_app/src/repo/auth_repo.dart';
import 'package:pharmacy_app/src/repo/order_repo.dart';
import 'package:pharmacy_app/src/store/store.dart';
import 'package:pharmacy_app/src/util/en_bn_dict.dart';
import 'package:pharmacy_app/src/util/util.dart';
import 'package:tuple/tuple.dart';
import 'package:pharmacy_app/src/component/buttons/general_action_round_button.dart';

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
  TextEditingController phoneNumberController;

  Uint8List imageData;
  bool isProcessing = false;

  @override
  void initState() {
    super.initState();
    phoneNumberController = new TextEditingController(
        text: Store.instance.appState.user.phone ?? '');
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
            title: CustomText('REQUEST PRODUCT',
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500),
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
          buildPhoneNumberInputWidget(),
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
                      CustomText('ADD PHOTO',
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold)
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
            CustomText('Item Name',
                fontWeight: FontWeight.bold, color: Util.purplishColor()),
            SizedBox(height: 3),
            SizedBox(
              height: 35, // set this
              child: TextField(
                controller: itemNameController,
                decoration: new InputDecoration(
                  isDense: true,
                  hintText: EnBnDict.en_bn_convert(text: 'Napa, Histasin'),
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
            CustomText('Quantity',
                fontWeight: FontWeight.bold, color: Util.purplishColor()),
            SizedBox(height: 3),
            SizedBox(
              height: 35, // set this
              child: TextField(
                keyboardType: TextInputType.number,
                controller: itemQuantityController,
                decoration: new InputDecoration(
                  isDense: true,
                  hintText:  EnBnDict.en_bn_convert(text: 'e.g. 10,15'),
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

  Widget buildPhoneNumberInputWidget() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(27, 7, 27, 7),
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CustomText('Phone Number',
                fontWeight: FontWeight.bold, color: Util.purplishColor()),
            SizedBox(height: 3),
            SizedBox(
              height: 35, // set this
              child: TextField(
                keyboardType: TextInputType.number,
                controller: phoneNumberController,
                decoration: new InputDecoration(
                  isDense: true,
                  hintText: EnBnDict.en_bn_convert(text: '01xxxxxxxxx'),
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
            CustomText('Add Notes',
                color: Util.purplishColor(),
                fontSize: 12,
                fontWeight: FontWeight.bold),
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
                hintText: EnBnDict.en_bn_convert(
                    text: "Notes e.g. I need all the medicines"),
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
      isProcessing: isProcessing,
      callBackOnSubmit: () {
        showAlertDialog(
            context: context,
            message: 'Are you sure to submit this request?',
            acceptFunc: processRequestOrder);
      },
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

  void processRequestOrder() async {
    if (itemNameController.text.isEmpty) {
      Util.showSnackBar(
          message: 'Please provide the name of the item',
          scaffoldKey: _scaffoldKey);
      return;
    }

    if (itemQuantityController.text.isEmpty) {
      Util.showSnackBar(
          scaffoldKey: _scaffoldKey,
          message: "Please provide the quantity of the item");
      return;
    }

    if (phoneNumberController.text.length != 11) {
      Util.showSnackBar(
          scaffoldKey: _scaffoldKey,
          message: "Please provide a valid 11 digit Bangladeshi Number");
      return;
    }

    if (!Util.verifyNumberDigitOnly(numberText: phoneNumberController.text)) {
      Util.showSnackBar(
          scaffoldKey: _scaffoldKey,
          message: "Please provide a valid 11 digit Bangladeshi Number");
      return;
    }

    AppVariableStates.instance.submitFunction = submitRequestOrder;

    if (Store.instance.appState.user.id == 0 ||
        Store.instance.appState.user.id == null) {
      final countryCode = "+88";
      final phone = countryCode + phoneNumberController.text;
      await Store.instance.setPhoneNumber(phoneNumberController.text);
      await AuthRepo.instance.sendSMSCode(phone);

      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => VerificationPage(
                  phoneNumber: phoneNumberController.text,
                  onVerificationNextStep:
                      AppEnum.ON_VERIFICATION_CONFIRM_REQUEST_ORDER,
                )),
      );
    } else {
      submitRequestOrder();
    }
  }

  void submitRequestOrder() async {
    isProcessing = true;
    refreshUI();

    Util.showSnackBar(
        message: 'Please wait...', scaffoldKey: _scaffoldKey, duration: 1000);

    String requestedProductImageUrl = ClientEnum.NA;
    if (imageData != null) {
      requestedProductImageUrl = await Util.uploadImageToFirebase(
          imageFile: imageData, folderPath: 'request-product/');
    }

    Tuple2<void, String> specialRequestProductOrderResponse =
        await OrderRepo.instance.specialRequestOrder(
            itemName: itemNameController.text,
            itemQuantity: itemQuantityController.text,
            productImage: requestedProductImageUrl,
            note: noteController.text);

    if (specialRequestProductOrderResponse.item2 ==
        ClientEnum.RESPONSE_SUCCESS) {
      Navigator.of(context).pop();
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => RequestReceivedSuccessPage(
                  icon: Icons.favorite,
                  pageTitle: 'REQUEST RECEIVED',
                  title: 'Your request has been received.',
                  message:
                      'We will notify you when we have your requested product.',
                )),
      );
      Streamer.putEventStream(Event(EventType.REFRESH_REQUEST_ORDER_PAGE));
    } else {
      Util.showSnackBar(
          scaffoldKey: _scaffoldKey,
          message: "Something went wrong. Please try again.",
          duration: 1500);
    }

    isProcessing = false;
    refreshUI();
  }

  void refreshUI() {
    if (mounted) setState(() {});
  }
}
