import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/wallet_model.dart';
import '../services/api_service.dart';

class WalletController extends GetxController {
  final ApiService _apiService = ApiService();
  
  final RxBool isLoading = false.obs;
  final Rx<WalletModel?> wallet = Rx<WalletModel?>(null);
  final RxString error = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchWallet();
  }

  Future<void> fetchWallet() async {
    try {
      isLoading.value = true;
      error.value = '';
      
      final result = await _apiService.fetchWallet();
      wallet.value = result;
    } catch (e) {
      error.value = e.toString();
      Get.snackbar(
        'Error',
        'Failed to fetch wallet data: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void refreshWallet() {
    fetchWallet();
  }
} 