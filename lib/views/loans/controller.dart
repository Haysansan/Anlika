// import 'package:apploan/core/core.dart';
// import 'package:apploan/core/offline/database_helper.dart';
// import 'package:apploan/models/models.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';

// class LoansDashboardController extends GetxController {
//   final RxBool isLoading = false.obs;

//   final RxInt customerCount = 0.obs;
//   final RxDouble sum = 0.0.obs;
//   final RxDouble collectedSum = 0.0.obs;

//   final RxInt selectedIndex = 0.obs;
//   late Rx<Widget> selectedScreen;

//   @override
//   void onInit() {
//     super.onInit();
//     _loadData();
//   }

//   @override
//   void onClose() {
//     super.onClose();
//   }

//   Future<void> _loadData() async {
//     isLoading.value = true;
//     await Future.wait([
//       _countCustomers(),
//       _calculateSum(),
//       _calculateCollected(),
//     ]);
//     isLoading.value = false;
//   }

//   Future<void> _countCustomers() async {
//     customerCount.value =
//         await DatabaseHelper.instance.countCustomersRepaymentNotYetSync();
//   }

//   Future<void> _calculateSum() async {
//     List<PaymentModel> rows =
//         await DatabaseHelper.instance.queryAllRowsCollectedNotYetSync();
//     sum.value = rows.fold(
//       0.0,
//       (prev, element) => prev + (double.tryParse(element.total_repayment) ?? 0),
//     );
//   }

//   Future<void> _calculateCollected() async {
//     List<PaymentModel> rows =
//         await DatabaseHelper.instance.queryAllRowsCollected();
//     collectedSum.value = rows.fold(
//       0.0,
//       (prev, element) => prev + (double.tryParse(element.total_repayment) ?? 0),
//     );
//   }

//   String formatCurrency(String amount) {
//     final parsed = double.tryParse(amount);
//     if (parsed == null) return 'N/A';
//     return 'រៀល ${NumberFormat.currency(locale: 'en_US', symbol: '').format(parsed)}'
//         .replaceAll('.00', '');
//   }
// }

import 'package:apploan/core/core.dart';
import 'package:apploan/core/offline/database_helper.dart';
import 'package:apploan/models/models.dart';
import 'package:apploan/views/views.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class LoansDashboardController extends GetxController {
  // ── Summary data ────────────────────────────────────────────────────────────
  final RxBool isLoading = false.obs;
  final RxInt customerCount = 0.obs;
  final RxDouble sum = 0.0.obs;
  final RxDouble collectedSum = 0.0.obs;

  // ── Tab state (mirrors StartController pattern) ──────────────────────────
  final RxInt selectedIndex = 0.obs;
  late Rx<Widget> selectedScreen = screens[0].obs;

  // Static so it survives hot reload (same as StartController)
  static List<Widget> screens = [const DashboardView()];

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
  }

  @override
  void onClose() {
    super.onClose();
  }

  // ── Tab navigation ──────────────────────────────────────────────────────────
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

  // ── Summary data loaders ────────────────────────────────────────────────────
  Future<void> _loadData() async {
    isLoading.value = true;
    await Future.wait([
      _countCustomers(),
      _calculateSum(),
      _calculateCollected(),
    ]);
    isLoading.value = false;
  }

  Future<void> _countCustomers() async {
    customerCount.value =
        await DatabaseHelper.instance.countCustomersRepaymentNotYetSync();
  }

  Future<void> _calculateSum() async {
    final List<PaymentModel> rows =
        await DatabaseHelper.instance.queryAllRowsCollectedNotYetSync();
    sum.value = rows.fold(
      0.0,
      (prev, e) => prev + (double.tryParse(e.total_repayment) ?? 0),
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

  String formatCurrency(String amount) {
    final parsed = double.tryParse(amount);
    if (parsed == null) return 'N/A';
    return 'រៀល ${NumberFormat.currency(locale: 'en_US', symbol: '').format(parsed)}'
        .replaceAll('.00', '');
  }
}
