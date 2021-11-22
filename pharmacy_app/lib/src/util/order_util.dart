import 'package:pharmacy_app/src/models/general/App_Enum.dart';
import 'package:pharmacy_app/src/models/order/delivery_charge.dart';
import 'package:pharmacy_app/src/models/order/invoice_item.dart';
import 'package:pharmacy_app/src/models/order/order.dart';
import 'package:pharmacy_app/src/models/states/app_vary_states.dart';
import 'package:pharmacy_app/src/util/util.dart';

class OrderUtil {
  static void calculatePricing(Order order) {
    double subTotal = 0;
    double grandTotal = 0;
    double deliveryCharge = 0;
    double grandTotalDiscount = 0;

    subTotal = getSubTotal(order);
    deliveryCharge = double.parse(getDeliveryCharge(order, subTotal));
    grandTotalDiscount = getAllTotalDiscount(order);
    grandTotal = (subTotal - grandTotalDiscount) + deliveryCharge;

    order.subTotal = Util.twoDecimalDigit(number: subTotal).toString();
    order.grandTotalDiscount =
        Util.twoDecimalDigit(number: grandTotalDiscount).toString();
    order.grandTotal = Util.twoDecimalDigit(number: grandTotal).toString();
    order.grandTotal = OrderUtil.roundingGrandTotal(order.grandTotal);
  }

  static String getDeliveryCharge(Order order, double subTotal) {
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

  static getSubTotal(Order order) {
    dynamic subTotal = 0;
    for (final singleItem in order.invoiceItemList) {
      final unitPrice = singleItem.rate;
      final quantity = singleItem.quantity;
      subTotal = subTotal + (unitPrice * quantity);
    }

    order.subTotal = subTotal.toString();
    return double.parse(order.subTotal);
  }

  static double getSingleItemDiscountMinusAmount(InvoiceItem singleItem) {
    final unitPrice = singleItem.rate;
    final quantity = singleItem.quantity;
    final itemDiscountAmount = singleItem.itemDiscount;
    final discountType = singleItem.itemDiscountType;

    dynamic price = 0;

    switch (discountType) {
      case '%':
        price = Util.twoDecimalDigit(
            number: (unitPrice * itemDiscountAmount / 100) * quantity);
        break;

      case '৳':
        price =
            Util.twoDecimalDigit(number: (itemDiscountAmount / 1) * quantity);
        // Divided by 1 means converting int to double
        break;
    }

    return price;
  }

  static double getSingleItemPrice(InvoiceItem singleItem) {
    final unitPrice = singleItem.rate;
    final quantity = singleItem.quantity;
    final price = Util.twoDecimalDigit(number: unitPrice * quantity);
    return price;
  }

  static double getTotalItemDiscountAmount(Order order) {
    double totalItemDiscountAmount = 0;
    for (int i = 0; i < order.invoiceItemList.length; i++) {
      var singleItem = order.invoiceItemList[i];
      totalItemDiscountAmount = getSingleItemDiscountMinusAmount(singleItem) +
          totalItemDiscountAmount;
    }

    return totalItemDiscountAmount;
  }

  static double getMainDiscountAmount(Order order) {
    final double subTotal = double.parse(order.subTotal);
    final int discount = order.discount;
    final discountType = order.discountType;

    dynamic discountAmount = 0;

    switch (discountType) {
      case '%':
        discountAmount =
            Util.twoDecimalDigit(number: (subTotal * discount / 100));
        break;

      case '৳':
        discountAmount =
            Util.twoDecimalDigit(number: (double.parse(discount.toString())));
        break;
    }

    return discountAmount;
  }

  static double getAllTotalDiscount(Order order) {
    final totalDiscount =
        getTotalItemDiscountAmount(order) + getMainDiscountAmount(order);

    return totalDiscount;
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
