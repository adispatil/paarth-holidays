import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../services/api_service.dart';
import '../../../services/storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangePasswordController extends GetxController {
  final ApiService _apiService = ApiService();
  late final StorageService _storageService;

  final formKey = GlobalKey<FormState>();
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  var isLoading = false.obs;
  var isCurrentPasswordVisible = false.obs;
  var isNewPasswordVisible = false.obs;
  var isConfirmPasswordVisible = false.obs;

  @override
  void onInit() async {
    super.onInit();
    final prefs = await SharedPreferences.getInstance();
    _storageService = StorageService(prefs);
  }

  @override
  void onClose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  void toggleCurrentPasswordVisibility() {
    isCurrentPasswordVisible.value = !isCurrentPasswordVisible.value;
  }

  void toggleNewPasswordVisibility() {
    isNewPasswordVisible.value = !isNewPasswordVisible.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
  }

  String? validateCurrentPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Current password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  String? validateNewPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'New password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    if (value == currentPasswordController.text) {
      return 'New password must be different from current password';
    }
    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != newPasswordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  Future<void> changePassword() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    isLoading.value = true;
    try {
      await _apiService.changePassword(
        oldPassword: currentPasswordController.text,
        newPassword: newPasswordController.text,
      );

      Get.back();
      Get.snackbar(
        'Success',
        'Password changed successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      // Clear form
      currentPasswordController.clear();
      newPasswordController.clear();
      confirmPasswordController.clear();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to change password: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
} 