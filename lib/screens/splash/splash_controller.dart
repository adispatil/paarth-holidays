import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../services/storage_service.dart';
import '../auth/login/login_screen.dart';
import '../home/home_screen.dart';
import '../onboarding/onboarding_screen.dart';
import '../auth/login/add_profile_details_screen.dart';

class SplashController extends GetxController {
  late final StorageService _storageService;

  @override
  void onInit() async {
    super.onInit();
    final prefs = await SharedPreferences.getInstance();
    _storageService = StorageService(prefs);

    // Add delay to show splash screen
    await Future.delayed(const Duration(seconds: 2));
    // Get.offAll(() => LoginScreen());
    checkAuthAndNavigate();
  }

  void checkAuthAndNavigate() {
    final token = _storageService.getToken();
    final isFirstTime = _storageService.getIsFirstTime() ?? true;
    final isProfileCompleted = _storageService.getIsProfileCompleted();

    if (token != null && token.isNotEmpty) {
      if (!isProfileCompleted) {
        // Token exists but profile not completed
        Get.offAll(() => AddProfileDetailsScreen(mobileNumber: ''));
      } else {
        // Token exists, navigate to home screen
        Get.offAll(() => HomeScreen());
      }
    } else if (isFirstTime) {
      // First time user, navigate to onboarding
      Get.offAll(() => OnboardingScreen());
      _storageService.setIsFirstTime(false);
    } else {
      // Not first time but no token, navigate to login
      Get.offAll(() => LoginScreen());

      // TODO: This is just for testing. remove below line and uncomment above line
      // Get.offAll(() => HomeScreen());
    }
  }
}
