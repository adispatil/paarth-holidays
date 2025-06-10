import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/extensions/text_style_extension.dart';
import 'onboarding_controller.dart';

class OnboardingScreen extends StatelessWidget {
  OnboardingScreen({super.key});

  final OnboardingController controller = Get.put(OnboardingController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: controller.pageController,
            onPageChanged: controller.selectedPageIndex.call,
            itemCount: 3,
            itemBuilder: (context, index) {
              return OnboardingPage(index: index);
            },
          ),
          Positioned(
            bottom: 40,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Previous Button
                  Obx(
                    () => Visibility(
                      visible: controller.selectedPageIndex.value > 0,
                      maintainSize: true,
                      maintainAnimation: true,
                      maintainState: true,
                      child: GestureDetector(
                        onTap: () {
                          controller.pageController.previousPage(
                            duration: 300.milliseconds,
                            curve: Curves.ease,
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                offset: const Offset(0, 4),
                                blurRadius: 8,
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.arrow_back,
                                color: Color(0xFFFF8800),
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Previous',
                                style: TextStyleExtension.buttonSecondary,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Page Indicators
                  Row(
                    children: List.generate(
                      3,
                      (index) => Obx(() {
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.only(right: 8),
                          height: 8,
                          width:
                              controller.selectedPageIndex.value == index
                                  ? 24
                                  : 8,
                          decoration: BoxDecoration(
                            color:
                                controller.selectedPageIndex.value == index
                                    ? const Color(0xFFFF8800)
                                    : const Color(0xFFD8D8D8),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        );
                      }),
                    ),
                  ),

                  // Next/Get Started Button
                  Obx(
                    () => GestureDetector(
                      onTap: controller.forwardAction,
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF8800),
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(
                                0xFFFF8800,
                              ).withValues(alpha: 0.3),
                              offset: const Offset(0, 4),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              controller.isLastPage ? 'Get Started' : 'Next',
                              style: TextStyleExtension.buttonPrimary,
                            ),
                            if (!controller.isLastPage) ...[
                              const SizedBox(width: 8),
                              const Icon(
                                Icons.arrow_forward,
                                color: Colors.white,
                                size: 20,
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class OnboardingPage extends StatelessWidget {
  final int index;

  const OnboardingPage({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OnboardingController>();

    return Stack(
      children: [
        // Content
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (controller.onboardingImages[index].isNotEmpty)
                  Center(
                    child: Image.asset(
                      controller.onboardingImages[index],
                      height: 500,
                      fit: BoxFit.contain,
                    ),
                  ),
                const SizedBox(height: 40),
                Text(
                  controller.titles[index],
                  textAlign: TextAlign.left,
                  style: TextStyleExtension.h1,
                ),
                const SizedBox(height: 20),
                Text(
                  controller.descriptions[index],
                  textAlign: TextAlign.left,
                  style: TextStyleExtension.bodyMedium.withColor(
                    const Color(0xFFAAAAAA),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
