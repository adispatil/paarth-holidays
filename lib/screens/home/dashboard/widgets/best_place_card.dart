import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/extensions/text_style_extension.dart';

class BestPlaceCard extends StatelessWidget {
  const BestPlaceCard({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = screenWidth * 0.7; // 70% of screen width
    final cardHeight =
        cardWidth * 0.61; // Maintain aspect ratio (180/295 ≈ 0.61)

    return Container(
      width: cardWidth,
      height: cardHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: const DecorationImage(
          image: AssetImage('assets/images/location_1.png'),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.matrix([
            0.9,
            0,
            0,
            0,
            0,
            0,
            0.9,
            0,
            0,
            0,
            0,
            0,
            0.9,
            0,
            0,
            0,
            0,
            0,
            1,
            0,
          ]), // Slight darkening effect
        ),
      ),
      child: Stack(
        children: [
          // Content at the bottom
          Positioned(
            left: 14,
            right: 15,
            bottom: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  'Sesimbra e Arrabida',
                  style: TextStyleExtension.h3.withColor(Colors.white),
                ),
                const SizedBox(height: 6),
                // Location and Price Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Location
                    Row(
                      children: [
                        SvgPicture.asset(
                          'assets/icons/location.svg',
                          width: 10,
                          height: 12,
                          colorFilter: const ColorFilter.mode(
                            Colors.white,
                            BlendMode.srcIn,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Sesimbra, Lisbon',
                          style: TextStyleExtension.bodyMedium.withColor(
                            Colors.white,
                          ),
                        ),
                      ],
                    ),
                    // Price Button
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF7D00),
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: Text(
                        '\$3 000',
                        style: TextStyleExtension.bodySmall.withColor(
                          Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
