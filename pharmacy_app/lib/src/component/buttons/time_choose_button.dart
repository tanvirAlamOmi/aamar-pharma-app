import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pharmacy_app/src/component/general/clock_spinner.dart';
import 'package:pharmacy_app/src/util/util.dart';

class TimeChooseButton extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  TimeChooseButton({this.scaffoldKey});

  @override
  _TimeChooseButtonState createState() => _TimeChooseButtonState();
}

class _TimeChooseButtonState extends State<TimeChooseButton> {
  DateTime _selectedTime = DateTime.now();

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
              bottom: BorderSide(width: 1, color: Colors.black),
            ),
            color: Colors.transparent,
          ),
          height: 54,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 3),
              Text("Time"),
              SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  buildBookingTimeText(),
                  SizedBox(width: 10),
                  Icon(Icons.watch_later, size: 18)
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildBookingTimeText() {
    return Text(
      Util.formatDateToStringOnlyHourMinute(_selectedTime),
      style: TextStyle(color: Colors.black, fontSize: 13),
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
                    Text("SELECT DELIVERY TIME ",
                        style: TextStyle(fontWeight: FontWeight.bold)),
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
                            child: Text(
                              "OK",
                              style: TextStyle(fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
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
      time: _selectedTime,
      is24HourMode: false,
      onTimeChange: (time) {
        if (mounted) setState(() {});
      },
    );
  }
}
