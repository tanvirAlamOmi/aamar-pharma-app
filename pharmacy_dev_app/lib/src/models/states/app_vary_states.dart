import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:pharmacy_app/src/models/general/Client_Enum.dart';
import 'package:pharmacy_app/src/models/general/App_Enum.dart';
import 'package:pharmacy_app/src/models/order/order.dart';

class AppVariableStates {
  String firebaseSMSToken = "";
  String orderFilterStatus = AppEnum.ORDER_STATUS_ALL;
  String initialLanguageChoose = "LANGUAGE (ENGLISH)";
  DateTime selectedRepeatedTime = DateTime.now();
  Order order = new Order();
  String orderDeliveryCharge = '0';
  BuildContext context;
  bool loginWithReferral = false;
  String dynamicLink = "";
  GlobalKey<NavigatorState> navigatorKey;
  Function submitFunction;

  static AppVariableStates _appVaryState;
  static AppVariableStates get instance =>
      _appVaryState ??= AppVariableStates();
}