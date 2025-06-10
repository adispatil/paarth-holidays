import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
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
        () => BottomNavigationBar(
          selectedLabelStyle: TextStyle(color: Colors.black),
          unselectedLabelStyle: TextStyle(color: Colors.black),
          currentIndex: homeController.selectedIndex.value,
          onTap: homeController.changeTabIndex,
          type: BottomNavigationBarType.shifting,
          showUnselectedLabels: true,
          showSelectedLabels: true,
          items: [
            BottomNavigationBarItem(
              label: "Home",
              activeIcon: FaIcon(FontAwesomeIcons.house, color: Colors.amber),
              backgroundColor: Colors.white,
              icon: FaIcon(FontAwesomeIcons.house, color: Colors.black45),
            ),
            BottomNavigationBarItem(
              label: "Bookings",
              activeIcon: FaIcon(FontAwesomeIcons.ticket, color: Colors.amber),
              icon: FaIcon(FontAwesomeIcons.ticket, color: Colors.black45),
            ),
            BottomNavigationBarItem(
              label: "Enquiry",
              activeIcon: FaIcon(
                FontAwesomeIcons.planeDeparture,
                color: Colors.amber,
              ),
              icon: FaIcon(
                FontAwesomeIcons.planeDeparture,
                color: Colors.black45,
              ),
            ),
            BottomNavigationBarItem(
              label: "Profile",
              activeIcon: FaIcon(FontAwesomeIcons.userTie, color: Colors.amber),
              icon: FaIcon(FontAwesomeIcons.userTie, color: Colors.black45),
            ),
          ],
        ),
      ),
    );
  }
}
