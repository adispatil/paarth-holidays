import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../auth/login/login_screen.dart';

class OnboardingController extends GetxController {
  var selectedPageIndex = 0.obs;
  bool get isLastPage => selectedPageIndex.value == 2;
  var pageController = PageController();

  forwardAction() {
    if (isLastPage) {
      setOnboardingComplete();
      Get.off(() => LoginScreen());
    } else {
      pageController.nextPage(duration: 300.milliseconds, curve: Curves.ease);
    }
  }

  List<String> onboardingImages = [
    'assets/images/onb1_img1.png',
    'assets/images/onb2_img2.png',
    'assets/images/onb3_img3.png',
  ];

  List<String> onboardingBackgrounds = [
    'assets/images/onb1_bg.png',
    'assets/images/onb2_bg.png',
    'assets/images/onb3_bg.png',
  ];

  List<String> titles = [
    'Explore',
    'Easy Peasy',
    'Enjoy Tour',
  ];

  List<String> descriptions = [
    'Explore your favourite destination\naround the world.',
    'Make your travel experience very\neasy & peasy.',
    'Enjoy your favourite destination with\nyour love one.',
  ];

  Future<void> setOnboardingComplete() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasCompletedOnboarding', true);
  }
} 