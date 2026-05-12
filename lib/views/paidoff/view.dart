import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:apploan/core/core.dart';
import 'package:apploan/models/models.dart';
import 'package:apploan/views/views.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart' as pull;

class PaidOffView extends GetView<PaidOffController> {
  const PaidOffView({Key? key}) : super(key: key);

  // String formatCurrency(String amount) {
  //   // ignore: unnecessary_null_comparison
  //   return amount != null
  //       ? '${NumberFormat.currency(locale: 'en_US', symbol: '').format(double.parse(amount))}'.replaceAll('.00', '')
  //       : 'N/A';
  // }
  String formatCurrency(String amount) {
    final parsed = double.tryParse(amount);
    if (parsed == null) return 'N/A';
    return 'រៀល ${NumberFormat.currency(locale: 'en_US', symbol: '').format(parsed)}'
        .replaceAll('.00', '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppColor.red),
          );
        }
        if (controller.repaymentModels.isEmpty) {
          return const NoDataWidget();
        }

        final List<PaidOffModel> delivery = controller.repaymentModels;

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
                          controller.fetchRepaymentSearch(
                            isRefresh: true,
                            isFilter: false,
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
                      controller.fetchRepaymentSearch(
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
            Padding(
              padding: UIConstants.spacing.padHorizontal,
              child: Text(
                '${LocaleKeys.totalOS.tr} ${controller.totalAmount.text} |  ${controller.totalClient.text} ${LocaleKeys.clients.tr}',
                style: AppTextStyle.normalPrimaryBold,
              ),
            ),
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
                        child: PaidOffItemWidget(delivery: delivery[index]),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
