import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../models/profile_model.dart';
import '../../../services/api_service.dart';
import '../../../services/storage_service.dart';
import '../../auth/login/login_screen.dart';

class ProfileController extends GetxController {
  final ApiService _apiService = ApiService();
  late final StorageService _storageService;

  var profile = Rxn<ProfileModel>();
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  @override
  void onInit() async {
    super.onInit();
    final prefs = await SharedPreferences.getInstance();
    _storageService = StorageService(prefs);
    fetchUserProfile();
  }

  Future<void> fetchUserProfile() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final result = await _apiService.fetchUserProfile();
      profile.value = result;
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    try {
      isLoading.value = true;
      await _storageService.clearAll();
      Get.offAll(() => LoginScreen());
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to logout: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
} 