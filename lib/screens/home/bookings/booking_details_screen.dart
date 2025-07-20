import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../widgets/common/app_bar.dart';

import '../../../../controllers/enquiry_details_controller.dart';
import '../../../../models/enquiry_details_model.dart';
import '../../../../widgets/vehicles_list.dart';
import '../../../../widgets/payments_list.dart';
import '../../../../widgets/members_list.dart';
import '../../../../widgets/hotels_list.dart';
import '../../../../widgets/activities_list.dart';
import 'pdf_viewer_screen.dart';

class BookingDetailsScreen extends StatelessWidget {
  final String enquiryId;
  final EnquiryDetailsController controller = Get.put(EnquiryDetailsController());

  BookingDetailsScreen({super.key, required this.enquiryId}) {
    // Fetch bookings details when screen is initialized
    controller.fetchEnquiryDetails(enquiryId);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: const CommonAppBar(
        title: 'Booking Details',
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.error.value.isNotEmpty) {
          return Center(child: Text('Error: ${controller.error.value}'));
        }

        final details = controller.enquiryDetails.value;
        if (details == null) {
          return const Center(child: Text('No details available'));
        }

        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                theme.colorScheme.primary.withOpacity(0.1),
                theme.colorScheme.surface,
              ],
            ),
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeaderCard(details, theme),
                const SizedBox(height: 16),
                if (details.quotationUrl.isNotEmpty)
                  _buildQuotationButton(theme),
                const SizedBox(height: 16),
                _buildSection(
                  'Travel Details',
                  [
                    _buildTravelDetailsCard(details, theme),
                  ],
                ),
                const SizedBox(height: 16),
                MembersList(members: details.members),
                const SizedBox(height: 16),
                HotelsList(hotels: details.hotels),
                const SizedBox(height: 16),
                ActivitiesList(activities: details.activities),
                const SizedBox(height: 16),
                VehiclesList(vehicles: details.vehicle),
                const SizedBox(height: 16),
                PaymentsList(payments: details.payments),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildHeaderCard(EnquiryDetailsModel details, ThemeData theme) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [
              theme.colorScheme.primary,
              theme.colorScheme.primary.withOpacity(0.8),
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.confirmation_number, color: Colors.white),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Enquiry ID',
                        style: theme.textTheme.bodySmall?.copyWith(color: Colors.white70),
                      ),
                      Text(
                        details.booking.uniqueEnquiryId,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              details.booking.planName,
              style: theme.textTheme.titleLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.calendar_today, color: Colors.white70, size: 16),
                const SizedBox(width: 4),
                Text(
                  details.booking.departureDate,
                  style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white70),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuotationButton(ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton.icon(
        onPressed: () => Get.to(() => PDFViewerScreen(
              pdfUrl: controller.enquiryDetails.value!.quotationUrl,
              title: 'Quotation',
            )),
        icon: const Icon(Icons.picture_as_pdf),
        label: const Text('View Quotation'),
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          backgroundColor: theme.colorScheme.primary,
          foregroundColor: Colors.white,
        ),
      ),
    );
  }

  Widget _buildTravelDetailsCard(EnquiryDetailsModel details, ThemeData theme) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildTravelDetailItem(
              theme,
              Icons.hotel,
              '${details.noOfRooms}',
              'Rooms',
            ),
            _buildTravelDetailItem(
              theme,
              Icons.person,
              '${details.noOfAdults}',
              'Adults',
            ),
            _buildTravelDetailItem(
              theme,
              Icons.child_care,
              '${details.noOfChilds}',
              'Children',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTravelDetailItem(ThemeData theme, IconData icon, String value, String label) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: theme.colorScheme.primary),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
          ),
        ),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ...children,
      ],
    );
  }
} 