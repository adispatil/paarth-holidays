import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../services/api_service.dart';
import '../../../services/storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ForgotPasswordController extends GetxController {
  final ApiService _apiService = ApiService();
  late final StorageService _storageService;

  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();

  var isLoading = false.obs;

  @override
  void onInit() async {
    super.onInit();
    final prefs = await SharedPreferences.getInstance();
    _storageService = StorageService(prefs);
  }

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    
    // Basic email validation
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    
    return null;
  }

  Future<void> sendPasswordResetEmail() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    isLoading.value = true;
    try {
      await _apiService.forgotPassword(email: emailController.text.trim());

      Get.back();
      Get.snackbar(
        'Success',
        'New password sent to your email id!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
      );

      // Clear form
      emailController.clear();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to send password reset email: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
} 