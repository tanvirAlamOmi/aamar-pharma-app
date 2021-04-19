import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:pharmacy_app/src/bloc/stream.dart';
import 'package:pharmacy_app/src/models/states/event.dart';
import 'package:flutter/material.dart';
import 'package:pharmacy_app/src/component/buttons/circle_cross_button.dart';
import 'package:pharmacy_app/src/util/util.dart';

import 'common_ui.dart';

class CustomCarouselSlider extends StatefulWidget {
  final List<Widget> carouselListWidget;
  final bool showRemoveImageButton;
  final double height;
  final bool autoPlay;
  final Function(dynamic itemIndex) removeItemFunction;
  final Function() refreshUI;

  const CustomCarouselSlider(
      {Key key,
      this.carouselListWidget,
      this.refreshUI,
      this.showRemoveImageButton,
      this.height,
      this.autoPlay,
      this.removeItemFunction})
      : super(key: key);

  @override
  _CustomCarouselSliderState createState() => _CustomCarouselSliderState();
}

class _CustomCarouselSliderState extends State<CustomCarouselSlider> {
  int currentIndex = 0;
  CarouselController _carouselController = CarouselController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildImageList(),
        SizedBox(height: 10),
        buildRemoveImageButton(),
        SizedBox(height: 10),
      ],
    );
  }

  Widget buildImageList() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          alignment: Alignment.center,
          width: 30,
          height: 30,
          child: IconButton(
              icon: Icon(
                Icons.chevron_left,
                color: Util.greenishColor(),
              ),
              padding: EdgeInsets.only(left: 3),
              iconSize: 25,
              splashRadius: 15,
              onPressed: () {
                _carouselController.previousPage(
                    duration: Duration(milliseconds: 500),
                    curve: Curves.linear);
              }),
        ),
        Expanded(
          child: CarouselSlider(
            carouselController: _carouselController,
            options: CarouselOptions(
                height: 200,
                viewportFraction: 1,
                initialPage: 0,
                enableInfiniteScroll: true,
                reverse: false,
                autoPlay: widget.autoPlay,
                onPageChanged: (index, reason) {
                  currentIndex = index;
                  widget.refreshUI();
                }),
            items: widget.carouselListWidget,
          ),
        ),
        Container(
          alignment: Alignment.center,
          width: 30,
          height: 30,
          child: IconButton(
              icon: Icon(
                Icons.chevron_right,
                color: Util.greenishColor(),
              ),
              padding: EdgeInsets.only(right: 10),
              iconSize: 25,
              splashRadius: 15,
              onPressed: () {
                _carouselController.nextPage(
                    duration: Duration(milliseconds: 500),
                    curve: Curves.linear);
              }),
        ),
      ],
    );
  }

  Widget buildRemoveImageButton() {
    if (!widget.showRemoveImageButton) return Container();
    return Container(
      width: 150,
      alignment: Alignment.center,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleCrossButton(
            callBackDeleteItem: widget.removeItemFunction,
            refreshUI: widget.refreshUI,
            objectIdentifier: currentIndex,
            iconSize: 18,
            width: 25,
            height: 25,
          ),
          SizedBox(width: 5),
          CustomText('REMOVE', color: Colors.red, fontWeight: FontWeight.w500, fontSize: 12)
        ],
      ),
    );
  }
}
