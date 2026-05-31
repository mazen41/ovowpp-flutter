import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ovowpp/core/utils/my_images.dart';
import 'package:ovowpp/core/utils/util.dart';

import '../../../core/utils/my_strings.dart';

class OnboardController extends GetxController {
  PageController? pageController = PageController();
  int currentIndex = 0;
  void setCurrentIndex(int index) {
    currentIndex = index;
    printX("Current index $currentIndex");
    update();
  }

  List<OnBoardItemModel> onBoardDataList = [
    OnBoardItemModel(
      image: MyImages.onBoardImageOne,
      title: MyStrings.onboardTitle1,
      description: MyStrings.onboardDescription1,
    ),
    OnBoardItemModel(
      image: MyImages.onBoardImageTwo,
      title: MyStrings.onboardTitle2,
      description: MyStrings.onboardDescription2,
    ),
    OnBoardItemModel(
      image: MyImages.onBoardImageThree,
      title: MyStrings.onboardTitle3,
      description: MyStrings.onboardDescription3,
    ),
  ];
}

class OnBoardItemModel {
  final String image;
  final String title;
  final String description;

  OnBoardItemModel({required this.image, required this.title, required this.description});
}
