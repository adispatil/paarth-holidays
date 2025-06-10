import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/extensions/text_style_extension.dart';
import '../../../core/theme/app_colors.dart';
import 'widgets/best_place_card.dart';
import 'widgets/location_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Menu Bar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Menu Icon
                    Column(
                      children: [
                        Container(width: 18, height: 2, color: AppColors.textPrimary),
                        const SizedBox(height: 4),
                        Container(width: 10, height: 2, color: AppColors.textPrimary),
                      ],
                    ),
                    // Profile Image
                    Stack(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: SvgPicture.asset(
                            'assets/icons/person.svg',
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: AppColors.online,
                              shape: BoxShape.circle,
                              border: Border.all(color: AppColors.background, width: 1),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                // Title
                Text(
                  'Get Ready For\nThe Travel Trip!',
                  style: TextStyleExtension.h1,
                ),
                const SizedBox(height: 30),
                // Search Bar
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 40,
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: AppColors.border,
                            width: 1.5,
                          ),
                          borderRadius: BorderRadius.circular(7),
                        ),
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Find your location...',
                            hintStyle: TextStyleExtension.bodyMedium.withColor(
                              AppColors.textSecondary,
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: const Icon(Icons.search, color: AppColors.background),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                // My Location Section
                Text('My Location', style: TextStyleExtension.h2),
                const SizedBox(height: 15),
                const LocationCard(),
                const SizedBox(height: 30),
                // Best Place Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Best Place', style: TextStyleExtension.h2),
                    Text(
                      'See All',
                      style: TextStyleExtension.bodySmall.withColor(
                        AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: const [
                      BestPlaceCard(),
                      SizedBox(width: 20),
                      BestPlaceCard(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
