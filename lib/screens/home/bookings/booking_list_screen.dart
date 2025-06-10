import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'booking_list_controller.dart';
import 'widgets/enquiry_card.dart';

class BookingListScreen extends GetView<BookingListController> {
  const BookingListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize the controller and fetch bookings
    Get.put(BookingListController()).fetchBookings();

    return Scaffold(
      appBar: AppBar(title: const Text('My Bookings'), centerTitle: true),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if ((controller.error?.value ?? '').isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Error: ${controller.error?.value}',
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => controller.fetchBookings(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (controller.bookings.isEmpty) {
          return const Center(child: Text('No bookings found'));
        }

        return ListView.builder(
          itemCount: controller.bookings.length,
          itemBuilder: (context, index) {
            return BookingCard(enquiry: controller.bookings[index]);
          },
        );
      }),
    );
  }
}
