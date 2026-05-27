import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:apploan/core/core.dart';
import 'package:apploan/views/views.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';

final DashboardController listDashCtl = Get.find<DashboardController>();
final RepaymentController listRepaymentCtl = Get.find<RepaymentController>();

class LoanListsView extends GetView<LoanListsController> {
  const LoanListsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: LocaleKeys.loans.tr,
        onBack: () => Navigator.pop(context, false),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Fixed: Summary card ──
            const SizedBox(height: 20),
            Obx(
              () => CustomSummaryCard(
                clientCount: loanRepaymentCtl.customerCount.value,
                totalRepaymentUsd:
                    controller.collectedSum.value +
                    controller.totalRepaymentSum.value,
                collectedUsd: controller.collectedSum.value,
                exchangeRate: 4100,
                totalRepaymentFormatted: controller.totalToCollectUsd,
                totalRepaymentKhrFormatted: controller.totalToCollectKhr,
                onClientsTap: () {
                  DialogManager.showDialog(
                    title: 'Coming Soon',
                    subTitle:
                        'Client list will be available in a future update.',
                  );
                },
              ),
            ),
            20.height,

            // ── Fixed: Search bar ──
            Padding(
              padding: UIConstants.spacing.padHorizontal,
              child: AppSearchBar(
                controller: controller.searchCtl,
                hintText: LocaleKeys.searchByCIDName.tr,
                onSubmitted: (value) => controller.onSearch(value),
                onChanged: (value) => controller.onSearch(value),
                onClear: controller.onClearSearch,
              ),
            ),

            UIConstants.spacing.height,

            // ── Scrollable: List only ──
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: AppColor.secondPrime,
                    ),
                  );
                }

                if (controller.filteredRepayments.isEmpty) {
                  return const NoDataWidget();
                }

                // only show up to visibleCount items
                final visibleItems =
                    controller.filteredRepayments
                        .take(controller.visibleCount.value)
                        .toList();

                return ListView.builder(
                  padding: EdgeInsets.symmetric(
                    horizontal: UIConstants.spacing.toDouble(),
                  ),
                  // +1 for the Show More button row at the bottom
                  itemCount: visibleItems.length + 1,
                  itemBuilder: (context, index) {
                    // last item = Show More button
                    if (index == visibleItems.length) {
                      final int visible = controller.visibleCount.value;
                      final int total = controller.filteredRepayments.length;

                      if (visible >= total) return UIConstants.spacing.height;
                      return Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: UIConstants.spacing.toDouble(),
                        ),
                        child: Center(
                          child: TextButton.icon(
                            onPressed: controller.showMore,
                            icon: const Icon(
                              Icons.keyboard_arrow_down,
                              color: AppColor.hardOrange,
                            ),
                            label: Text(
                              'Show More (${controller.filteredRepayments.length - controller.visibleCount.value} remaining)',
                              style: const TextStyle(
                                color: AppColor.hardOrange,
                              ),
                            ),
                          ),
                        ),
                      );
                    }

                    return Padding(
                      padding: UIConstants.midSpacing.padBottom,
                      child: RepaymentItemWidget(delivery: visibleItems[index]),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
      bottomNavigationBar: AppBottomNav(
        navKey: const ValueKey('loans-nav'),
        initialActiveIndex: 0,
        onTap: (index) => controller.changeMenu(index),
        // TODO: swap based on role when ready
        // items: UserRepository.shared.isAdmin
        //     ? loanNavItemsAdmin()
        //     : loanNavItemsCO(),
        items: loanNavItemsCO(),
      ),
    );
  }
}
