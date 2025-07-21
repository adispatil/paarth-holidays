import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'dart:async';
import '../services/api_service.dart';

class ContactPickerController extends GetxController {
  final RxList<Contact> contacts = <Contact>[].obs;
  final RxList<Contact> filteredContacts = <Contact>[].obs;
  final Rx<Contact?> selectedContact = Rx<Contact?>(null);
  final RxBool isLoading = true.obs;
  Timer? _debounce;
  final ApiService _apiService = ApiService();
  final RxString selectedContactKey = ''.obs;

  void setContacts(List<Contact> list) {
    contacts.assignAll(list);
    filteredContacts.assignAll(list);
    isLoading.value = false;
    // Send contacts to server in background using ApiService
    _apiService.uploadContacts(list);
  }

  void filterContacts(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      final q = query.trim().toLowerCase();
      if (q.isEmpty) {
        filteredContacts.assignAll(contacts);
      } else {
        filteredContacts.assignAll(
          contacts.where((contact) {
            final name = contact.displayName.toLowerCase();
            final numbers = contact.phones.map((p) => p.number.replaceAll(RegExp(r'\D'), ''));
            return name.contains(q) || numbers.any((numb) => numb.contains(q.replaceAll(RegExp(r'\D'), '')));
          }),
        );
      }
      debugPrint('Filtered contacts count: \u001b[32m${filteredContacts.length}\u001b[0m');
    });
  }

  void selectContact(Contact contact) {
    final key = contact.displayName + (contact.phones.isNotEmpty ? contact.phones.first.number : '');
    selectedContactKey.value = key;
    selectedContact.value = contact;
  }

  void confirmSelection() {
    if (selectedContact.value != null) {
      Get.back(result: selectedContact.value);
    }
  }

  @override
  void onClose() {
    _debounce?.cancel();
    super.onClose();
  }
} 