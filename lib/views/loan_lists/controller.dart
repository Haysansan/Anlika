import 'package:apploan/core/core.dart';
import 'package:apploan/core/offline/database_helper.dart';
import 'package:apploan/models/models.dart';
import 'package:apploan/views/views.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class LoanListsController extends GetxController {
  // ── Summary data ──
  final RxBool isLoading = false.obs;
  final RxInt customerCount = 0.obs;
  final RxDouble sum = 0.0.obs;
  final RxDouble collectedSum = 0.0.obs;
  final RxDouble totalRepaymentSum = 0.0.obs;
  final RxDouble exchangeRate = 4100.0.obs;

  // ── Search bar ──
  final TextEditingController searchCtl = TextEditingController();
  // Holds the full unfiltered list loaded from DB
  final RxList<RepaymentModel> _allRepayments = <RepaymentModel>[].obs;
  // The list the view actually renders
  final RxList<RepaymentModel> filteredRepayments = <RepaymentModel>[].obs;
  final RxInt visibleCount = _pageSize.obs;

  // ── Tab state ──
  final RxInt selectedIndex = 0.obs;
  late Rx<Widget> selectedScreen = screens[0].obs;

  // Static so it survives hot reload (same as StartController)
  static List<Widget> screens = [const DashboardView()];
  static const int _pageSize = 10;

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
    searchCtl.dispose();
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

  // ── Search logic ──

  void onSearch(String value) {
    visibleCount.value = _pageSize;
    if (value.trim().isEmpty) {
      filteredRepayments.assignAll(_allRepayments);
      return;
    }
    final query = value.trim().toLowerCase();
    filteredRepayments.assignAll(
      _allRepayments.where(
        (item) =>
            item.client.toLowerCase().contains(query) ||
            item.client_code.toLowerCase().contains(query),
      ),
    );
  }

  void onClearSearch() {
    visibleCount.value = _pageSize;
    searchCtl.clear();
    filteredRepayments.assignAll(_allRepayments);
  }

  void showMore() {
    final int remaining = filteredRepayments.length - visibleCount.value;
    // use min() instead of clamp to keep the type as int
    visibleCount.value += remaining < _pageSize ? remaining : _pageSize;
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
      _loadRepayments(),
      _countCustomers(),
      _calculateSum(),
      _calculateCollected(),
      _calculateTotalRepayment(),
    ]);
    isLoading.value = false;
  }

  Future<void> _loadRepayments() async {
    final rows = await DatabaseHelper.instance.queryAllRowsRepayments(1);
    _allRepayments.assignAll(rows);
    filteredRepayments.assignAll(rows);
  }

  Future<void> _countCustomers() async {
    customerCount.value =
        await DatabaseHelper.instance.countCustomersRepaymentNotYetSync();
  }

  Future<void> _calculateSum() async {
    // final List<PaymentModel> rows =
    //     await DatabaseHelper.instance.queryAllRowsCollectedNotYetSync();
    // sum.value = rows.fold(
    //   0.0,
    //   (prev, e) => prev + (double.tryParse(e.total_repayment) ?? 0),
    // );
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
}
