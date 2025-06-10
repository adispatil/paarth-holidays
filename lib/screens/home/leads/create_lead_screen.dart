import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../../controllers/create_lead_controller.dart';

class CreateLeadScreen extends StatelessWidget {
  const CreateLeadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CreateLeadController());
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Lead'),
        elevation: 0,
      ),
      body: Obx(() => controller.isLoading.value
          ? const Center(child: CircularProgressIndicator())
          : Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    theme.primaryColor.withValues(alpha: 0.1),
                    Colors.white,
                  ],
                ),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: controller.formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Header Section
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: theme.primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            FaIcon(FontAwesomeIcons.earthAmericas, size: 48,color: theme.primaryColor,),
                            // Icon(
                            //   FaIcon(FontAwesomeIcons.house, color: Colors.amber),
                            //   size: 48,
                            //   color: theme.primaryColor,
                            // ),
                            const SizedBox(height: 16),
                            Text(
                              'Add New Lead',
                              style: theme.textTheme.titleLarge?.copyWith(
                                color: theme.primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Fill in the details below to create a new lead',
                              textAlign: TextAlign.center,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Form Fields
                      Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Obx(() => TextFormField(
                                controller: controller.nameController,
                                maxLength: 50,
                                decoration: InputDecoration(
                                  labelText: 'Lead Name',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  prefixIcon: Icon(
                                    Icons.person_outline,
                                    color: theme.primaryColor,
                                  ),
                                  filled: true,
                                  fillColor: Colors.grey[50],
                                  counterText: '${controller.nameCharCount.value}/50',
                                  counterStyle: TextStyle(
                                    color: controller.nameCharCount.value >= 50
                                        ? Colors.red 
                                        : Colors.grey[600],
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter lead name';
                                  }
                                  if (value.length > 50) {
                                    return 'Lead name cannot exceed 50 characters';
                                  }
                                  return null;
                                },
                              )),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: controller.contactController,
                                decoration: InputDecoration(
                                  labelText: 'Contact Number',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  prefixIcon: Icon(
                                    Icons.phone_outlined,
                                    color: theme.primaryColor,
                                  ),
                                  suffixIcon: IconButton(
                                    icon: const Icon(Icons.contacts),
                                    onPressed: controller.pickContact,
                                    color: theme.primaryColor,
                                  ),
                                  filled: true,
                                  fillColor: Colors.grey[50],
                                ),
                                keyboardType: TextInputType.phone,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter contact number';
                                  }
                                  if (value.length < 10) {
                                    return 'Please enter a valid contact number';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              Obx(() => DropdownButtonFormField<String>(
                                    value: controller.selectedSectorId.value.isEmpty
                                        ? null
                                        : controller.selectedSectorId.value,
                                    decoration: InputDecoration(
                                      labelText: 'Select Sector',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      prefixIcon: Icon(
                                        Icons.location_city_outlined,
                                        color: theme.primaryColor,
                                      ),
                                      filled: true,
                                      fillColor: Colors.grey[50],
                                    ),
                                    items: controller.sectors.map((sector) {
                                      return DropdownMenuItem<String>(
                                        value: sector.stateId,
                                        child: Text(sector.stateName),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      if (value != null) {
                                        controller.setSelectedSector(value);
                                      }
                                    },
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please select a sector';
                                      }
                                      return null;
                                    },
                                  )),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Submit Button
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: theme.primaryColor.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: controller.saveLead,
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            backgroundColor: theme.primaryColor,
                            foregroundColor: theme.colorScheme.onPrimary,
                          ),
                          child: Text(
                            'Create Lead',
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: theme.colorScheme.onPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )),
    );
  }
}
