import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/leads_model.dart';
import '../services/api_service.dart';

class LeadController extends GetxController {
  final ApiService _apiService = ApiService();
  
  final RxBool isLoading = false.obs;
  final Rx<LeadsModel?> leads = Rx<LeadsModel?>(null);

  @override
  void onInit() {
    super.onInit();
    fetchLeads();
  }

  Future<void> fetchLeads() async {
    try {
      isLoading.value = true;
      final result = await _apiService.fetchLeads();
      leads.value = result;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to fetch leads: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
} 