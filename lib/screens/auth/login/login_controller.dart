import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paarth_holidays/screens/auth/signup/signup_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../home/home_screen.dart';
import '../../../services/api_service.dart';
import '../../../services/storage_service.dart';

class LoginController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final RxBool isPasswordVisible = false.obs;
  final RxBool isLoading = false.obs;

  late final ApiService _apiService;
  late final StorageService _storageService;

  @override
  void onInit() async {
    super.onInit();
    _apiService = ApiService();
    final prefs = await SharedPreferences.getInstance();
    _storageService = StorageService(prefs);
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  Future<void> login() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter both username and password',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      isLoading.value = true;
      final response = await _apiService.login(
        emailController.text,
        passwordController.text,
      );

      if (response['status'] == true) {
        final token = response['resultData']['token'];
        await _storageService.saveToken(token);

        Get.offAll(() => HomeScreen());
        Get.snackbar(
          'Success',
          response['message'] ?? 'Login successful',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        Get.snackbar(
          'Error',
          response['message'] ?? 'Login failed',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
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

  void loginWithGoogle() {
    // Implement Google login logic
  }

  void goToSignUp() {
    Get.to(() => SignupScreen());
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
