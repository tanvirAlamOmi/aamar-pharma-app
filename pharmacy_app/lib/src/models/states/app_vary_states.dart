import 'dart:async';

import 'package:pharmacy_app/src/models/general/Enum_Data.dart';
import 'package:pharmacy_app/src/models/order/order.dart';

class AppVariableStates {
  String firebaseSMSToken = "";
  String orderFilterStatus = ClientEnum.ORDER_STATUS_ALL;
  Order order  = new Order();


  static AppVariableStates _appVaryState;
  static AppVariableStates get instance => _appVaryState ??= AppVariableStates();
}
