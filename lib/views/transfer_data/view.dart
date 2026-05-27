import 'package:apploan/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:apploan/core/core.dart';
import 'package:apploan/views/views.dart';

class TransferDataView extends GetView<TransferDataController> {
  const TransferDataView({Key? key}) : super(key: key);

  void onSearch() async {
    controller.sendDataToServer();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (controller.isLoading.value) {
          bool shouldClose = await showDialog(
            context: context,
            builder:
                (context) => AlertDialog(
                  title: Text("Confirm Exit"),
                  content: Text(
                    "Data transfer is in progress. Are you sure you want to exit?",
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: Text("No"),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: Text("Yes"),
                    ),
                  ],
                ),
          );
          return shouldClose;
        } else {
          return true;
        }
      },
      child: Scaffold(
        appBar: CustomAppBar(
          title: LocaleKeys.transfersdata.tr,
          onBack: () => Navigator.pop(context, false),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),

              // ── Summary Card ──
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

              const SizedBox(height: 20),

              // ── Warning Text ──
              Padding(
                padding: UIConstants.spacing.padHorizontal,
                child: Form(
                  key: controller.formKey,
                  child: Text(
                    LocaleKeys.waitUntilSuccess.tr,
                    style: AppTextStyle.normalRedBold,
                  ),
                ),
              ),
              5.height,

              // ── Progress Bar ──
              Obx(() {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      LinearProgressIndicator(
                        value: controller.progress.value,
                        backgroundColor: Colors.grey[300],
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.redAccent,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        '${(controller.progress.value * 100).toStringAsFixed(0)}% Transferred',
                      ),
                    ],
                  ),
                );
              }),

              // ── Transfer Button ──
              Obx(() {
                return PrimaryButton(
                  text: LocaleKeys.transfersdata.tr,
                  width: 100,
                  onPressed: controller.isLoading.value ? null : onSearch,
                );
              }),
            ],
          ),
        ),
        bottomNavigationBar: AppBottomNav(
          navKey: const ValueKey('transfer-nav'),
          initialActiveIndex: 1,
          activeColor: AppColor.blueGrey,
          items: mainNavItems(),
          onTap: (index) {
            Get.offAllNamed(Routes.start);
            Future.delayed(const Duration(milliseconds: 100), () {
              Get.find<StartController>().changeMenu(index);
            });
          },
        ),
      ),
    );
  }
}
