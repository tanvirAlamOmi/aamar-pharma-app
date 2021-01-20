import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pharmacy_app/src/component/buttons/add_delivery_address_button.dart';
import 'package:pharmacy_app/src/component/buttons/general_action_round_button.dart';
import 'package:pharmacy_app/src/component/cards/all_address_card.dart';
import 'package:pharmacy_app/src/component/cards/order_delivery_time_card.dart';
import 'package:pharmacy_app/src/component/cards/order_repeat_order_card.dart';
import 'package:pharmacy_app/src/component/cards/order_invoice_table_card.dart';
import 'package:pharmacy_app/src/component/cards/personal_details_card.dart';
import 'package:pharmacy_app/src/component/general/app_bar_back_button.dart';
import 'package:pharmacy_app/src/models/general/Order_Enum.dart';
import 'package:pharmacy_app/src/models/order/order.dart';
import 'package:pharmacy_app/src/pages/order_details_page.dart';
import 'package:pharmacy_app/src/store/store.dart';
import 'package:pharmacy_app/src/util/util.dart';
import 'package:pharmacy_app/src/models/general/Enum_Data.dart';

class OrderFinalInvoicePage extends StatefulWidget {
  final Order order;

  OrderFinalInvoicePage({this.order, Key key}) : super(key: key);

  @override
  _OrderFinalInvoicePageState createState() => _OrderFinalInvoicePageState();
}

