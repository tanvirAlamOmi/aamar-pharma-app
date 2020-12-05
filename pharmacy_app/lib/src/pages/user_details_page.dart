import 'dart:convert';
import 'dart:typed_data';
import 'package:pharmacy_app/src/component/general/drawerUI.dart';
import 'package:pharmacy_app/src/models/user/user.dart';
import 'package:pharmacy_app/src/repo/auth_repo.dart';
import 'package:pharmacy_app/src/store/store.dart';
import 'package:pharmacy_app/src/util/util.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tuple/tuple.dart';
import 'package:cached_network_image/cached_network_image.dart';

class AccountPage extends StatefulWidget {

  AccountPage({Key key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  User user;
  TextEditingController userNameController;
  TextEditingController contactEmailController;
  TextEditingController contactPhoneController;
  final formKey = GlobalKey();
  bool loading = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final ImagePicker imagePicker = ImagePicker();
  PickedFile pickedImageFile;
  String profileImageUrl; // URL

  @override
  void initState() {
    super.initState();
    setUserDetailsData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void setUserDetailsData() {
    user = User();
    userNameController = new TextEditingController(text: "Arbree");
    contactEmailController =
        new TextEditingController(text: "arbree@arbree.com");
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        drawer: MainDrawer(),
        key: _scaffoldKey,
        appBar: AppBar(
          elevation: 1,
          centerTitle: true,
          title: Text('MY DETAILS', style: TextStyle(color: Colors.white)),
          actions: <Widget>[
            buildSaveAction(),
          ],
        ),
        body: SingleChildScrollView(child: buildBody(context)),
      ),
    );
  }

  Widget buildBody(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          SizedBox(height: 10.0),
          Container(
            color: Colors.white,
            padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 10.0),
            child: buildFormBox(context),
          ),
          SizedBox(height: 15.0),
        ],
      ),
    );
  }

  Widget buildFormBox(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          buildImage(),
          SizedBox(height: 10),
          buildUserName(),
          SizedBox(height: 10),
          buildContactEmail(),
          SizedBox(height: 10),
          buildContactNumber()
        ],
      ),
    );
  }

  Widget buildImage() {
    return Container(
        height: 130,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Stack(
              children: <Widget>[
                CircleAvatar(
                  backgroundColor: Colors.black,
                  radius: 50,
                  child: ClipOval(child: buildImageWidget()),
                ),
                Positioned(
                  bottom: 2.0,
                  right: 0.0,
                  child: CircleAvatar(
                    backgroundColor: Colors.black,
                    radius: 15,
                    child: ClipOval(
                      child: IconButton(
                        onPressed: () async {
                          Util.showSnackBar(
                              scaffoldKey: _scaffoldKey,
                              message:
                                  "Please always allow Camera and Storage permission from settings",
                              duration: 1000);
                          var cameraStatus = await Permission.camera.status;
                          var storageStatus = await Permission.storage.status;
                          if (cameraStatus ==
                                  PermissionStatus.permanentlyDenied ||
                              storageStatus ==
                                  PermissionStatus.permanentlyDenied) {
                            Util.showSnackBar(
                                scaffoldKey: _scaffoldKey,
                                message:
                                    "Please provide Camera and Storage permissions from Settings");
                            await Future.delayed(Duration(seconds: 5));
                            return openAppSettings();
                          } else {
                            showAlertDialog(context, ImageEnum.PROFILE_IMAGE);
                          }
                        },
                        iconSize: 15,
                        icon: Icon(
                          Icons.camera,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ));
  }

  Widget buildImageWidget() {
    return CachedNetworkImage(
      imageUrl: profileImageUrl ?? Util.getStaticImageURL(),
      placeholder: (context, url) =>
          new Image.asset('assets/images/avatar.png'),
      errorWidget: (context, url, error) => new Icon(Icons.error),
      fit: BoxFit.cover,
      width: 150,
      height: 150,
    );
  }

  Widget buildUserName() {
    return Padding(
      padding: const EdgeInsets.only(top: 0, bottom: 15),
      child: Container(
        color: Colors.white,
        width: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              autofocus: false,
              controller: userNameController,
              decoration: new InputDecoration(
                labelText: "First Name",
                hintText: 'Enter your first name',
                fillColor: Colors.white,
                border: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(0.0),
                  borderSide: new BorderSide(),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildContactEmail() {
    return Padding(
      padding: const EdgeInsets.only(top: 0, bottom: 15),
      child: Container(
        color: Colors.white,
        width: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              autofocus: false,
              controller: contactEmailController,
              decoration: new InputDecoration(
                labelText: "Email",
                hintText: 'Enter your contact email',
                fillColor: Colors.white,
                border: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(0.0),
                  borderSide: new BorderSide(),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildContactNumber() {
    return Padding(
      padding: const EdgeInsets.only(top: 0, bottom: 15),
      child: Container(
        color: Colors.white,
        width: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              autofocus: false,
              controller: contactPhoneController,
              keyboardType: TextInputType.phone,
              decoration: new InputDecoration(
                labelText: "Contact Number",
                hintText: 'Enter your contact number',
                fillColor: Colors.white,
                border: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(0.0),
                  borderSide: new BorderSide(),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildSaveAction() {
    return Builder(
      builder: (context) {
        return MaterialButton(
          child: Text(
            'SAVE',
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () async {
            (formKey.currentState as FormState).save();

            FocusScopeNode currentFocus = FocusScope.of(context);

            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }

            return;
          },
        );
      },
    );
  }

  void pickImage(ImageEnum selectionType, ImageEnum imageType) async {
    try {
      if (selectionType == ImageEnum.CAMERA) {
        pickedImageFile = await imagePicker.getImage(
            source: ImageSource.camera,
            maxHeight: 800,
            maxWidth: 800,
            imageQuality: 100);
        deleteImageFromFirebase();
        uploadImageToFirebase();
      } else if (selectionType == ImageEnum.STORAGE) {
        pickedImageFile = await imagePicker.getImage(
            source: ImageSource.gallery,
            maxHeight: 800,
            maxWidth: 800,
            imageQuality: 100);
        deleteImageFromFirebase();
        uploadImageToFirebase();
      }
      if (mounted) setState(() {});
    } catch (err) {
      print(err);
    }
  }

  Future uploadImageToFirebase() async {
    try {
      StorageReference firebaseStorageRef = FirebaseStorage.instance
          .ref()
          .child('customer/' + Util.createImageUUID() + ".jpg");
      StorageUploadTask uploadTask =
          firebaseStorageRef.putData(await pickedImageFile.readAsBytes());
      StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
      taskSnapshot.ref.getDownloadURL().then(
        (url) {
          profileImageUrl = url;
          if (mounted) setState(() {});
        },
      );
    } catch (error) {
      print(error);
    }
  }

  Future deleteImageFromFirebase() async {
    try {
      if (profileImageUrl != null) {
        StorageReference photoRef =
            await FirebaseStorage.instance.getReferenceFromUrl(profileImageUrl);

        await photoRef.delete();
      }
    } catch (error) {}
  }

  void showAlertDialog(BuildContext context, ImageEnum imageType) {
    showDialog(
        context: context,
        builder: (BuildContext dialogContext) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0)), //this right here
            child: Container(
              height: 120,
              width: 50,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("PICK IMAGE BY ",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 5),
                    Divider(height: 1, color: Colors.grey[700]),
                    SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(dialogContext);
                            pickImage(ImageEnum.CAMERA, imageType);
                          },
                          child: Column(
                            children: <Widget>[
                              Icon(Icons.camera, color: Colors.black),
                              Text(
                                "Camera",
                                style: TextStyle(fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 50),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(dialogContext);
                            pickImage(ImageEnum.STORAGE, imageType);
                          },
                          child: Column(
                            children: <Widget>[
                              Icon(Icons.insert_drive_file,
                                  color: Colors.black),
                              Text(
                                "File",
                                style: TextStyle(fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  void refreshUI() {
    if (mounted) setState(() {});
  }
}

enum ImageEnum { PROFILE_IMAGE, CAMERA, STORAGE }
