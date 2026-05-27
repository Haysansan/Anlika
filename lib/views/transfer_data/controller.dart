import 'dart:convert';
import 'dart:io';

import 'package:apploan/core/core.dart';
import 'package:apploan/core/offline/database_helper.dart';
import 'package:apploan/models/models.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import 'package:http_parser/http_parser.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:apploan/views/views.dart';

class TransferDataController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  var isLoading = false.obs;
  final RxBool isLoadings = false.obs;
  final RxBool isErrorLoadings = false.obs;
  final RxBool isLoading1 = false.obs;
  var progress = 0.0.obs; // Track progress
  final RxList<PaymentModel> repayment = <PaymentModel>[].obs;
  final RxList<PaymentModel> repayments = <PaymentModel>[].obs;
  // final TextEditingController totalClient = TextEditingController();
  // final TextEditingController totalAmount = TextEditingController();

  // ── Summary data ──
  final RxInt customerCount = 0.obs;
  final RxDouble sum = 0.0.obs;
  final RxDouble collectedSum = 0.0.obs;
  final RxDouble totalRepaymentSum = 0.0.obs;
  final RxDouble exchangeRate = 4100.0.obs;
  // ── Tab state ──
  final RxInt selectedIndex = 0.obs;
  late Rx<Widget> selectedScreen = screens[0].obs;
  // Static so it survives hot reload (same as StartController)
  static List<Widget> screens = [const DashboardView()];
  final RxList<PaymentModel> repaymentNotSync = <PaymentModel>[].obs;

  @override
  void onInit() {
    screens = List.from([
      const DashboardView(), // index 0 — Loans home grid
      const SizedBox(), // index 1 — TODO: replace with real screen e.g. AddCustomersView()
      const DisburmentListView(), // index 2 — Disbursement list (already exists)
    ]);
    selectedScreen = screens[0].obs;
    _loadData();
    super.onInit();
    // Any initialization code can go here
  }

  @override
  void onClose() {
    super.onClose();
  }

  // ── Tab navigation ──
  void handleClickBack() {
    if (selectedIndex.value != 0) {
      changeMenu(0);
    }
  }

  void changeMenu(int index) {
    selectedIndex.value = index;
    selectedScreen.value = screens[selectedIndex.value];

    // Trigger data fetch per tab — add more cases as screens are built
    if (index == 2) {
      final DisburmentListController disbCtl =
          Get.find<DisburmentListController>();
      disbCtl.fetchDisburmentList();
    }

    // TODO index 1 — uncomment and wire when New Clients screen is ready:
    // if (index == 1) {
    //   final AddCustomersController addCtl = Get.find<AddCustomersController>();
    //   addCtl.someInitMethod();
    // }
  }

  String getTitle() {
    switch (selectedIndex.value) {
      case 0:
        return LocaleKeys.loans.tr;
      case 1:
        return 'New Clients'; // TODO: add locale key when ready
      case 2:
        return LocaleKeys.loanDisbursmentsList.tr;
      default:
        return LocaleKeys.loans.tr;
    }
  }

  // ── Summary data loaders ───
  Future<void> _loadData() async {
    isLoading.value = true;
    await Future.wait([
      _countCustomers(),
      _calculateSum(),
      _calculateCollected(),
      _calculateTotalRepayment(),
    ]);
    isLoading.value = false;
  }

  // show branch_id for login
  Future<int?> getbranchId() async {
    int? branchId = await SharedPreferencesManager.getIntValue('branch_id');
    return branchId;
  }

  // show user_id from login
  Future<int?> getUserId() async {
    int? user_id = await SharedPreferencesManager.getIntValue('user_id');
    return user_id;
  }

  Future<void> _countCustomers() async {
    customerCount.value =
        await DatabaseHelper.instance.countCustomersRepaymentNotYetSync();
  }

  Future<void> _calculateSum() async {
    List<PaymentModel> rows =
        await DatabaseHelper.instance.queryAllRowsCollected();

    sum.value = rows.fold(
      0.0,
      (prev, element) => prev + (double.tryParse(element.total_repayment) ?? 0),
    );
  }

  Future<void> _calculateCollected() async {
    final List<PaymentModel> rows =
        await DatabaseHelper.instance.queryAllRowsCollected();
    collectedSum.value = rows.fold(
      0.0,
      (prev, e) => prev + (double.tryParse(e.total_repayment) ?? 0),
    );
  }

  Future<void> _calculateTotalRepayment() async {
    final List<RepaymentModel> rows = await DatabaseHelper.instance
        .queryAllRowsRepayments(1);
    totalRepaymentSum.value = rows.fold(
      0.0,
      (prev, e) => prev + (double.tryParse(e.total_amount) ?? 0),
    );
  }

  // String formatCurrency(String amount) {
  //   // ignore: unnecessary_null_comparison
  //   return amount != null
  //       ? '${NumberFormat.currency(locale: 'en_US', symbol: '').format(double.parse(amount))}'
  //           .replaceAll('.00', '')
  //       : 'N/A';
  // }
  String formatCurrency(String amount) {
    final parsed = double.tryParse(amount);
    if (parsed == null) return 'N/A';
    return 'រៀល ${NumberFormat.currency(locale: 'en_US', symbol: '').format(parsed)}'
        .replaceAll('.00', '');
  }

  String get totalToCollectUsd {
    if (exchangeRate.value == 0 || totalRepaymentSum.value == 0)
      return '\$0.00';
    final usd = totalRepaymentSum.value / exchangeRate.value;
    return '\$${NumberFormat('#,##0.00').format(usd)}';
  }

  String get totalToCollectKhr {
    return '${NumberFormat('#,##0').format(totalRepaymentSum.value)}៛';
  }

  // Future<void> sendDataToServer() async {
  //   WakelockPlus.enable();
  //   int? branchId = await getbranchId();
  //   int? user_id = await getUserId();
  //   try {
  //     isLoading.value = true; // Start loading
  //     progress.value = 0.0; // Reset progress
  //     repayment.value = await DatabaseHelper.instance.queryAllRowsCollected();
  //     repayment.value =
  //         repayment.value.where((item) => item.synced == "0").toList();

  //     var i = repayment.value.length;
  //     for (var item in repayment.value) {
  //       try {
  //         await DatabaseHelper.instance.updateCollected({
  //           'id': item.id,
  //           'client': item.client,
  //           'loan_officer': item.loan_officer,
  //           'branch': branchId,
  //           'client_id': item.client_id,
  //           'loan_id': item.loan_id,
  //           'client_code': item.client_code,
  //           'photo': item.photo,
  //           'submitted_on': item.submitted_on,
  //           'total_repayment': item.total_repayment,
  //           'amount_penalty': item.amount_penalty,
  //           'status_pay': 'មិនទាន់អនុម័ត',
  //           'syncedate': item.submitted_on,
  //           'synced': 1,
  //         });
  //       } catch (e) {
  //         print("Sync failed: $e");
  //         DialogManager.showDialog(
  //           title: LocaleKeys.error.tr,
  //           subTitle: LocaleKeys.syncFailed.tr,
  //         );

  //         return;
  //       }
  //       // Simulate sending item to server
  //       dio.FormData postData = dio.FormData.fromMap({
  //         'loan_id': item.loan_id,
  //         'amount': item.total_repayment,
  //         'amount_penalty': item.amount_penalty,
  //         'receipt': '',
  //         'date': item.submitted_on,
  //         'currency_id': 2,
  //         'created_by_id': user_id,
  //         'description': "Post Repayment",
  //         'gateway_id': 1,
  //       });

  //       await Get.find<ApiService>().post(
  //         EndPoints.repaymentStore,
  //         postData,
  //         isShowLoading: true,
  //       );

  //       await Future.delayed(Duration(seconds: 1)); // Simulate delay
  //       i++;
  //       progress.value = i / 10;
  //     }
  //     // Show success dialog
  //     DialogManager.showDialog(
  //       title: LocaleKeys.successfully.tr,
  //       subTitle: LocaleKeys.youHavesuccessfullysyncData.tr,
  //       onPressed: () => Get.back(),
  //     );
  //   } catch (e) {
  //     // Handle any errors
  //     print("Sync failed: $e");
  //     DialogManager.showDialog(
  //       title: LocaleKeys.error.tr,
  //       subTitle: LocaleKeys.syncFailed.tr,
  //       onPressed: () => Get.back(),
  //     );
  //   } finally {
  //     isLoading.value = false;
  //     // WakelockPlus.disable();
  //   }
  // }
  Future<void> sendDataToServer() async {
    WakelockPlus.enable();
    int? branchId = await getbranchId();
    int? user_id = await getUserId();
    try {
      isLoading.value = true;
      progress.value = 0.0;
      repayment.value = await DatabaseHelper.instance.queryAllRowsCollected();
      repayment.value =
          repayment.value.where((item) => item.synced == "0").toList();

      var i = 0;
      int failed = 0;
      int total = repayment.value.length;

      for (var item in repayment.value) {
        try {
          final Map<String, dynamic> postData = {
            'loan_id': item.loan_id,
            'total_amount': item.total_repayment,
            'amount_penalty': item.amount_penalty,
            'receipt': '',
            'date': item.submitted_on,
            'currency_id': 2,
            'created_by_id': user_id,
            'description': "Post Repayment",
            'gateway_id': 1,
          };

          await Get.find<ApiService>().post(
            EndPoints.repaymentStore,
            postData,
            isShowLoading: false,
          );

          await DatabaseHelper.instance.updateCollected({
            'id': item.id,
            'client': item.client,
            'loan_officer': item.loan_officer,
            'branch': branchId,
            'client_id': item.client_id,
            'loan_id': item.loan_id,
            'client_code': item.client_code,
            'photo': item.photo,
            'submitted_on': item.submitted_on,
            'total_repayment': item.total_repayment,
            'amount_penalty': item.amount_penalty,
            'status_pay': 'មិនទាន់អនុម័ត',
            'syncedate': item.submitted_on,
            'synced': 1,
          });

          i++;
          progress.value = total > 0 ? i / total : 0;
        } catch (e) {
          print("Sync failed: $e");
          failed++;
        }
      }

      if (failed == 0) {
        DialogManager.showDialog(
          title: LocaleKeys.successfully.tr,
          subTitle: LocaleKeys.youHavesuccessfullysyncData.tr,
          onPressed: () => Get.back(),
        );

        // ── refresh card after sync ──
        await _countCustomers();
        await _calculateSum();

        if (Get.isRegistered<DashboardController>()) {
          Get.find<DashboardController>().fetchSummaryAmounts();
        }
      } else if (i > 0) {
        DialogManager.showDialog(
          title: LocaleKeys.error.tr,
          subTitle: "$i/$total synced. $failed failed.",
          onPressed: () => Get.back(),
        );
      } else {
        DialogManager.showDialog(
          title: LocaleKeys.error.tr,
          subTitle: LocaleKeys.syncFailed.tr,
          onPressed: () => Get.back(),
        );
      }
    } catch (e) {
      print("Sync failed: $e");
      DialogManager.showDialog(
        title: LocaleKeys.error.tr,
        subTitle: LocaleKeys.syncFailed.tr,
        onPressed: () => Get.back(),
      );
    } finally {
      isLoading.value = false;
      WakelockPlus.disable();
    }
  }

  Future<void> sendDataToServerJsonData() async {
    WakelockPlus.enable();
    int? branchId = await getbranchId();
    int? userId = await getUserId();

    try {
      isLoading.value = true;
      progress.value = 0.0;

      // Get unsynced repayments
      repayment.value = await DatabaseHelper.instance.queryAllRowsCollected();
      repayment.value =
          repayment.value.where((item) => item.synced == "0").toList();

      if (repayment.isEmpty) {
        DialogManager.showDialog(
          title: "No Data",
          subTitle: "There are no repayments to sync.",
        );
        return;
      }

      // Prepare JSON data
      Map<String, dynamic> jsonData = {
        "branch_id": branchId,
        "user_id": userId,
        "repayments":
            repayment
                .map(
                  (item) => {
                    "loan_id": item.loan_id,
                    "amount": item.total_repayment,
                    "amount_penalty": item.amount_penalty,
                    "receipt": "",
                    "date": item.submitted_on,
                    "currency_id": 2,
                    "created_by_id": userId,
                    "description": "Post Repayment",
                    "gateway_id": 1,
                  },
                )
                .toList(),
      };

      print('Prepared JSON Data: ${jsonData}');

      // Save JSON data to a file
      Directory tempDir = await getTemporaryDirectory();
      String filePath = '${tempDir.path}/repayments.json';
      File jsonFile = File(filePath);

      await jsonFile.writeAsString(json.encode(jsonData));
      print('JSON file created at: $filePath');

      // Prepare multipart upload
      dio.FormData formData = dio.FormData.fromMap({
        "file": await dio.MultipartFile.fromFile(
          jsonFile.path,
          filename: "repayments.json",
          contentType: MediaType(
            'application',
            'json',
          ), // import 'package:http_parser/http_parser.dart';
        ),
      });

      // Upload file to server
      await Get.find<ApiService>().post(
        EndPoints.repaymentStore,
        formData,
        isShowLoading: true,
      );

      print('File uploaded successfully');

      // // Update local DB as synced
      for (var item in repayment.value) {
        try {
          final updateData = {
            'id': item.id,
            'client': item.client,
            'loan_officer': item.loan_officer,
            'branch': branchId,
            'client_id': item.client_id,
            'loan_id': item.loan_id,
            'client_code': item.client_code,
            'photo': item.photo,
            'submitted_on': item.submitted_on,
            'total_repayment': item.total_repayment,
            'amount_penalty': item.amount_penalty,
            'status_pay': 'មិនទាន់អនុម័ត',
            'syncedate': item.submitted_on,
            'synced': 1,
          };

          await DatabaseHelper.instance.updateCollected(updateData);
        } catch (e) {
          print("Sync failed: $e");
          DialogManager.showDialog(
            title: LocaleKeys.error.tr,
            subTitle: LocaleKeys.syncFailed.tr,
          );
          return;
        }
      }

      DialogManager.showDialog(
        title: LocaleKeys.successfully.tr,
        subTitle: LocaleKeys.youHavesuccessfullysyncData.tr,
        onPressed: () => Get.back(),
      );
    } catch (e) {
      print("Sync failed: $e");
      DialogManager.showDialog(
        title: LocaleKeys.error.tr,
        subTitle: LocaleKeys.syncFailed.tr,
        onPressed: () => Get.back(),
      );
    } finally {
      isLoading.value = false;
      WakelockPlus.disable();
    }
  }
}
