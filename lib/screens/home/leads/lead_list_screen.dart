import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../widgets/common/app_bar.dart';
import '../../../controllers/lead_controller.dart';
import '../../../models/leads_model.dart';
import '../../../widgets/lead_card.dart';
import 'create_lead_screen.dart';

class LeadListScreen extends StatefulWidget {
  const LeadListScreen({super.key});

  @override
  State<LeadListScreen> createState() => _LeadListScreenState();
}

class _LeadListScreenState extends State<LeadListScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final LeadController _leadController = Get.put(LeadController());

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title: 'Leads',
        showBackButton: false,
      ),
      body: Column(
        children: [
          // TabBar content
          Container(
            color: AppColors.kPrimaryVariant,
            child: TabBar(
              controller: _tabController,
              indicatorColor: AppColors.border,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white70,
              isScrollable: false,
              indicatorWeight: 3,
              labelStyle: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
              unselectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
              tabs: const [
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.pending_actions, size: 18),
                      SizedBox(width: 8),
                      Text('Active'),
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.check_circle_outline, size: 18),
                      SizedBox(width: 8),
                      Text('Confirmed'),
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.archive_outlined, size: 18),
                      SizedBox(width: 8),
                      Text('Closed'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // TabBarView content
          Expanded(
            child: Obx(() => _leadController.isLoading.value
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: () async {
                      try {
                        await _leadController.fetchLeads();
                      } catch (e) {
                        Get.snackbar(
                          'Error',
                          'Failed to refresh leads: $e',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: AppColors.primary,
                          colorText: Colors.white,
                        );
                      }
                    },
                    color: AppColors.primary,
                    backgroundColor: AppColors.background,
                    strokeWidth: 3,
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        _buildLeadsList(_leadController.leads.value?.pendingLeads ?? []),
                        _buildLeadsList(_leadController.leads.value?.activeLeads ?? []),
                        _buildLeadsList(_leadController.leads.value?.closedLeads ?? []),
                      ],
                    ),
                  )),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Get.to(() => const CreateLeadScreen());
          if (result == true) {
            await _leadController.fetchLeads();
          }
        },
        icon: const Icon(Icons.add_circle_outline),
        label: const Text('Create Lead'),
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
    );
  }

  Widget _buildLeadsList(List<Lead> leads) {
    if (leads.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 64,
              color: AppColors.secondary,
            ),
            const SizedBox(height: 16),
            Text(
              'No leads found',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: leads.length,
      itemBuilder: (context, index) {
        final lead = leads[index];
        return LeadCard(lead: lead);
      },
    );
  }
}
