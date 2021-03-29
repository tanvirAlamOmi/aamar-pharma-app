import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pharmacy_app/src/component/cards/homepage_slider_single_card.dart';
import 'package:pharmacy_app/src/models/general/ui_view_data.dart';
import 'package:pharmacy_app/src/util/util.dart';

class HomePageCarouselSliderCard extends StatefulWidget {
  @override
  _HomePageCarouselSliderCardState createState() =>
      _HomePageCarouselSliderCardState();
}

class _HomePageCarouselSliderCardState
    extends State<HomePageCarouselSliderCard> {
  final listItems = [
    UIViewData()..imageUrl = 'assets/slider/1.png',
    UIViewData()..imageUrl = 'assets/slider/2.png',
    UIViewData()..imageUrl = 'assets/slider/3.png'
  ];
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(27, 0, 27, 0),
      child: Material(
        shadowColor: Colors.grey[100].withOpacity(0.4),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        elevation: 0,
        clipBehavior: Clip.antiAlias, // Add This
        child: buildBody(),
      ),
    );
  }

  Widget buildBody() {
    return Column(
      children: [buildCarouselSlider(), buildCarouselNumber()],
    );
  }

  Widget buildCarouselSlider() {
    return CarouselSlider(
      options: CarouselOptions(
          height: 200,
          viewportFraction: 1,
          initialPage: 0,
          enableInfiniteScroll: true,
          reverse: false,
          autoPlay: true,
          onPageChanged: (index, reason) {
            setState(() {
              _currentIndex = index;
            });
          }),
      items: listItems.map((singleData) {
        return Builder(
          builder: (BuildContext context) {
            return HomePageSliderSingleCard(uiViewData: singleData);
          },
        );
      }).toList(),
    );
  }

  Widget buildCarouselNumber() {
    return Container(
      color: Colors.transparent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: listItems.map(
          (image) {
            int index = listItems.indexOf(image);
            return Container(
              width: 8.0,
              height: 8.0,
              margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentIndex == index
                      ? Util.purplishColor()
                      : Color.fromRGBO(0, 0, 0, 0.4)),
            );
          },
        ).toList(),
      ),
    );
  }
}
