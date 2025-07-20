import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../home/home_screen.dart';
import '../../../services/api_service.dart';
import '../../../services/storage_service.dart';
import 'dart:async';

class LoginController extends GetxController {
  final TextEditingController mobileController = TextEditingController();
  final List<TextEditingController> otpControllers = List.generate(
    6,
    (index) => TextEditingController(),
  );
  final RxBool isLoading = false.obs;
  final RxBool isOtpSent = false.obs;
  final RxInt resendSecondsLeft = 0.obs;
  Timer? _resendTimer;

  String get resendTimerText {
    final int min = resendSecondsLeft.value ~/ 60;
    final int sec = resendSecondsLeft.value % 60;
    return '${min.toString().padLeft(2, '0')}:${sec.toString().padLeft(2, '0')}' ;
  }

  void _startResendTimer() {
    resendSecondsLeft.value = 120;
    _resendTimer?.cancel();
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (resendSecondsLeft.value > 0) {
        resendSecondsLeft.value--;
      } else {
        _resendTimer?.cancel();
      }
    });
  }

  late final ApiService _apiService;
  late final StorageService _storageService;

  @override
  void onInit() async {
    super.onInit();
    _apiService = ApiService();
    final prefs = await SharedPreferences.getInstance();
    _storageService = StorageService(prefs);
  }

  Future<void> sendOtp() async {
    if (mobileController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter your mobile number',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (mobileController.text.length != 10) {
      Get.snackbar(
        'Error',
        'Please enter a valid 10-digit mobile number',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      isLoading.value = true;
      // TODO: Implement send OTP API call
      // final response = await _apiService.sendOtp(mobileController.text);
      
      isOtpSent.value = true;
      _startResendTimer();
      Get.snackbar(
        'Success',
        'OTP sent to your mobile number',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green[100],
        colorText: Colors.green[900],
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString().replaceAll('Exception: ', ''),
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> verifyOtp() async {
    if (mobileController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter your mobile number',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    // Get OTP from all 6 text fields
    String otp = otpControllers.map((controller) => controller.text).join('');
    
    if (otp.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter the OTP',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (otp.length != 6) {
      Get.snackbar(
        'Error',
        'Please enter a valid 6-digit OTP',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      isLoading.value = true;
      // TODO: Implement verify OTP API call
      // final response = await _apiService.verifyOtp(mobileController.text, otp);
      
      // For now, simulate successful login
      Get.offAll(() => HomeScreen());
      Get.snackbar(
        'Success',
        'Login successful',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green[100],
        colorText: Colors.green[900],
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString().replaceAll('Exception: ', ''),
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
      );
    } finally {
      isLoading.value = false;
    }
  }

  void resendOtp() {
    if (mobileController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter your mobile number first',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    
    sendOtp();
    _startResendTimer();
  }





  @override
  void onClose() {
    _resendTimer?.cancel();
    mobileController.dispose();
    for (var controller in otpControllers) {
      controller.dispose();
    }
    super.onClose();
  }
}
