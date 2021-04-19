import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'package:pharmacy_app/src/models/general/Client_Enum.dart';
import 'package:pharmacy_app/src/models/order/deliver_address_details.dart';
import 'package:pharmacy_app/src/models/order/invoice_item.dart';
import 'package:pharmacy_app/src/models/order/order.dart';
import 'package:pharmacy_app/src/models/states/app_vary_states.dart';
import 'package:pharmacy_app/src/repo/auth_repo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pharmacy_app/src/store/store.dart';
import 'package:pharmacy_app/src/util/en_bn_dict.dart';
import 'package:pharmacy_app/src/util/util.dart';
import 'dart:math';
import 'package:uuid/uuid.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:typed_data';
import 'package:intl/intl.dart';

class OrderUtil {
  static void calculatePricing(Order order) {
    double subTotal = 0;
    double grandTotal = 0;

    for (final singleItem in order.invoiceItemList) {
      final unitPrice = singleItem.rate;
      final quantity = singleItem.quantity;
      subTotal = subTotal + (unitPrice * quantity);
    }

    if (order.deliveryCharge == null) order.deliveryCharge = '0';
    if (subTotal >= 500) {
      order.deliveryCharge = '0';
    } else {
      order.deliveryCharge = AppVariableStates.instance.orderDeliveryCharge;
    }
    double deliveryCharge = double.parse(order.deliveryCharge);

    if (order.discount == null) order.discount = 0;
    int discount = order.discount;

    grandTotal = (subTotal - (subTotal * discount / 100)) + deliveryCharge;

    order.subTotal = Util.twoDecimalDigit(number: subTotal).toString();
    order.grandTotal = Util.twoDecimalDigit(number: grandTotal).toString();
  }
}
