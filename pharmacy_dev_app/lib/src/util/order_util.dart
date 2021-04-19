import 'package:pharmacy_app/src/models/order/order.dart';
import 'package:pharmacy_app/src/models/states/app_vary_states.dart';
import 'package:pharmacy_app/src/util/util.dart';

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
    order.grandTotal = OrderUtil.roundingGrandTotal(order.grandTotal);
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
