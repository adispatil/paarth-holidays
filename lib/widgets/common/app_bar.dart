import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/theme/app_colors.dart';
import '../../screens/wallet/wallet_screen.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final bool showWalletIcon;

  const CommonAppBar({
    super.key,
    required this.title,
    this.actions,
    this.showBackButton = true,
    this.onBackPressed,
    this.showWalletIcon = true,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
      ),
      centerTitle: true,
      elevation: 1,
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      leading: showBackButton
          ? IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: onBackPressed ?? () => Get.back(),
            )
          : null,
      actions: [
        // Wallet icon
        if (showWalletIcon)
        IconButton(
          icon: const Icon(Icons.account_balance_wallet),
          onPressed: () {
            Get.to(() => const WalletScreen());
          },
        ),
        // Additional actions if provided
        if (actions != null) ...actions!,
        const SizedBox(width: 8), // Add some padding at the end
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
} 