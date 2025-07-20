import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../core/theme/app_colors.dart';
import 'package:paarth_holidays/screens/home/dashboard/dashboard_screen.dart';
import 'package:paarth_holidays/screens/home/home_controller.dart';
import 'package:paarth_holidays/screens/home/leads/lead_list_screen.dart';
import 'package:paarth_holidays/screens/home/profile/profile_screen.dart';

import 'bookings/booking_list_screen.dart';
import 'offers/offers_screen.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final List<Widget> pages = [
    OffersScreen(),
    BookingListScreen(),
    LeadListScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final HomeController homeController = Get.put(HomeController());
    return Scaffold(
      body: Obx(() => pages[homeController.selectedIndex.value]),
      bottomNavigationBar: Obx(
        () => Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: BottomNavigationBar(
            selectedLabelStyle: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
            unselectedLabelStyle: TextStyle(
              color: AppColors.secondary,
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
            currentIndex: homeController.selectedIndex.value,
            onTap: homeController.changeTabIndex,
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            elevation: 0,
            showUnselectedLabels: true,
            showSelectedLabels: true,
            items: [
              BottomNavigationBarItem(
                label: "Home",
                activeIcon: FaIcon(FontAwesomeIcons.house, color: AppColors.primary, size: 20),
                icon: FaIcon(FontAwesomeIcons.house, color: AppColors.secondary, size: 20),
              ),
              BottomNavigationBarItem(
                label: "Bookings",
                activeIcon: FaIcon(FontAwesomeIcons.ticket, color: AppColors.primary, size: 20),
                icon: FaIcon(FontAwesomeIcons.ticket, color: AppColors.secondary, size: 20),
              ),
              BottomNavigationBarItem(
                label: "Enquiry",
                activeIcon: FaIcon(FontAwesomeIcons.planeDeparture, color: AppColors.primary, size: 20),
                icon: FaIcon(FontAwesomeIcons.planeDeparture, color: AppColors.secondary, size: 20),
              ),
              BottomNavigationBarItem(
                label: "Profile",
                activeIcon: FaIcon(FontAwesomeIcons.userTie, color: AppColors.primary, size: 20),
                icon: FaIcon(FontAwesomeIcons.userTie, color: AppColors.secondary, size: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
