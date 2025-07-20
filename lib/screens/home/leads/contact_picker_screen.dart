import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:get/get.dart';
import 'package:paarth_holidays/controllers/contact_picker_controller.dart';

class ContactPickerScreen extends StatefulWidget {
  const ContactPickerScreen({super.key});

  @override
  State<ContactPickerScreen> createState() => _ContactPickerScreenState();
}

class _ContactPickerScreenState extends State<ContactPickerScreen> {
  final ContactPickerController controller = Get.put(ContactPickerController());
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchContacts();
  }

  Future<void> _fetchContacts() async {
    controller.isLoading.value = true;
    final contacts = await FlutterContacts.getContacts(withProperties: true, withPhoto: true);
    controller.setContacts(contacts);
  }

  @override
  void dispose() {
    _searchController.dispose();
    Get.delete<ContactPickerController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Contact'),
        actions: [
          Obx(() => TextButton(
                onPressed: controller.selectedContact.value != null ? controller.confirmSelection : null,
                child: const Text('Done', style: TextStyle(color: Colors.white)),
              )),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Search by name or number',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: controller.filterContacts,
            ),
          ),
          Expanded(
            child: Obx(() => controller.isLoading.value
                ? const Center(child: CircularProgressIndicator())
                : ListView.separated(
                    itemCount: controller.filteredContacts.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final contact = controller.filteredContacts[index];
                      final contactKey = contact.displayName + (contact.phones.isNotEmpty ? contact.phones.first.number : '');
                      final isSelected = controller.selectedContactKey.value == contactKey;
                      print('SelectedKey: ${controller.selectedContactKey.value}, CurrentKey: $contactKey, isSelected: $isSelected');
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Theme.of(context).primaryColor,
                          child: contact.displayName.isNotEmpty
                              ? Text(contact.displayName[0].toUpperCase(), style: const TextStyle(color: Colors.white))
                              : const Icon(Icons.person, color: Colors.white),
                        ),
                        title: Text(contact.displayName),
                        subtitle: contact.phones.isNotEmpty ? Text(contact.phones.first.number) : null,
                        trailing: isSelected ? const Icon(Icons.check_circle, color: Colors.green) : null,
                        selected: isSelected,
                        onTap: () => controller.selectContact(contact),
                      );
                    },
                  )),
          ),
        ],
      ),
    );
  }
} 