import 'package:apploan/models/customer/model.dart';
import 'package:apploan/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:apploan/core/core.dart';
import 'package:apploan/models/models.dart';
import 'package:apploan/views/views.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart' as pull;

class CustomersView extends GetView<CustomersController> {
  const CustomersView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: LocaleKeys.clientLists.tr,
        onBack: () => Navigator.pop(context, false),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Search bar — always visible ──
          Padding(
            padding: UIConstants.spacing.padAll,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      LocaleKeys.searchByCIDName.tr,
                      style: AppTextStyle.midPrimaryBold,
                    ),
                    InkWell(
                      onTap: () {
                        if (controller.searchCtl.text.isEmpty) return;
                        controller.clearFilter();
                      },
                      child: Text(
                        LocaleKeys.clear.tr,
                        style: AppTextStyle.midPrimaryBold,
                      ),
                    ),
                  ],
                ),
                UIConstants.spacing.height,
                AppSearchBar(
                  controller: controller.searchCtl,
                  hintText: LocaleKeys.searchByCIDName.tr,
                  onSubmitted: (value) => controller.onSearch(value),
                  onChanged: (value) => controller.onSearch(value),
                  onClear: controller.onClearSearch,
                ),
              ],
            ),
          ),

          // ── List ──
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(color: AppColor.red),
                );
              }

              if (controller.customerModel.isEmpty) {
                return const NoDataWidget();
              }

              final visibleItems =
                  controller.customerModel
                      .take(controller.visibleCount.value)
                      .toList();

              return RefreshIndicator(
                backgroundColor: AppColor.white,
                color: AppColor.primary,
                onRefresh: () async => controller.onRefresh(),
                child: pull.SmartRefresher(
                  header: pull.CustomHeader(
                    height: 0,
                    builder: (context, mode) => const SizedBox.shrink(),
                  ),
                  enablePullUp: !controller.pagination.isEndOfPage,
                  controller: controller.refreshCtl,
                  onLoading: () async => controller.onLoading(),
                  child: ListView.builder(
                    padding: EdgeInsets.only(
                      left: UIConstants.spacing.toDouble(),
                      right: UIConstants.spacing.toDouble(),
                      top: UIConstants.midSpacing.toDouble(),
                    ),
                    // +1 for the Show More row at the bottom
                    itemCount: visibleItems.length + 1,
                    itemBuilder: (context, index) {
                      // Last slot = Show More button or end spacer
                      if (index == visibleItems.length) {
                        final int visible = controller.visibleCount.value;
                        final int total = controller.customerModel.length;

                        if (visible >= total) {
                          return UIConstants.spacing.height;
                        }

                        return Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: UIConstants.spacing.toDouble(),
                          ),
                          child: Center(
                            child: TextButton.icon(
                              onPressed: controller.showMore,
                              icon: const Icon(
                                Icons.keyboard_arrow_down,
                                color: AppColor.primary,
                              ),
                              label: Text(
                                'Show More (${total - visible} remaining)',
                                style: const TextStyle(color: AppColor.primary),
                              ),
                            ),
                          ),
                        );
                      }

                      return Padding(
                        padding: UIConstants.spacing.padBottom,
                        child: CustomersItemWidget(
                          delivery: visibleItems[index],
                        ),
                      );
                    },
                  ),
                ),
              );
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addCustomerHandleTap,
        tooltip: 'Add Customer',
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: AppBottomNav(
        navKey: const ValueKey('customers-nav'),
        initialActiveIndex: 1,
        activeColor: AppColor.blueGrey,
        // TODO: swap based on role when ready
        // items: UserRepository.shared.isAdmin
        //     ? loanNavItemsAdmin()
        //     : loanNavItemsCO(),
        items: mainNavItems(),
        onTap: (index) {
          Get.offAllNamed(Routes.start);
          Future.delayed(const Duration(milliseconds: 100), () {
            Get.find<StartController>().changeMenu(index);
          });
        },
      ),
    );
  }

  void _addCustomerHandleTap() {
    Get.back();
    Get.toNamed(Routes.addCustomer);
  }
}
