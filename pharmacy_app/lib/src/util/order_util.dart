import 'package:pharmacy_app/src/models/general/App_Enum.dart';
import 'package:pharmacy_app/src/models/order/delivery_charge.dart';
import 'package:pharmacy_app/src/models/order/order.dart';
import 'package:pharmacy_app/src/models/states/app_vary_states.dart';
import 'package:pharmacy_app/src/util/util.dart';

class OrderUtil {
  static void calculatePricing(Order order) {
    double subTotal = 0;
    double grandTotal = 0;
    double deliveryCharge = 0;
    int discount = 0;

    for (final singleItem in order.invoiceItemList) {
      final unitPrice = singleItem.rate;
      final quantity = singleItem.quantity;
      subTotal = subTotal + (unitPrice * quantity);
    }

    deliveryCharge = double.parse(setDeliveryCharge(order, subTotal));
    discount = setDiscount(order);
    grandTotal = (subTotal - (subTotal * discount / 100)) + deliveryCharge;

    order.subTotal = Util.twoDecimalDigit(number: subTotal).toString();
    order.grandTotal = Util.twoDecimalDigit(number: grandTotal).toString();
    order.grandTotal = OrderUtil.roundingGrandTotal(order.grandTotal);
  }

  static String setDeliveryCharge(Order order, double subTotal) {
    if (order.deliveryCharge == null) order.deliveryCharge = '0';

    if (order.deliveryChargeType == AppEnum.ORDER_DELIVERY_CHARGE_AUTOMATIC) {
      for (DeliveryCharge deliveryChargeData
          in AppVariableStates.instance.deliveryCharges) {
        if (subTotal >= deliveryChargeData.amountFrom &&
            subTotal < deliveryChargeData.amountTo) {
          order.deliveryCharge = deliveryChargeData.deliveryCharge.toString();
          break;
        }
      }
    }
    if (order.deliveryChargeType == AppEnum.ORDER_DELIVERY_CHARGE_MANUAL) {
      order.deliveryCharge = order.deliveryCharge;
    }

    return order.deliveryCharge;
  }

  static int setDiscount(Order order) {
    if (order.discount == null) order.discount = 0;
    return order.discount;
  }

  static String roundingGrandTotal(String orderGrandTotal) {
    final double grandTotalDoubleFormat = double.parse(orderGrandTotal);
    final int grandTotalIntFormat = grandTotalDoubleFormat.toInt();

    final double fraction = grandTotalDoubleFormat - grandTotalIntFormat;

    if (fraction < 0.5) {
      return grandTotalIntFormat.toString();
    }

    return (grandTotalIntFormat + 1).toString();
  }
}
