import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../models/profile_model.dart';
import 'widgets/profile_info_card.dart';
import 'profile_controller.dart';
import '../../../widgets/common/loader_dialog.dart';
import 'change_password_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final controller = Get.put(ProfileController());

    return Obx(() {
      // Show/hide loader dialog after build
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (controller.isLoading.value) {
          if (!(Get.isDialogOpen ?? false)) {
            Get.dialog(const LoaderDialog(), barrierDismissible: false);
          }
        } else {
          if (Get.isDialogOpen ?? false) {
            Get.back();
          }
        }
      });

      return Scaffold(
        appBar: AppBar(
          title: const Text('Profile'),
          centerTitle: true,
          elevation: 0,
        ),
        body: controller.errorMessage.isNotEmpty
            ? Center(child: Text(controller.errorMessage.value))
            : controller.profile.value == null
                ? const Center(child: Text('No profile data'))
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              width: double.infinity,
                              height: 140,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(30),
                                  bottomRight: Radius.circular(30),
                                ),
                                image: const DecorationImage(
                                  image: AssetImage(
                                    'assets/images/splash_bg.png',
                                  ),
                                  fit: BoxFit.cover,
                                  alignment: Alignment.centerLeft,
                                ),
                              ),
                            ),
                            Positioned(
                              left: 0,
                              right: 0,
                              bottom: -50,
                              child: Center(
                                child: CircleAvatar(
                                  radius: 50,
                                  backgroundColor: theme.scaffoldBackgroundColor,
                                  child: CircleAvatar(
                                    radius: 46,
                                    backgroundColor: theme.primaryColor,
                                    child: Icon(
                                      Icons.person,
                                      size: 50,
                                      color: theme.colorScheme.onPrimary,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 60),
                        ProfileInfoCard(profile: controller.profile.value!),
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  // TODO: Implement edit profile functionality
                                },
                                style: ElevatedButton.styleFrom(
                                  minimumSize: const Size(double.infinity, 50),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  backgroundColor: theme.primaryColor,
                                  foregroundColor: theme.colorScheme.onPrimary,
                                ),
                                child: Text(
                                  'Edit Profile',
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    color: theme.colorScheme.onPrimary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: theme.primaryColor.withOpacity(0.3),
                                    width: 1.5,
                                  ),
                                ),
                                child: ElevatedButton(
                                  onPressed: () => Get.to(() => const ChangePasswordScreen()),
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: const Size(double.infinity, 50),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    backgroundColor: theme.primaryColor.withOpacity(0.1),
                                    foregroundColor: theme.primaryColor,
                                    elevation: 0,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.lock_outline,
                                        color: theme.primaryColor,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Change Password',
                                        style: theme.textTheme.titleMedium?.copyWith(
                                          color: theme.primaryColor,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.red.shade300,
                                    width: 1.5,
                                  ),
                                ),
                                child: ElevatedButton(
                                  onPressed: () => _showLogoutDialog(context, controller),
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: const Size(double.infinity, 50),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    backgroundColor: Colors.red.shade50,
                                    foregroundColor: Colors.red.shade700,
                                    elevation: 0,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.logout_rounded,
                                        color: Colors.red.shade700,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Logout',
                                        style: theme.textTheme.titleMedium?.copyWith(
                                          color: Colors.red.shade700,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
      );
    });
  }

  void _showLogoutDialog(BuildContext context, ProfileController controller) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Icon(
              Icons.logout_rounded,
              color: Colors.red.shade700,
              size: 28,
            ),
            const SizedBox(width: 8),
            const Text('Logout'),
          ],
        ),
        content: const Text(
          'Are you sure you want to logout?',
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.grey),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              controller.logout();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade700,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
