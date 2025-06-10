import 'package:get/get.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import '../../../models/offer_model.dart';
import '../../../services/api_service.dart';

class OffersController extends GetxController {
  final ApiService _apiService = ApiService();
  final RxList<OfferModel> offers = <OfferModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;
  final RxInt currentIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchOffers();
  }

  Future<void> fetchOffers() async {
    try {
      isLoading.value = true;
      error.value = '';
      final result = await _apiService.fetchOffers();
      offers.value = result;
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  void updateCurrentIndex(int index, CarouselPageChangedReason reason) {
    currentIndex.value = index;
  }
}
