import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pharmacy_app/src/component/buttons/circle_cross_button.dart';
import 'package:pharmacy_app/src/component/cards/homepage_slider_single_card.dart';
import 'package:pharmacy_app/src/models/order/deliver_address_details.dart';
import 'package:pharmacy_app/src/store/store.dart';
import 'package:pharmacy_app/src/util/util.dart';

class AllAddressCard extends StatelessWidget {
  final Function() callBackRefreshUI;
  final TextEditingController addressIndexController;

  const AllAddressCard(
      {Key key, this.addressIndexController, this.callBackRefreshUI})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(30, 5, 30, 5),
      child: Material(
        shadowColor: Colors.grey[100].withOpacity(0.4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0.0)),
        elevation: 0,
        clipBehavior: Clip.antiAlias,
        // Add This
        child: buildBody(),
      ),
    );
  }

  Widget buildBody() {
    if (Store.instance.appState.allDeliveryAddress.length == 0)
      return Container();

    return Column(
        children: Store.instance.appState.allDeliveryAddress
            .map((singleDeliveryAddress) {
      return GestureDetector(
        onTap: () {
          addressIndexController.text = Store
              .instance.appState.allDeliveryAddress
              .indexOf(singleDeliveryAddress)
              .toString();
          callBackRefreshUI();
        },
        child: Container(
          padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
          color: Colors.transparent,
          width: double.infinity,
          child: Material(
            shadowColor: Colors.grey[100].withOpacity(0.45),
            shape: RoundedRectangleBorder(
                side: BorderSide(
                    color: getSelectedColor(singleDeliveryAddress), width: 0.5),
                borderRadius: BorderRadius.circular(10.0)),
            elevation: 3,
            clipBehavior: Clip.antiAlias,
            child: ListTile(
              title: Text(
                singleDeliveryAddress.addressType,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
              ),
              subtitle: Text(
                singleDeliveryAddress.fullAddress,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
              ),
              trailing: Container(
                alignment: Alignment.center,
                width: 60,
                child: Row(
                  children: [
                    SizedBox(width: 5),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleCrossButton(
                          refreshUI: callBackRefreshUI,
                          callBack: removeItemFromList,
                          objectIdentifier: addressIndexController.text,
                        ),
                        SizedBox(height: 2),
                        Text(
                          "REMOVE",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                              color: Colors.red),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              isThreeLine: true,
            ),
          ),
        ),
      );
    }).toList());
  }

  void removeItemFromList(dynamic item) {
    Store.instance.deleteDeliveryAddress(
        Store.instance.appState.allDeliveryAddress[int.parse(item)]);
  }

  Color getSelectedColor(DeliveryAddressDetails deliveryAddressDetails) {
    if (int.parse(addressIndexController.text) ==
        Store.instance.appState.allDeliveryAddress
            .indexOf(deliveryAddressDetails)) return Util.greenishColor();

    return Colors.transparent;
  }
}
