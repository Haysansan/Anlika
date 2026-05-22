import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:apploan/core/core.dart';
import 'package:apploan/models/models.dart';
import 'package:apploan/views/views.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart' as pull;
import 'package:intl/intl.dart';

class WrittenoffView extends GetView<WrittenoffController> {
  const WrittenoffView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: LocaleKeys.writtenoff.tr,
        onBack: () => Navigator.pop(context, false),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppColor.red),
          );
        }

        if (controller.repaymentModel.isEmpty) {
          return const NoDataWidget();
        }

        final List<WrittenOffModel> delivery = controller.repaymentModel;

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
                          controller.fetchDelivery(
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
                      controller.fetchDelivery(isRefresh: true, isFilter: true);
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
                '${LocaleKeys.totalOS.tr} ${formatCurrency(controller.total.toString())}  & ${controller.totalclient.toString()} ${LocaleKeys.totalClient.tr}',
                style: AppTextStyle.smallPrimaryRegular,
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
                        child: WrittenoffWidget(WOLoan: delivery[index]),
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

  // String formatCurrency(String amount) {
  //   // ignore: unnecessary_null_comparison
  //   return amount != null
  //       ? 'រៀល ${NumberFormat.currency(locale: 'en_US', symbol: '').format(double.parse(amount))}'.replaceAll('.00', '')
  //       : 'N/A';
  // }
  String formatCurrency(String amount) {
    final parsed = double.tryParse(amount);
    if (parsed == null) return 'N/A';
    return 'រៀល ${NumberFormat.currency(locale: 'en_US', symbol: '').format(parsed)}'
        .replaceAll('.00', '');
  }
}
