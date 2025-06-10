import 'package:flutter/material.dart';

import '../../../../core/extensions/text_style_extension.dart';

class LocationCard extends StatelessWidget {
  const LocationCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8F8),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Stack(
        children: [
          // Bookmark Icon
          Positioned(
            top: 0,
            right: 20,
            child: IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.bookmark,
                color: Color(0xFFFF7D00),
                size: 24,
              ),
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image
                Container(
                  width: 55,
                  height: 55,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    image: const DecorationImage(
                      image: AssetImage('assets/images/location_1.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                // Text Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Winter in Portugal',
                        style: TextStyleExtension.h3,
                      ),
                      const SizedBox(height: 10),
                      // Location
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on,
                            color: Color(0xFFFF7D00),
                            size: 14,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            'Lisbon',
                            style: TextStyleExtension.bodyMedium.withColor(
                              const Color(0xFFAAAAAA),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      // Description
                      Text(
                        "Portugal there's so much more to discover. Read about the Azores' new wave of eco-travel.",
                        style: TextStyleExtension.bodyMedium.withColor(
                          const Color(0xFFAAAAAA),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
} 