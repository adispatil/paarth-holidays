import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:permission_handler/permission_handler.dart';
import '../models/sector_model.dart';
import '../services/api_service.dart';

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
    final status = await Permission.contacts.request();
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

      isLoading.value = true;
      // Get all contacts with properties
      final List<Contact> allContacts = await FlutterContacts.getContacts(
        withProperties: true,
        withPhoto: true,
      );
      
      contacts.value = allContacts;
      
      // Show contact picker dialog
      final Contact? selectedContact = await Get.dialog<Contact>(
        Dialog(
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Select Contact',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 300,
                  child: ListView.builder(
                    itemCount: contacts.length,
                    itemBuilder: (context, index) {
                      final contact = contacts[index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Theme.of(context).primaryColor,
                          child: Text(
                            contact.displayName.isNotEmpty 
                                ? contact.displayName[0].toUpperCase()
                                : '?',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        title: Text(contact.displayName),
                        subtitle: contact.phones.isNotEmpty 
                            ? Text(contact.phones.first.number)
                            : null,
                        onTap: () => Get.back(result: contact),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      if (selectedContact != null) {
        // Get the first phone number if available
        final phoneNumber = selectedContact.phones.isNotEmpty 
            ? selectedContact.phones.first.number 
            : '';
        contactController.text = phoneNumber;
        
        // If name is empty, set it from contact
        if (nameController.text.isEmpty) {
          nameController.text = selectedContact.displayName;
        }
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to pick contact: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
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