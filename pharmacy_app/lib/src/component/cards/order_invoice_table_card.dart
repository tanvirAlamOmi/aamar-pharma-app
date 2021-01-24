import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pharmacy_app/src/component/buttons/circle_cross_button.dart';
import 'package:pharmacy_app/src/models/general/Enum_Data.dart';
import 'package:pharmacy_app/src/models/order/invoice_item.dart';
import 'package:pharmacy_app/src/models/order/order.dart';
import 'package:pharmacy_app/src/models/states/ui_state.dart';
import 'package:pharmacy_app/src/pages/confirm_invoice_page.dart';
import 'package:pharmacy_app/src/pages/order_details_page.dart';
import 'package:pharmacy_app/src/pages/order_final_invoice_page.dart';
import 'package:pharmacy_app/src/util/util.dart';

class OrderInvoiceTableCard extends StatelessWidget {
  final Order order;
  final double subTotal;
  final double deliveryFee;
  final double totalAmount;

  final Function(InvoiceItem singleItem) callBackIncrementItemQuantity;
  final Function(InvoiceItem singleItem) callBackDecrementItemQuantity;
  final Function(InvoiceItem singleItem) callBackRemoveItem;
  final Function() callBackCalculatePricing;
  final Function() callBackRefreshUI;

  final bool showCrossColumn;
  final bool showItemNameColumn;
  final bool showUnitCostColumn;
  final bool showQuantityColumn;
  final bool showAmountColumn;
  final bool showIncDecButtons;
  final bool showSubTotalRow;
  final bool showTotalRow;

  final TextStyle columnTextStyle = new TextStyle(
      fontSize: 12, color: Util.purplishColor(), fontWeight: FontWeight.bold);

  final TextStyle textStyle = new TextStyle(fontSize: 12, color: Colors.black);

  final TextStyle dataTextStyle = new TextStyle(
      fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold);

  OrderInvoiceTableCard(
      {Key key,
      this.order,
      this.subTotal,
      this.deliveryFee,
      this.totalAmount,
      this.callBackIncrementItemQuantity,
      this.callBackDecrementItemQuantity,
      this.callBackCalculatePricing,
      this.callBackRefreshUI,
      this.callBackRemoveItem,
      this.showCrossColumn,
      this.showUnitCostColumn,
      this.showQuantityColumn,
      this.showAmountColumn,
      this.showIncDecButtons,
      this.showSubTotalRow,
      this.showTotalRow,
      this.showItemNameColumn})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Util.removeFocusNode(context),
      child: Container(
        padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
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

    children.add(TableRow(children: [
      customTableCell(Text(showCrossColumn ? "" : "", style: columnTextStyle)),
      customTableCell(
          Text(showItemNameColumn ? "Item" : "", style: columnTextStyle),
          alignment: Alignment.centerLeft),
      customTableCell(
          Text(showUnitCostColumn ? "Unit Cost" : "", style: columnTextStyle)),
      customTableCell(
          Text(showQuantityColumn ? "Quantity" : "", style: columnTextStyle)),
      customTableCell(
          Text(showAmountColumn ? "Amount" : "", style: columnTextStyle),
          alignment: Alignment.centerRight),
    ]));

    order.invoice.invoiceItemList.forEach((singleItem) {
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
        customTableCell(Text("Subtotal", style: columnTextStyle)),
        customTableCell(Text(subTotal.toString(), style: dataTextStyle),
            alignment: Alignment.centerRight),
      ]));

      children.add(TableRow(children: [
        customTableCell(Text("", style: columnTextStyle)),
        customTableCell(Text("", style: columnTextStyle),
            alignment: Alignment.centerLeft),
        customTableCell(Text("", style: columnTextStyle)),
        customTableCell(Text("Delivery Fee", style: columnTextStyle)),
        customTableCell(Text(deliveryFee.toString(), style: dataTextStyle),
            alignment: Alignment.centerRight),
      ]));
    }

    if (showTotalRow) {
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
        customTableCell(Text("Total",
            style: TextStyle(
                fontSize: 15,
                color: Util.purplishColor(),
                fontWeight: FontWeight.bold))),
        customTableCell(
            Text(totalAmount.toString(),
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
      callBackAdditional: callBackCalculatePricing,
      width: 15.5,
      height: 15.5,
      iconSize: 13,
    );
  }

  Widget buildItemNameColumn(InvoiceItem singleItem) {
    if (showItemNameColumn != true) return Text("");
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
        child: Text(singleItem.itemUnitPrice, style: dataTextStyle));
  }

  Widget buildQuantityColumn(InvoiceItem singleItem) {
    if (showQuantityColumn == true && showIncDecButtons == false)
      return Container(
          alignment: Alignment.center,
          width: 25,
          child: Text(singleItem.itemQuantity, style: dataTextStyle));
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
                callBackCalculatePricing();
              },
              child: Container(
                  width: 17,
                  height: 17,
                  child: Icon(Icons.remove, color: Colors.black, size: 13.5),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.redAccent))),
            ),
            Container(
                alignment: Alignment.center,
                width: 25,
                child: Text(singleItem.itemQuantity, style: dataTextStyle)),
            GestureDetector(
              onTap: () {
                callBackIncrementItemQuantity(singleItem);
                callBackCalculatePricing();
              },
              child: Container(
                  width: 17,
                  height: 17,
                  child: Icon(Icons.add, color: Colors.black, size: 13.5),
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
        child: Text(singleItem.itemQuantity, style: dataTextStyle));
  }

  Widget buildAmountColumn(InvoiceItem singleItem) {
    if (showAmountColumn != true) return Text("");
    return Container(
        alignment: Alignment.centerRight,
        width: double.infinity,
        child: Text(getPrice(singleItem), style: dataTextStyle));
  }

  String getPrice(InvoiceItem singleItem) {
    final unitPrice = double.parse(singleItem.itemUnitPrice);
    final quantity = double.parse(singleItem.itemQuantity);
    final price = (unitPrice * quantity).toString();
    return price;
  }
}
