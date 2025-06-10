import 'package:get/get.dart';
import '../../../models/booking_model.dart';
import '../../../services/api_service.dart';

class BookingListController extends GetxController {
  final ApiService _apiService = ApiService();
  final RxList<BookingModel> bookings = <BookingModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString? error = RxString('');

  Future<void> fetchBookings() async {
    isLoading.value = true;
    error?.value = '';

    try {
      final result = await _apiService.fetchBookings();
      bookings.value = result;
    } catch (e) {
      error?.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
} 