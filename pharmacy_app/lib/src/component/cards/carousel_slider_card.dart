import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pharmacy_app/src/component/cards/homepage_slider_single_card.dart';

class CarouselSliderCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(25, 10, 25, 10),
      child: Material(
        shadowColor: Colors.grey[100].withOpacity(0.4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0.0)),
        elevation: 5,
        clipBehavior: Clip.antiAlias, // Add This
        child: buildBody(),
      ),
    );
  }

  Widget buildBody() {
    return CarouselSlider(
      options: CarouselOptions(
        height: 150,
        aspectRatio: 3,
        viewportFraction: 1,
        initialPage: 0,
        enableInfiniteScroll: true,
        reverse: false,
        autoPlay: true,
      ),
      items: [1, 2, 3].map((i) {
        return Builder(
          builder: (BuildContext context) {
            return HomePageSliderSingleCard();
          },
        );
      }).toList(),
    );
  }
}
