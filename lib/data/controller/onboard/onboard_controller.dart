import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ovowpp/core/utils/my_images.dart';
import 'package:ovowpp/core/utils/util.dart';

import '../../../core/translations/strings_enum.dart';

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
      title: Strings.onboardTitle1,
      description: Strings.onboardDescription1,
    ),
    OnBoardItemModel(
      image: MyImages.onBoardImageTwo,
      title: Strings.onboardTitle2,
      description: Strings.onboardDescription2,
    ),
    OnBoardItemModel(
      image: MyImages.onBoardImageThree,
      title: Strings.onboardTitle3,
      description: Strings.onboardDescription3,
    ),
  ];
}

class OnBoardItemModel {
  final String image;
  final String title;
  final String description;

  OnBoardItemModel({required this.image, required this.title, required this.description});
}
