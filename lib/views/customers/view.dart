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
        title: LocaleKeys.customer.tr,
        onBack: () => Navigator.pop(context, false),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppColor.red),
          );
        }

        if (controller.customerModel.isEmpty) {
          return const NoDataWidget();
        }

        final List<ClientModel> delivery = controller.customerModel;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: UIConstants.spacing.padHorizontal,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  UIConstants.spacing.height,

                  // Clear
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        LocaleKeys.searchByCIDName.tr,
                        style: AppTextStyle.midPrimaryBold,
                      ),
                      InkWell(
                        onTap: () {
                          if (controller.searchCtl.text.isEmpty) {
                            return;
                          }
                          controller.clearFitler();
                          controller.fetchClientSearch(
                            isRefresh: true,
                            isFilter: true,
                          );
                        },
                        child: Text(
                          LocaleKeys.clear.tr,
                          style: AppTextStyle.midPrimaryBold,
                        ),
                      ),
                    ],
                  ),
                  UIConstants.spacing.height,

                  // Search
                  CustomTextField(
                    controller: controller.searchCtl,
                    filled: true,
                    hintText: LocaleKeys.searchByCIDName.tr,
                    onFieldSubmitted: (value) {
                      if (value.isEmpty) {
                        return;
                      }
                      controller.setSearchValue();
                      controller.fetchClientSearch(
                        isRefresh: true,
                        isFilter: true,
                      );
                    },
                  ),
                  UIConstants.spacing.height,
                ],
              ),
            ),

            // Title
            // Padding(
            //   padding: UIConstants.spacing.padHorizontal,
            //   child: Text(
            //     '${LocaleKeys.totalOS.tr} ${controller.total}  ${LocaleKeys.totalClient.tr}',
            //     style: AppTextStyle.midPrimaryBold,
            //   ),
            // ),
            UIConstants.midSpacing.height,

            // Listing
            Expanded(
              child: RefreshIndicator(
                backgroundColor: AppColor.white,
                color: AppColor.primary,
                onRefresh: () async => await controller.onRefresh(),
                child: pull.SmartRefresher(
                  header: pull.CustomHeader(
                    height: 0,
                    builder: (context, mode) => const SizedBox.shrink(),
                  ),
                  enablePullUp: !controller.pagination.isEndOfPage,
                  controller: controller.refreshCtl,
                  onLoading: () async => await controller.onLoading(),
                  child: ListView.builder(
                    padding: EdgeInsets.only(
                      left: UIConstants.spacing.toDouble(),
                      right: UIConstants.spacing.toDouble(),
                      top: UIConstants.midSpacing.toDouble(),
                    ),
                    itemCount: delivery.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: UIConstants.spacing.padBottom,
                        child: CustomersItemWidget(delivery: delivery[index]),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: AddCustomerHandleTap,
        tooltip: 'Perform Action',
        child: const Icon(Icons.add),
      ),
    );
  }

  void AddCustomerHandleTap() {
    Get.back();
    Get.toNamed(Routes.addCustomer);
  }
}
