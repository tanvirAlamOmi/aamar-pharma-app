import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pharmacy_app/src/component/general/clock_spinner.dart';
import 'package:pharmacy_app/src/component/general/common_ui.dart';
import 'package:pharmacy_app/src/models/general/Enum_Data.dart';
import 'package:pharmacy_app/src/store/store.dart';
import 'package:pharmacy_app/src/util/en_bn_dict.dart';
import 'package:pharmacy_app/src/util/util.dart';

class TimeChooseButton extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final Function(DateTime value) setSelectedTime;
  final Function() callBackRefreshUI;
  final DateTime selectedTime;

  TimeChooseButton(
      {this.scaffoldKey,
      this.selectedTime,
      this.setSelectedTime,
      this.callBackRefreshUI});

  @override
  Widget build(BuildContext context) {
    return buildClock(context);
  }

  Widget buildClock(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showTimerClockAlertDialog(context);
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 30, 0),
        child: Container(
          width: 130,
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 0.5, color: Colors.black),
            ),
            color: Colors.transparent,
          ),
          height: 54,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 3),
              CustomText('Time',
                  fontWeight: FontWeight.bold, color: Util.purplishColor()),
              SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  buildTimeText(),
                  Icon(Icons.watch_later, size: 18)
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTimeText() {
    return Text(
      timeFormatInLanguage(),
      style: TextStyle(color: Colors.black, fontSize: 15),
    );
  }

  void showTimerClockAlertDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext dialogContext) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0)), //this right here
            child: Container(
              height: 200,
              width: 100,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CustomText('SELECT DELIVERY TIME',
                        fontWeight: FontWeight.bold),
                    SizedBox(height: 15),
                    Divider(height: 1, color: Colors.grey[700]),
                    hourMinute12H(),
                    SizedBox(height: 15),
                    Divider(height: 1, color: Colors.grey[700]),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(dialogContext);
                          },
                          child: Container(
                            alignment: Alignment.center,
                            color: Colors.transparent,
                            width: 60,
                            height: 30,
                            child: CustomText('OK',
                                textAlign: TextAlign.center,
                                fontWeight: FontWeight.bold),
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

  Widget hourMinute12H() {
    return new TimePickerSpinner(
      itemHeight: 30,
      itemWidth: 50,
      spacing: 50,
      time: selectedTime,
      is24HourMode: false,
      onTimeChange: (time) {
        setSelectedTime(time);
        callBackRefreshUI();
      },
    );
  }

  String timeFormatInLanguage() {
    final timeInEnglish = Util.formatDateToStringOnlyHourMinute(selectedTime);

    if (Store.instance.appState.language == ClientEnum.LANGUAGE_BANGLA) {
      return EnBnDict.time_bn_convert_with_time_type(text: timeInEnglish);
    }

    return timeInEnglish;
  }
}
