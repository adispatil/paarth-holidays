import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/theme/app_colors.dart';
import '../../widgets/common/app_bar.dart';
import '../../controllers/wallet_controller.dart';
import 'package:intl/intl.dart';
import 'package:flutter_html/flutter_html.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  static const double pointsToMoneyRate = 0.10; // 1 point = ₹0.10
  static const int expiringPoints = 2500; // Points expiring in next 6 months

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(WalletController());

    // Calculate expiry date as 6 months from today
    final DateTime now = DateTime.now();
    final DateTime expiry = DateTime(now.year, now.month + 6, now.day);
    final String expiryDate = DateFormat('d MMM yyyy').format(expiry);

    return Scaffold(
      appBar: const CommonAppBar(title: 'Reward Wallet', showWalletIcon: false),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Reward Points Balance Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(top: 24, bottom: 5, left: 24, right: 24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color(0xFF2E3A59), // Dark blue
                      const Color(0xFF4A90E2), // Light blue
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF2E3A59).withOpacity(0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Reward Points Balance',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            'Active',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Obx(
                      () => Text(
                        controller.wallet.value?.points.toString() ?? '0',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Obx(
                      () => Html(
                        data:
                            controller.wallet.value?.pointsInInr ??
                            '<p>Points = <b>₹0.00</b></p>',
                        style: {
                          "p": Style(
                            color: Colors.white70,
                            fontSize: FontSize(14),
                            fontWeight: FontWeight.w500,
                          ),
                        },
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 12, right: 12, top: 2.0),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Obx(
                        () => Html(
                          data:
                              controller.wallet.value?.unit ??
                              '<p>1 Points = <b>INR 0.10</b></p>',
                          style: {
                            "p": Style(
                              color: Colors.white,
                              fontSize: FontSize(12),
                              fontWeight: FontWeight.w500,
                            ),
                          },
                          shrinkWrap: true,
                        ),
                      ),
                    ),
                    Obx(
                      () => Html(
                        data:
                            controller.wallet.value?.totalEarnedPoints ??
                            '<p>Total Points Earned Till Date: <b>INR 0</b></p>',
                        style: {
                          "p": Style(
                            color: Colors.white70,
                            fontSize: FontSize(14),
                            fontWeight: FontWeight.w500,
                          ),
                        },
                        shrinkWrap: true,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // Expiring Points Warning
              if (expiringPoints > 0)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.orange.shade200, width: 1),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.orange.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.warning_amber_rounded,
                          color: Colors.orange.shade700,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Points Expiring Soon',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.orange.shade800,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '$expiringPoints points will expire on $expiryDate',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.orange.shade700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          _showExpiringPointsDialog(
                            context,
                            expiringPoints,
                            expiryDate,
                          );
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.orange.shade600,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 2,
                        ),
                        child: const Text(
                          'Convert\nNow',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              if (expiringPoints > 0) const SizedBox(height: 20),

              // Quick Actions
              Visibility(
                visible: false, // Hide for now, enable later
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Quick Actions',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildActionCard(
                            icon: Icons.swap_horiz,
                            title: 'Convert Points',
                            subtitle: 'Convert to money',
                            onTap: () {
                              _showConvertPointsDialog(
                                context,
                                controller.wallet.value?.points ?? 0,
                                pointsToMoneyRate,
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildActionCard(
                            icon: Icons.account_balance,
                            title: 'Transfer to Bank',
                            subtitle: 'Send to your account',
                            onTap: () {
                              Get.snackbar(
                                'Transfer to Bank',
                                'Bank transfer feature coming soon!',
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: AppColors.primary,
                                colorText: Colors.white,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: _buildActionCard(
                            icon: Icons.history,
                            title: 'History',
                            subtitle: 'View transactions',
                            onTap: () {
                              Get.snackbar(
                                'History',
                                'Transaction history coming soon!',
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: AppColors.primary,
                                colorText: Colors.white,
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildActionCard(
                            icon: Icons.info_outline,
                            title: 'How to Earn',
                            subtitle: 'Learn about rewards',
                            onTap: () {
                              _showHowToEarnDialog(context);
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),

              // Recent Transactions
              const Text(
                'Recent Transactions',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 16),

              Obx(
                () =>
                    controller.wallet.value?.transactions.isNotEmpty == true
                        ? ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount:
                              controller.wallet.value!.transactions.length,
                          itemBuilder: (context, index) {
                            final transaction =
                                controller.wallet.value!.transactions[index];
                            final isCredit = transaction.type == 'C';
                            final isDebit = transaction.type == 'D';

                            return _buildTransactionItem(
                              title: isCredit ? 'Points Earned' : 'Points Used',
                              subtitle: transaction.comment,
                              amount:
                                  '${isCredit ? '+' : '-'}${transaction.points} points',
                              date: transaction.date,
                              isDebit: isDebit,
                              isPoints: true,
                            );
                          },
                        )
                        : const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showConvertPointsDialog(
    BuildContext context,
    int totalPoints,
    double rate,
  ) {
    final TextEditingController pointsController = TextEditingController();
    final TextEditingController amountController = TextEditingController();

    Get.dialog(
      AlertDialog(
        title: const Text('Convert Reward Points'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Available Points: $totalPoints',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: pointsController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Points to Convert',
                border: OutlineInputBorder(),
                hintText: 'Enter points to convert',
              ),
              onChanged: (value) {
                if (value.isNotEmpty) {
                  int points = int.tryParse(value) ?? 0;
                  double amount = points * rate;
                  amountController.text = amount.toStringAsFixed(2);
                } else {
                  amountController.clear();
                }
              },
            ),
            const SizedBox(height: 16),
            TextField(
              controller: amountController,
              enabled: false,
              decoration: const InputDecoration(
                labelText: 'Amount (₹)',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.grey,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (pointsController.text.isNotEmpty) {
                int points = int.tryParse(pointsController.text) ?? 0;
                if (points > totalPoints) {
                  Get.snackbar(
                    'Error',
                    'Insufficient points!',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                  );
                } else {
                  Get.back();
                  Get.snackbar(
                    'Success',
                    'Points converted successfully!',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.green,
                    colorText: Colors.white,
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            child: const Text('Convert'),
          ),
        ],
      ),
    );
  }

  void _showHowToEarnDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        title: const Text('How to Earn Reward Points'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Earn points by:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
            SizedBox(height: 12),
            Text('• Booking holiday packages'),
            Text('• Referring friends'),
            Text('• Completing profile'),
            Text('• Writing reviews'),
            SizedBox(height: 12),
            Text(
              'Conversion Rate:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
            Text('1 Point = ₹0.10'),
            SizedBox(height: 12),
            Text(
              'Minimum conversion: 100 points',
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Got it')),
        ],
      ),
    );
  }

  void _showExpiringPointsDialog(
    BuildContext context,
    int points,
    String expiryDate,
  ) {
    Get.dialog(
      AlertDialog(
        title: const Text('Convert Expiring Points'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'You have $points points expiring on $expiryDate. Would you like to convert them?',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Points to Convert',
                border: OutlineInputBorder(),
                hintText: 'Enter points to convert',
              ),
              onChanged: (value) {
                if (value.isNotEmpty) {
                  int pointsToConvert = int.tryParse(value) ?? 0;
                  if (pointsToConvert > points) {
                    Get.snackbar(
                      'Error',
                      'Insufficient points!',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                    );
                  }
                }
              },
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              final TextEditingController pointsController =
                  TextEditingController();
              final TextEditingController amountController =
                  TextEditingController();

              Get.dialog(
                AlertDialog(
                  title: const Text('Convert Points'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Available Points: $points',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: pointsController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Points to Convert',
                          border: OutlineInputBorder(),
                          hintText: 'Enter points to convert',
                        ),
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            int points = int.tryParse(value) ?? 0;
                            double amount = points * pointsToMoneyRate;
                            amountController.text = amount.toStringAsFixed(2);
                          } else {
                            amountController.clear();
                          }
                        },
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: amountController,
                        enabled: false,
                        decoration: const InputDecoration(
                          labelText: 'Amount (₹)',
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Get.back(),
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (pointsController.text.isNotEmpty) {
                          int pointsToConvert =
                              int.tryParse(pointsController.text) ?? 0;
                          if (pointsToConvert > expiringPoints) {
                            Get.snackbar(
                              'Error',
                              'Insufficient points!',
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.red,
                              colorText: Colors.white,
                            );
                          } else {
                            Get.back();
                            Get.snackbar(
                              'Success',
                              'Points converted successfully!',
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.green,
                              colorText: Colors.white,
                            );
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Convert'),
                    ),
                  ],
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            child: const Text('Convert'),
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 180, // Fixed height for consistency
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.primary.withOpacity(0.1),
                    AppColors.primary.withOpacity(0.2),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: AppColors.primary, size: 24),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionItem({
    required String title,
    required String subtitle,
    required String amount,
    required String date,
    required bool isDebit,
    required bool isPoints,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color:
                  isDebit
                      ? Colors.red.withOpacity(0.15)
                      : Colors.green.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              isDebit ? Icons.remove : Icons.add,
              color: isDebit ? Colors.red.shade700 : Colors.green.shade700,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  date,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Text(
            amount,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isDebit ? Colors.red.shade700 : Colors.green.shade700,
            ),
          ),
        ],
      ),
    );
  }
}
