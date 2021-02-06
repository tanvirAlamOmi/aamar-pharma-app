import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pharmacy_app/src/models/order/request_order.dart';
import 'package:pharmacy_app/src/util/util.dart';

class RequestOrderCard extends StatelessWidget {
  final RequestOrder requestOrder;
  RequestOrderCard({this.requestOrder, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Util.removeFocusNode(context),
      child: Container(
        padding: EdgeInsets.fromLTRB(25, 10, 25, 10),
        width: double.infinity,
        child: Material(
          shadowColor: Colors.grey[100].withOpacity(0.4),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          elevation: 1,
          clipBehavior: Clip.antiAlias, // Add This
          child: buildBody(context),
        ),
      ),
    );
  }

  Widget buildBody(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        GestureDetector(
          child: Container(
            height: 90,
            color: Colors.white,
            padding: EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 60,
                  child: CachedNetworkImage(
                    imageUrl: requestOrder.image ?? Util.getStaticImageURL(),
                    placeholder: (context, url) => new Image.asset(
                      'assets/images/default_loading_image.png',
                    ),
                    errorWidget: (context, url, error) => new Icon(Icons.error),
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 250,
                  ),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(requestOrder.itemName,
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold)),
                      SizedBox(height: 5),
                      Text('${requestOrder.quantity.toString()} piece(s)',
                          style: TextStyle(
                              color: new Color.fromARGB(255, 4, 72, 71)))
                    ],
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