class _OrderFinalInvoicePageState extends State<OrderFinalInvoicePage> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool isProcessing = false;

  double subTotal = 0;
  double deliveryFee = 0;
  double totalAmount = 0;

  List<String> deliveryTimeDay = ["Today", "Tomorrow"];
  String selectedDeliveryTimeDay;

  List<String> deliveryTimeTime = [];
  String selectedDeliveryTimeTime;

  List<String> repeatDeliveryLongGap = ["Week", "15 Days", "1 Month"];
  String selectedRepeatDeliveryLongGap;

  List<String> repeatDeliveryDayBar = [
    "Saturday",
    "Sunday",
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday"
  ];
  String selectedRepeatDeliveryDayBar;

  DateTime selectedRepeatDeliveryTime;

  bool checkedRepeatOrder = false;

  int selectedDeliveryAddressIndex = 0;

  TextEditingController fullAddressController;
  TextEditingController nameController;
  TextEditingController emailController;
  TextEditingController phoneController;

  final TextStyle textStyle = new TextStyle(fontSize: 12, color: Colors.black);

  @override
  void initState() {
    super.initState();
    setSelectionData();
    calculatePricing();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void setSelectionData() {
    selectedDeliveryTimeDay = deliveryTimeDay[0];
    createDeliveryTimeTime();
    selectedRepeatDeliveryLongGap = repeatDeliveryLongGap[0];
    selectedRepeatDeliveryDayBar = repeatDeliveryDayBar[0];
    selectedRepeatDeliveryTime = DateTime.now();
    fullAddressController = new TextEditingController(
        text: widget.order.deliveryAddressDetails.address);
    nameController = new TextEditingController(
        text: widget.order.user.name);
    emailController = new TextEditingController(
        text: widget.order.user.email);
    phoneController = new TextEditingController(
        text: widget.order.user.phone);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) currentFocus.unfocus();
      },
      child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            elevation: 1,
            centerTitle: true,
            leading: AppBarBackButton(),
            title: Text(
              'ORDER DETAILS',
              style: TextStyle(color: Colors.white),
            ),
          ),
          body: buildBody(context)),
    );
  }

  Widget buildBody(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            buildReOrderButton(),
            buildPharmaAddress(),
            buildDivider(),
            buildOrderAddress(),
            buildDivider(),
            buildViewOrderDetailsButton(),
            SizedBox(height: 20),
            OrderInvoiceTableCard(
              subTotal: subTotal,
              deliveryFee: deliveryFee,
              totalAmount: totalAmount,
              order: widget.order,
              dynamicTable: false,
            ),
            OrderDeliveryAddressCard(
              callBackRefreshUI: refreshUI,
              deliveryTimeDay: deliveryTimeDay,
              selectedDeliveryTimeDay: selectedDeliveryTimeDay,
              setSelectedDeliveryTimeDay: setSelectedDeliveryTimeDay,
              deliveryTimeTime: deliveryTimeTime,
              selectedDeliveryTimeTime: selectedDeliveryTimeTime,
              setSelectedDeliveryTimeTime: setSelectedDeliveryTimeTime,
            ),
            OrderRepeatOrderCard(
              callBackRefreshUI: refreshUI,
              checkedRepeatOrder: checkedRepeatOrder,
              setRepeatOrder: setRepeatOrder,
              repeatDeliveryLongGap: repeatDeliveryLongGap,
              selectedRepeatDeliveryLongGap: selectedRepeatDeliveryLongGap,
              setRepeatDeliveryLongGap: setSelectedRepeatDeliveryLongGap,
              repeatDeliveryDayBar: repeatDeliveryDayBar,
              selectedRepeatDeliveryDayBar: selectedRepeatDeliveryDayBar,
              setSelectedRepeatDeliveryDayBar: setSelectedRepeatDeliveryDayBar,
              selectedRepeatDeliveryTime: selectedRepeatDeliveryTime,
              setSelectedRepeatDeliveryTime: setSelectedRepeatDeliveryTime,
            ),
            AddDeliveryAddressButton(callBack: refreshUI),
            AllAddressCard(
                selectedDeliveryAddressIndex: selectedDeliveryAddressIndex,
                setSelectedDeliveryAddressIndex:
                    setSelectedDeliveryAddressIndex,
                callBackRefreshUI: refreshUI),
            PersonalDetailsCard(
                nameController: nameController,
                phoneController: phoneController,
                emailController: emailController),
            SizedBox(height: 20)
          ],
        ),
      ),
    );
  }

  void calculatePricing() {
    subTotal = 0;
    deliveryFee = 20;
    totalAmount = 0;
    for (final singleItem in widget.order.invoice.invoiceItemList) {
      final unitPrice = double.parse(singleItem.itemUnitPrice);
      final quantity = double.parse(singleItem.itemQuantity);
      subTotal = subTotal + (unitPrice * quantity);
    }

    totalAmount = subTotal + deliveryFee;
  }

  Widget buildReOrderButton() {
    if (widget.order.status != OrderEnum.ORDER_STATUS_DELIVERED)
      return Container();
    return GeneralActionRoundButton(
      title: "REORDER",
      isProcessing: isProcessing,
      callBackOnSubmit: () {},
    );
  }

  Widget buildPharmaAddress() {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 10, 22, 0),
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              "Amar Pharma",
              style: TextStyle(
                  color: Util.purplishColor(),
                  fontWeight: FontWeight.bold,
                  fontSize: 15),
            ),
          ),
          SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: size.width / 2 - 50,
                alignment: Alignment.centerLeft,
                child: Text(
                  "31 Street, Mirpur DOHS \n"
                  "Dhaka, Bangladesh. ",
                  style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.normal,
                      fontSize: 11),
                ),
              ),
              Container(
                width: size.width / 2 - 50,
                alignment: Alignment.centerLeft,
                child: Text(
                  "+88012-35359552\n"
                  "arbree@amarpharma.com",
                  style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.normal,
                      fontSize: 11),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget buildOrderAddress() {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 10, 22, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: size.width / 2 - 50,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Invoice Number",
                    style: TextStyle(
                        color: Util.purplishColor(),
                        fontWeight: FontWeight.bold,
                        fontSize: 13),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "0001",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.normal,
                        fontSize: 11),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Date Of Issue",
                    style: TextStyle(
                        color: Util.purplishColor(),
                        fontWeight: FontWeight.bold,
                        fontSize: 13),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "20/02/15",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.normal,
                        fontSize: 11),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          Container(
            width: size.width / 2 - 50,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Billed to",
                    style: TextStyle(
                        color: Util.purplishColor(),
                        fontWeight: FontWeight.bold,
                        fontSize: 13),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    widget.order.deliveryAddressDetails.address,
                    style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.normal,
                        fontSize: 11),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    widget.order.deliveryAddressDetails.area,
                    style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.normal,
                        fontSize: 11),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    widget.order.user.phone,
                    style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.normal,
                        fontSize: 11),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget buildViewOrderDetailsButton() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 7, 20, 7),
      color: Colors.transparent,
      width: double.infinity,
      child: Material(
        shadowColor: Colors.grey[100].withOpacity(0.4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
        elevation: 3,
        clipBehavior: Clip.antiAlias, // Add This
        child: ListTile(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => OrderDetailsPage(
                        order: widget.order,
                      )),
            );
          },
          title: Text("View Order Details",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Util.greenishColor(),
                  fontSize: 14)),
          trailing: Icon(Icons.keyboard_arrow_right),
        ),
      ),
    );
  }

  Widget buildDivider() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: Divider(height: 3, thickness: 2),
    );
  }

  void setSelectedDeliveryTimeDay(dynamic value) {
    selectedDeliveryTimeDay = value;
    createDeliveryTimeTime();
  }

  void setSelectedDeliveryTimeTime(dynamic value) {
    selectedDeliveryTimeTime = value;
  }

  void setSelectedRepeatDeliveryLongGap(dynamic value) {
    selectedRepeatDeliveryLongGap = value;
  }

  void setSelectedRepeatDeliveryDayBar(dynamic value) {
    selectedRepeatDeliveryDayBar = value;
  }

  void setSelectedRepeatDeliveryTime(DateTime value) {
    selectedRepeatDeliveryTime = value;
  }

  void setSelectedDeliveryAddressIndex(int index) {
    selectedDeliveryAddressIndex = index;
  }

  void setRepeatOrder(value) {
    checkedRepeatOrder = value;
  }

  void createDeliveryTimeTime() {
    deliveryTimeTime.clear();
    DateTime currentTime = DateTime.now();
    DateTime officeTime = DateTime(
        currentTime.year, currentTime.month, currentTime.day, 10, 00, 00);
    final DateTime timeLimit = DateTime(
        currentTime.year, currentTime.month, currentTime.day, 22, 00, 00);
    int x = 0;

    if (selectedDeliveryTimeDay == deliveryTimeDay[0]) {
      while (currentTime.isBefore(timeLimit)) {
        if (currentTime.add(Duration(minutes: 90)).isAfter(timeLimit)) break;

        deliveryTimeTime.add(
            Util.formatDateToStringOnlyHourMinute(currentTime) +
                "-" +
                Util.formatDateToStringOnlyHourMinute(
                    currentTime.add(Duration(minutes: 90))));
        currentTime = currentTime.add(Duration(minutes: 90));
      }
    }

    if (selectedDeliveryTimeDay == deliveryTimeDay[1]) {
      while (officeTime.isBefore(timeLimit)) {
        if (officeTime.add(Duration(minutes: 90)).isAfter(timeLimit)) break;

        deliveryTimeTime.add(Util.formatDateToStringOnlyHourMinute(officeTime) +
            "-" +
            Util.formatDateToStringOnlyHourMinute(
                officeTime.add(Duration(minutes: 90))));
        officeTime = officeTime.add(Duration(minutes: 90));
      }
    }

    selectedDeliveryTimeTime = deliveryTimeTime[0];
    if (mounted) setState(() {});
  }

  void submitOrder() {
    print(selectedDeliveryAddressIndex);
    if (Store.instance.appState.allDeliveryAddress.length == 0)
      Util.showSnackBar(
          scaffoldKey: _scaffoldKey, message: "Please add a delivery address");
  }

  void refreshUI() {
    if (mounted) setState(() {});
  }
}

enum CHOICE_ENUM { DELIVERY_DAY, DELIVERY_TIME }
