import 'dart:async';

class AppVariableStates {
  bool turnOnGPS = false;
  bool launchedAppfirstTime = true;
  bool showAlertDialog = false;
  bool getLocation = true;
  List<Timer> timerList = new List<Timer>();

  static AppVariableStates _boolState;
  static AppVariableStates get instance => _boolState ??= AppVariableStates();
}
