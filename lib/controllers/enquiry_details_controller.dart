import 'package:get/get.dart';
import '../models/enquiry_details_model.dart';
import '../services/api_service.dart';

class EnquiryDetailsController extends GetxController {
  final ApiService _apiService = ApiService();
  final Rx<EnquiryDetailsModel?> enquiryDetails = Rx<EnquiryDetailsModel?>(null);
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;

  Future<void> fetchEnquiryDetails(String enquiryId) async {
    try {
      isLoading.value = true;
      error.value = '';
      
      final result = await _apiService.fetchEnquiryDetails(enquiryId);
      enquiryDetails.value = result;
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
} 