import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:image_picker/image_picker.dart';
import 'package:pharmacy_app/src/models/general/Enum_Data.dart';
import 'package:pharmacy_app/src/repo/auth_repo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:math';
import 'package:uuid/uuid.dart';

class Util {
  static Future<bool> checkInternet() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
    } on SocketException catch (_) {
      return false;
    }
  }

  static String getStaticImageURL() {
    return "https://firebasestorage.googleapis.com/v0/b/pharmacy-project-419ca.appspot.com/o/static%2Fdefault.jpg?alt=media&token=9d286a17-2bdf-4a28-8a6b-15ac30c26c09";
  }

  static showSnackBar(
      {GlobalKey<ScaffoldState> scaffoldKey, String message, int duration}) {
    scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(message),
      duration: Duration(milliseconds: duration ?? 3000),
    ));
  }

  static Color colorFromHex(String hexColor) {
    final hexCode = hexColor.replaceAll('#', '');
    return Color(int.parse('FF$hexCode', radix: 16));
  }

  static Future<void> getPermissions() async {
    if (Platform.isAndroid) {
      await Permission.locationAlways.request();
    }
  }

  static Future<void> handleErrorResponse(
      {String errorResponseCode,
      BuildContext context,
      GlobalKey<ScaffoldState> scaffoldKey,
      int awaitDurationMiliSecond = 0}) async {
    if (errorResponseCode == ClientEnum.RESPONSE_UNAUTHORIZED) {
      // await AuthRepo.instance.logout();
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
    }
    // This Future delay is needed when we render something from FutureBuilder and let that build the UI first.
    await Future.delayed(new Duration(milliseconds: awaitDurationMiliSecond));
    if (errorResponseCode != ClientEnum.RESPONSE_CONNECTION_ERROR) {
      Util.showSnackBar(
          scaffoldKey: scaffoldKey,
          message: "Something went wrong. Please try again.");
    }
    return;
  }

  static String formatDateToString(DateTime dateTime) {
    return new DateFormat.yMMMMd('en_US').add_jm().format(dateTime.toUtc());
  }

  static String formatDateToStringOnlyDate(DateTime dateTime) {
    return Jiffy(dateTime.toUtc()).MMMMd;
  }

  static String formatDateToStringDateAndDay(DateTime dateTime) {
    return Jiffy(dateTime.toUtc()).EEEE + ", " + Jiffy(dateTime.toUtc()).yMMMMd;
  }

  static String formatDateToStringOnlyHourMinute(DateTime dateTime) {
    String hour;
    String minute;
    String AM_PM;

    if (dateTime.hour == 12 || dateTime.hour == 0)
      hour = 12.toString();
    else
      hour = (dateTime.hour % 12).toString();

    if (dateTime.minute >= 0 && dateTime.minute <= 9)
      minute = "0" + dateTime.minute.toString();
    else
      minute = dateTime.minute.toString();

    if (dateTime.hour >= 12)
      AM_PM = "PM";
    else
      AM_PM = "AM";

    return hour + ":" + minute + " " + AM_PM;
  }

  static String createImageUUID() {
    return Uuid().v4().toString().replaceAll("-", "_") +
        "_" +
        DateTime.now().millisecondsSinceEpoch.toString();
  }

  static imagePickAlertDialog({BuildContext context, Function(PickedFile) callBack}) {
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
                          onTap: () async {
                            Navigator.pop(dialogContext);
                            ImagePicker()
                                .getImage(
                                    source: ImageSource.camera,
                                    maxHeight: 800,
                                    maxWidth: 800,
                                    imageQuality: 100)
                                .then((value) {
                              callBack(value);
                            });
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
                          onTap: () async {
                            Navigator.pop(dialogContext);
                            ImagePicker()
                                .getImage(
                                    source: ImageSource.gallery,
                                    maxHeight: 800,
                                    maxWidth: 800,
                                    imageQuality: 100)
                                .then((value) {
                              callBack(value);
                            });
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

  static void prettyPrintJson(String input) {
    const JsonDecoder decoder = JsonDecoder();
    const JsonEncoder encoder = JsonEncoder.withIndent('  ');
    final dynamic object = decoder.convert(input);
    final dynamic prettyString = encoder.convert(object);
    prettyString.split('\n').forEach((dynamic element) => print(element));
  }
}
