import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/theme/app_colors.dart';
import '../../../widgets/common/app_bar.dart';
import 'offers_controller.dart';

class OffersScreen extends StatelessWidget {
  const OffersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OffersController());
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: const CommonAppBar(
        title: 'Special Offers',
        showBackButton: false,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.error.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  color: AppColors.primary,
                  size: 48,
                ),
                const SizedBox(height: 16),
                Text(
                  'Error: ${controller.error.value}',
                  style: const TextStyle(color: AppColors.primary),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: controller.fetchOffers,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (controller.offers.isEmpty) {
          return const Center(
            child: Text(
              'No offers available',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          );
        }

        return Container(
          decoration: BoxDecoration(color: Colors.white),
          child: SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 10),
                Expanded(
                  child: FlutterCarousel(
                    items:
                        controller.offers.map((offer) {
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.white,
                                  blurRadius: 10,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Stack(
                                children: [
                                  // Image container with aspect ratio
                                  Positioned.fill(
                                    child: Container(
                                      color: AppColors.border,
                                      child: Center(
                                        child: AspectRatio(
                                          aspectRatio: 1,
                                          child: CachedNetworkImage(
                                            imageUrl: offer.image,
                                            fit: BoxFit.contain,
                                            placeholder:
                                                (context, url) => Container(
                                                  color: AppColors.border,
                                                  child: const Center(
                                                    child:
                                                        CircularProgressIndicator(),
                                                  ),
                                                ),
                                            errorWidget:
                                                (context, url, error) =>
                                                    Container(
                                                      color: AppColors.border,
                                                      child: const Icon(
                                                        Icons.error,
                                                      ),
                                                    ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  // Gradient overlay
                                  Positioned.fill(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                            Colors.transparent,
                                            AppColors.secondary.withOpacity(
                                              0.1,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  // Offer name and button
                                  Positioned(
                                    bottom: 20,
                                    left: 20,
                                    right: 20,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Text(
                                        //   offer.name,
                                        //   style: const TextStyle(
                                        //     color: Colors.white,
                                        //     fontSize: 24,
                                        //     fontWeight: FontWeight.bold,
                                        //     shadows: [
                                        //       Shadow(
                                        //         offset: Offset(1, 1),
                                        //         blurRadius: 3,
                                        //         color: Colors.black,
                                        //       ),
                                        //     ],
                                        //   ),
                                        // ),
                                        // const SizedBox(height: 8),
                                        // Container(
                                        //   padding: const EdgeInsets.symmetric(
                                        //     horizontal: 12,
                                        //     vertical: 6,
                                        //   ),
                                        //   decoration: BoxDecoration(
                                        //     color: AppColors.primary.withOpacity(0.3),
                                        //     borderRadius: BorderRadius.circular(20),
                                        //   ),
                                        //   child: const Text(
                                        //     'View Details',
                                        //     style: TextStyle(
                                        //       color: Colors.white,
                                        //       fontSize: 14,
                                        //       fontWeight: FontWeight.w500,
                                        //     ),
                                        //   ),
                                        // ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                    options: CarouselOptions(
                      showIndicator: true,
                      height: screenWidth * 0.85,
                      viewportFraction: 0.85,
                      enlargeCenterPage: true,
                      autoPlay: true,
                      autoPlayInterval: const Duration(seconds: 5),
                      autoPlayAnimationDuration: const Duration(
                        milliseconds: 800,
                      ),
                      autoPlayCurve: Curves.fastOutSlowIn,
                      slideIndicator: SequentialFillIndicator(),
                      onPageChanged: controller.updateCurrentIndex,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      }),
    );
  }
}
