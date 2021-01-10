import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pharmacy_app/src/component/buttons/notification_action_button.dart';
import 'package:pharmacy_app/src/component/general/drawerUI.dart';
import 'package:pharmacy_app/src/models/general/Enum_Data.dart';
import 'package:pharmacy_app/src/store/store.dart';
import 'package:pharmacy_app/src/util/util.dart';
import 'package:pharmacy_app/src/component/cards/carousel_slider_card.dart';
import 'package:pharmacy_app/src/pages/upload_prescription_verify_page.dart';
import 'package:pharmacy_app/src/pages/add_items_page.dart';
import 'package:pharmacy_app/src/component/general/custome_message_box.dart';

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
          actions: [NotificationActionButton()],
        ),
        body: buildBody(context));
  }

  Widget buildBody(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        alignment: Alignment.center,
        child: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                HomePageCarouselSliderCard(),
                buildTitle(),
                SizedBox(height: 10),
                buildPrescriptionWantedTitle(),
                SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    buildContainer(
                        "UPLOAD PRESCRIPTION / PHOTO",
                        Icon(Icons.add_shopping_cart, color: Colors.white),
                        uploadPrescriptionOption),
                    SizedBox(width: 10),
                    buildContainer(
                        "ADD ITEMS MANUALLY",
                        Icon(Icons.add_shopping_cart, color: Colors.white),
                        navigateToAddItems)
                  ],
                ),
                SizedBox(height: 20),
                buildHotlineText(),
                SizedBox(height: 20),
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
    switch (Store.instance.appState.tutorialBoxNumber) {
      case 0:
        return Positioned(
          top: 50,
          left: 20,
          child: CustomMessageBox(
            width: size.width - 100,
            height: 200,
            startPoint: 40,
            midPoint: 50,
            endPoint: 60,
            arrowDirection: ClientEnum.ARROW_BOTTOM,
            callBackRefreshUI: refreshUI,
            messageTitle:
                "You can order medicines or other items by simply uploading a photo of your prescription or a photo of a paper with your item list on it or even just a photo of the items",
          ),
        );
        break;
      case 1:
        return Positioned(
          top: 50,
          left: 20,
          child: CustomMessageBox(
              width: size.width - 100,
              height: 200,
              startPoint: size.width - 180,
              midPoint: size.width - 175,
              endPoint: size.width - 200,
              arrowDirection: ClientEnum.ARROW_BOTTOM,
              callBackRefreshUI: refreshUI,
              messageTitle:
                  "You can also order by adding the name of the items you want to order and stating their unit and quantity manually"),
        );
        break;
      case 2:
        return Positioned(
            bottom: 50,
            left: 20,
            child: CustomMessageBox(
                width: size.width - 100,
                height: 200,
                startPoint: 40,
                midPoint: 50,
                endPoint: 60,
                arrowDirection: ClientEnum.ARROW_BOTTOM,
                callBackRefreshUI: refreshUI,
                messageTitle:
                    "Call us on our hotline number anytime between 10 AM to 10 PM for any kind of queries you have"));
        break;
      default:
        return Container();
        break;
    }
  }

  Widget buildTitle() {
    return Container(
      padding: EdgeInsets.only(top: 10),
      child: Text(
        "ORDER MEDICINES AND MORE",
        textAlign: TextAlign.center,
        style:
            TextStyle(fontWeight: FontWeight.bold, color: Util.greenishColor()),
      ),
    );
  }

  Widget buildPrescriptionWantedTitle() {
    return Container(
      width: 250,
      height: 50,
      padding: EdgeInsets.only(top: 10),
      child: Text(
        "All medicines except OTC medicines require prescription*",
        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
      ),
    );
  }

  Widget buildContainer(String title, Icon icon, Function() callBack) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: callBack,
      child: Container(
        height: 175,
        width: size.width / 2 - 32,
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
                  child: Text(
                    title,
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13),
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
      width: size.width - 35,
      height: 60,
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
              color: Util.purplishColor(),
              width: 70,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_call, size: 18, color: Colors.white),
                  Text(
                    "CALL US",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13),
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

        navigateToUploadPrescriptionPage(prescriptionImageFileList);
      } catch (e) {}
    }
  }

  navigateToUploadPrescriptionPage(List<Uint8List> prescriptionImageFileList) {
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
