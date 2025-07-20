import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:permission_handler/permission_handler.dart';
import '../models/sector_model.dart';
import '../services/api_service.dart';
import '../screens/home/leads/contact_picker_screen.dart';

class CreateLeadController extends GetxController {
  final ApiService _apiService = ApiService();
  
  final RxBool isLoading = false.obs;
  final RxList<Sector> sectors = <Sector>[].obs;
  final RxString selectedSectorId = ''.obs;
  final RxInt nameCharCount = 0.obs;
  final RxList<Contact> contacts = <Contact>[].obs;

  // Form controllers
  final TextEditingController nameController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    fetchSectors();
    nameController.addListener(_updateNameCharCount);
  }

  void _updateNameCharCount() {
    nameCharCount.value = nameController.text.length;
  }

  Future<bool> _requestContactPermission() async {
    final currentStatus = await Permission.contacts.status;
    print('Current contacts permission status: ' + currentStatus.toString());
    if (currentStatus.isGranted) {
      return true;
    }
    final status = await Permission.contacts.request();
    print('Contacts permission status after request: ' + status.toString());
    if (status.isGranted) {
      return true;
    } else if (status.isPermanentlyDenied) {
      // Show dialog to open app settings
      final result = await Get.dialog<bool>(
        AlertDialog(
          title: const Text('Permission Required'),
          content: const Text(
            'Contact permission is required to select contacts. Please enable it in app settings.',
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(result: false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Get.back(result: true);
                await openAppSettings();
              },
              child: const Text('Open Settings'),
            ),
          ],
        ),
      );
      return result ?? false;
    } else {
      Get.snackbar(
        'Permission Denied',
        'Contact permission is required to select contacts.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }
  }

  Future<void> pickContact() async {
    try {
      // Check and request permission first
      final hasPermission = await _requestContactPermission();
      if (!hasPermission) return;

      // Navigate to the new ContactPickerScreen and wait for result
      final Contact? selectedContact = await Get.to(() => const ContactPickerScreen());

      if (selectedContact != null) {
        // Get the first phone number if available and sanitize to last 10 digits
        String phoneNumber = selectedContact.phones.isNotEmpty 
            ? selectedContact.phones.first.number 
            : '';
        // Remove all non-digit characters
        phoneNumber = phoneNumber.replaceAll(RegExp(r'\D'), '');
        // Use only the last 10 digits if available
        if (phoneNumber.length > 10) {
          phoneNumber = phoneNumber.substring(phoneNumber.length - 10);
        }
        contactController.text = phoneNumber;
        // If name is empty, set it from contact
        if (nameController.text.isEmpty) {
          nameController.text = selectedContact.displayName;
        }
      }
    } catch (e) {
      print(e);
      Get.snackbar(
        'Error',
        'Failed to pick contact: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  void onClose() {
    nameController.removeListener(_updateNameCharCount);
    nameController.dispose();
    contactController.dispose();
    super.onClose();
  }

  Future<void> fetchSectors() async {
    try {
      isLoading.value = true;
      final result = await _apiService.fetchSectors();
      sectors.value = result.sectors;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to fetch sectors: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void setSelectedSector(String sectorId) {
    selectedSectorId.value = sectorId;
  }

  Future<void> saveLead() async {
    if (!formKey.currentState!.validate()) return;
    if (selectedSectorId.isEmpty) {
      Get.snackbar(
        'Error',
        'Please select a sector',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      isLoading.value = true;
      final response = await _apiService.createLead(
        leadName: nameController.text,
        leadContact: contactController.text,
        leadSector: selectedSectorId.value,
      );

      if (response['status'] == true) {
        Get.back(result: true); // Return true to indicate success
        Get.snackbar(
          'Success',
          response['message'] ?? 'Lead created successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        throw Exception(response['message'] ?? 'Failed to create lead');
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to create lead: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
} 