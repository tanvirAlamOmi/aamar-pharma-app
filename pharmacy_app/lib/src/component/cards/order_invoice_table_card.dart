import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pharmacy_app/src/component/buttons/circle_cross_button.dart';
import 'package:pharmacy_app/src/models/order/invoice_item.dart';
import 'package:pharmacy_app/src/models/order/order.dart';
import 'package:pharmacy_app/src/util/en_bn_dict.dart';
import 'package:pharmacy_app/src/util/util.dart';
import 'package:pharmacy_app/src/util/order_util.dart';

class OrderInvoiceTableCard extends StatelessWidget {
  final Order order;

  final Function(InvoiceItem singleItem) callBackIncrementItemQuantity;
  final Function(InvoiceItem singleItem) callBackDecrementItemQuantity;
  final Function(InvoiceItem singleItem) callBackRemoveItem;
  final Function() callBackRefreshUI;

  final bool showCrossColumn;
  final bool showItemNameColumn;
  final bool showUnitCostColumn;
  final bool showQuantityColumn;
  final bool showAmountColumn;
  final bool showIncDecButtons;
  final bool showSubTotalRow;
  final bool showGrandTotalRow;

  final EdgeInsetsGeometry padding;

  final TextStyle columnTextStyle = new TextStyle(
      fontSize: 12, color: Util.purplishColor(), fontWeight: FontWeight.bold);

  final TextStyle textStyle = new TextStyle(fontSize: 12, color: Colors.black);

  final TextStyle dataTextStyle = new TextStyle(
      fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold);

