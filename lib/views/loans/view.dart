import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:apploan/core/core.dart';
import 'package:apploan/views/views.dart';
import 'package:apploan/models/models.dart';

class LoansDashboardView extends GetView<LoansDashboardController> {
  const LoansDashboardView({Key? key}) : super(key: key);
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
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              controller.isLoading.value ? null : Navigator.pop(context, false);
            },
          ),
          title: Text(LocaleKeys.loans.tr),
          iconTheme: const IconThemeData(color: Colors.black),
          elevation: 0.0,
          backgroundColor: AppColor.primary,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Obx(() {
                if (controller.isLoadings.value ||
                    controller.isLoading1.value) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 10.0,
                          top: 5.0,
                          right: 10.0,
                          bottom: 5.0,
                        ),
                        child: TotalPackageWidget(
                          icon: Icons.people_alt,
                          packages:
                              '${controller.totalClient.text}'
                              ' ${LocaleKeys.clients.tr}',
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 10.0,
                          top: 0.0,
                          right: 10.0,
                          bottom: 0.0,
                        ),
                        child: TotalIncomeWidget(
                          codKhr: controller.totalAmount.text,
                        ),
                      ),
                    ],
                  );
                }
              }),
              5.height,
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
              Obx(() {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      LinearProgressIndicator(
                        value: controller.progress.value,
                        backgroundColor: Colors.grey[300],
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                      ),
                      SizedBox(height: 20),
                      Text(
                        '${(controller.progress.value * 100).toStringAsFixed(0)}% Synced',
                      ),
                    ],
                  ),
                );
              }),
              Obx(() {
                return PrimaryButton(
                  text: LocaleKeys.transfer.tr,
                  width: 100,
                  onPressed: controller.isLoading.value ? null : onSearch,
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