  OrderInvoiceTableCard(
      {Key key,
      this.order,
      this.callBackIncrementItemQuantity,
      this.callBackDecrementItemQuantity,
      this.callBackRefreshUI,
      this.callBackRemoveItem,
      this.showCrossColumn,
      this.showUnitCostColumn,
      this.showQuantityColumn,
      this.showAmountColumn,
      this.showIncDecButtons,
      this.showSubTotalRow,
      this.showGrandTotalRow,
      this.showItemNameColumn,
      this.padding})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Util.removeFocusNode(context),
      child: Container(
        padding: padding ?? EdgeInsets.fromLTRB(0, 0, 0, 10),
        width: double.infinity,
        child: Material(
          shadowColor: Colors.grey[100].withOpacity(0.4),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          elevation: 0,
          clipBehavior: Clip.antiAlias, // Add This
          child: buildBody(context),
        ),
      ),
    );
  }

  Widget buildBody(BuildContext context) {
    return buildInvoice();
  }

  Widget buildInvoice() {
    final children = List<TableRow>();

    // Top Row with Column Name
    children.add(TableRow(children: [
      customTableCell(Text(showCrossColumn ? "" : "", style: columnTextStyle)),
      customTableCell(
          Text(showItemNameColumn ? EnBnDict.en_bn_convert(text: 'Item') : "",
              style: columnTextStyle),
          alignment: Alignment.centerLeft),
      customTableCell(Text(
          showUnitCostColumn ? EnBnDict.en_bn_convert(text: 'Unit Cost') : "",
          style: columnTextStyle)),
      customTableCell(Text(
          showQuantityColumn ? EnBnDict.en_bn_convert(text: 'Quantity') : "",
          style: columnTextStyle)),
      customTableCell(
          Text(showAmountColumn ? EnBnDict.en_bn_convert(text: 'Amount') : "",
              style: columnTextStyle),
          alignment: Alignment.centerRight),
    ]));

    order.invoiceItemList.forEach((singleItem) {
      // Table Values
      children.add(TableRow(children: [
        customTableCell(buildCrossColumn(singleItem)),
        customTableCell(buildItemNameColumn(singleItem),
            alignment: Alignment.centerLeft),
        customTableCell(buildUnitCostColumn(singleItem)),
        customTableCell(buildQuantityColumn(singleItem)),
        customTableCell(buildAmountColumn(singleItem),
            alignment: Alignment.centerRight),
      ]));
    });

    if (showSubTotalRow) {
      children.add(TableRow(children: [
        customTableCell(Divider(height: 2, thickness: 2)),
        customTableCell(Divider(height: 2, thickness: 2)),
        customTableCell(Divider(height: 2, thickness: 2)),
        customTableCell(Divider(height: 2, thickness: 2)),
        customTableCell(Divider(height: 2, thickness: 2)),
      ]));
      children.add(TableRow(children: [
        customTableCell(Text("", style: columnTextStyle)),
        customTableCell(Text("", style: columnTextStyle),
            alignment: Alignment.centerLeft),
        customTableCell(Text("", style: columnTextStyle)),
        customTableCell(Text(EnBnDict.en_bn_convert(text: 'Subtotal'),
            style: columnTextStyle)),
        customTableCell(
            Text('৳' + EnBnDict.en_bn_number_convert(number: order.subTotal),
                style: dataTextStyle),
            alignment: Alignment.centerRight),
      ]));

      children.add(TableRow(children: [
        customTableCell(Text("", style: columnTextStyle)),
        customTableCell(Text("", style: columnTextStyle),
            alignment: Alignment.centerLeft),
        customTableCell(Text("", style: columnTextStyle)),
        customTableCell(Text(EnBnDict.en_bn_convert(text: 'Delivery Fee'),
            style: columnTextStyle)),
        customTableCell(
            Text(
                '৳' +
                    EnBnDict.en_bn_number_convert(number: order.deliveryCharge),
                style: dataTextStyle),
            alignment: Alignment.centerRight),
      ]));

      children.add(TableRow(children: [
        customTableCell(Text("", style: columnTextStyle)),
        customTableCell(Text("", style: columnTextStyle),
            alignment: Alignment.centerLeft),
        customTableCell(Text("", style: columnTextStyle)),
        customTableCell(Text(
            EnBnDict.en_bn_convert(text: 'Discount') +
                '(' +
                EnBnDict.en_bn_number_convert(number: order.discount) +
                '%' +
                ')',
            style: columnTextStyle)),
        customTableCell(Text('৳' + getDiscountAmount(), style: dataTextStyle),
            alignment: Alignment.centerRight),
      ]));
    }

    if (showGrandTotalRow) {
      children.add(TableRow(children: [
        customTableCell(Divider(height: 2, thickness: 2)),
        customTableCell(Divider(height: 2, thickness: 2)),
        customTableCell(Divider(height: 2, thickness: 2)),
        customTableCell(Divider(height: 2, thickness: 2)),
        customTableCell(Divider(height: 2, thickness: 2)),
      ]));

      children.add(TableRow(children: [
        customTableCell(Text("", style: columnTextStyle)),
        customTableCell(Text("", style: columnTextStyle),
            alignment: Alignment.centerLeft),
        customTableCell(Text("", style: columnTextStyle)),
        customTableCell(Text(EnBnDict.en_bn_convert(text: 'Total'),
            style: TextStyle(
                fontSize: 15,
                color: Util.purplishColor(),
                fontWeight: FontWeight.bold))),
        customTableCell(
            Text('৳' + EnBnDict.en_bn_number_convert(number: order.grandTotal),
                style: TextStyle(
                    color: Colors.black, fontWeight: FontWeight.bold)),
            alignment: Alignment.centerRight),
      ]));
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
      child: Container(
        alignment: Alignment.center,
        width: double.infinity,
        padding: EdgeInsets.fromLTRB(5, 0, 10, 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          border: Border(
            left: BorderSide(color: Colors.grey, width: 0.7),
            top: BorderSide(color: Colors.grey, width: 0.7),
            right: BorderSide(color: Colors.grey, width: 0.7),
            bottom: BorderSide(color: Colors.grey, width: 0.7),
          ),
        ),
        child: Table(
          columnWidths: {
            0: FlexColumnWidth(showCrossColumn ? 0.1 : 0.05),
            1: FlexColumnWidth(showCrossColumn ? 0.2 : 0.25),
            2: FlexColumnWidth(showUnitCostColumn ? 0.2 : 0.05),
            3: FlexColumnWidth(showUnitCostColumn ? 0.3 : 0.5),
            4: FlexColumnWidth(0.2),
          },
          children: children,
        ),
      ),
    );
  }

  TableCell customTableCell(Widget singleWidget,
      {AlignmentGeometry alignment}) {
    return TableCell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 10),
          Container(
            alignment: alignment ?? Alignment.center,
            child: singleWidget,
          )
        ],
      ),
    );
  }

  Widget buildCrossColumn(InvoiceItem singleItem) {
    if (showCrossColumn != true) return Text("");
    return CircleCrossButton(
      callBackDeleteItem: callBackRemoveItem,
      objectIdentifier: singleItem,
      refreshUI: callBackRefreshUI,
      callBackAdditional: () {
        OrderUtil.calculatePricing(order);
        callBackRefreshUI();
      },
      width: 15.5,
      height: 15.5,
      iconSize: 13,
    );
  }

  Widget buildItemNameColumn(InvoiceItem singleItem) {
    if (showItemNameColumn != true) return Text("");
    if (singleItem.isPrescriptionRequired == 'true') {
      return Row(
        children: [
          Container(
              alignment: Alignment.topLeft,
              child: Text(singleItem.itemName, style: dataTextStyle)),
          Container(
              alignment: Alignment.topLeft,
              child: Text('*', style: TextStyle(color: Util.redishColor())))
        ],
      );
    }
    return Container(
        alignment: Alignment.topLeft,
        width: double.infinity,
        child: Text(singleItem.itemName, style: dataTextStyle));
  }

  Widget buildUnitCostColumn(InvoiceItem singleItem) {
    if (showUnitCostColumn != true) return Text("");
    return Container(
        alignment: Alignment.center,
        width: double.infinity,
        child: Text('৳' + EnBnDict.en_bn_number_convert(number: singleItem.rate),
            style: dataTextStyle));
  }

  Widget buildQuantityColumn(InvoiceItem singleItem) {
    if (showQuantityColumn == true && showIncDecButtons == false)
      return Container(
          alignment: Alignment.center,
          width: 25,
          child: Text(
              EnBnDict.en_bn_number_convert(number: singleItem.quantity),
              style: dataTextStyle));
    else if (showQuantityColumn == true && showIncDecButtons == true)
      return Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: () {
                callBackDecrementItemQuantity(singleItem);
                OrderUtil.calculatePricing(order);
                callBackRefreshUI();
              },
              child: Container(
                  width: 20,
                  height: 20,
                  child: Icon(Icons.remove, color: Colors.black, size: 14),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.redAccent))),
            ),
            Container(
                alignment: Alignment.center,
                width: 25,
                child: Text(
                    EnBnDict.en_bn_number_convert(number: singleItem.quantity),
                    style: dataTextStyle)),
            GestureDetector(
              onTap: () {
                callBackIncrementItemQuantity(singleItem);
                OrderUtil.calculatePricing(order);
                callBackRefreshUI();
              },
              child: Container(
                  width: 20,
                  height: 20,
                  child: Icon(Icons.add, color: Colors.black, size: 14),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.redAccent))),
            ),
          ],
        ),
      );
    //Default
    return Container(
        alignment: Alignment.center,
        width: 25,
        child: Text(EnBnDict.en_bn_number_convert(number: singleItem.quantity),
            style: dataTextStyle));
  }

  Widget buildAmountColumn(InvoiceItem singleItem) {
    if (showAmountColumn != true) return Text("");
    return Container(
        alignment: Alignment.centerRight,
        width: double.infinity,
        child: Text('৳' + getPrice(singleItem), style: dataTextStyle));
  }

  String getPrice(InvoiceItem singleItem) {
    final unitPrice = singleItem.rate;
    final quantity = singleItem.quantity;
    final price = Util.twoDecimalDigit(number: unitPrice * quantity);
    return EnBnDict.en_bn_number_convert(number: price);
  }

  String getDiscountAmount() {
    final double subTotal = double.parse(order.subTotal);
    final int discount = order.discount;
    final discountAmount =
        Util.twoDecimalDigit(number: (subTotal * discount / 100)).toString();
    return EnBnDict.en_bn_number_convert(number: discountAmount);
  }
}
