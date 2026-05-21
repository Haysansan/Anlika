import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:apploan/core/core.dart';
import 'package:apploan/flavor/flavor.dart';
import 'package:apploan/models/models.dart';
import 'package:apploan/views/views.dart';
import 'package:apploan/core/offline/database_helper.dart';

class DashboardController extends GetxController {
  final TextEditingController dateCtl = TextEditingController();

  final Rxn<DashboardModel> dashboardModel = Rxn<DashboardModel>();
  final RxBool isLoading = false.obs;
  final RxString userName = ''.obs;

  final ReasonController reasonCtl = Get.find<ReasonController>();
  final StartController startCtl = Get.find<StartController>();

  final RxList<BookingModel> bookings = <BookingModel>[].obs;

  final RxString totalToCollect = '\$0.00'.obs;
  final RxString totalCollected = '\$0.00'.obs;
  final RxString totalToCollectKhr = '0.00រ'.obs;
  final RxString totalCollectedKhr = '0.00រ'.obs;

  @override
  void onInit() {
    _loadUserName();
    super.onInit();
    fetchSummaryAmounts();
  }

  @override
  void onClose() {
    dateCtl.dispose();
    super.onClose();
  }

  // ── Load user name from SharedPreferences ────────────────────
  Future<void> _loadUserName() async {
    try {
      final raw = await SharedPreferencesManager.get('user_name');
      final name = raw?.toString() ?? '';
      userName.value = name.isNotEmpty ? name : 'User';
    } catch (_) {
      userName.value = 'User';
    }
  }

  // ── Fetch totals from local SQLite ───────────────────────────
  Future<void> fetchSummaryAmounts() async {
    try {
      // Amount to Collect — unpaid rows not yet in Collected table
      final List<RepaymentModel> toCollectRows = await DatabaseHelper.instance
          .queryAllRowsRepayments(1);
      final double toCollectSum = toCollectRows.fold(
        0.0,
        (prev, item) => prev + (double.tryParse(item.total_amount) ?? 0.0),
      );

      // Amount Collected — everything saved in Collected table
      final List<PaymentModel> collectedRows =
          await DatabaseHelper.instance.queryAllRowsCollected();
      final double collectedSum = collectedRows.fold(
        0.0,
        (prev, item) => prev + (double.tryParse(item.total_repayment) ?? 0.0),
      );

      totalToCollect.value = _formatUsd(toCollectSum);
      totalCollected.value = _formatUsd(collectedSum);
      totalToCollectKhr.value = _formatKhr(toCollectSum);
      totalCollectedKhr.value = _formatKhr(collectedSum);
    } catch (_) {
      // Fail silently — card shows $0.00 instead of crashing
    }
  }

  // ── Format helpers ───────────────────────────────────────────
  String _formatUsd(double amount) {
    return '\$${NumberFormat('#,##0.00').format(amount)}';
  }

  String _formatKhr(double amount) {
    final double khr = amount * 4100;
    return '${NumberFormat('#,###').format(khr)}រ';
  }

  // ── Date picker ──────────────────────────────────────────────
  DatePicker getDatePicker() {
    return DatePicker(
      controller: dateCtl,
      initialDate:
          dateCtl.text.isEmpty
              ? DateTime.parse(
                '${DateFormat("yyyy-MM-dd").format(DateTime.now())} 00:00:00',
              )
              : DateTime.parse(dateCtl.text),
      minDate: DateTime(DateTime.now().year - 200),
      maxDate: DateTime(DateTime.now().year + 200),
      minYear: DateTime.now().year - 200,
      maxYear: DateTime.now().year + 200,
    );
  }

  void gridHandleTap(DeliveryStatus status) {
    if (!AppConfig.shared.isDeliveryTapOpened) {
      AppConfig.shared.isDeliveryTapOpened = true;
    }
    int deliveryStatus = 0;
    switch (status) {
      case DeliveryStatus.success:
        deliveryStatus = 3;
        break;
      case DeliveryStatus.inProgress:
        deliveryStatus = 1;
        break;
      case DeliveryStatus.problem:
        deliveryStatus = 5;
        break;
      default:
    }
    startCtl.changeMenu(
      3,
      isFromGrid: true,
      dateFilter: dateCtl.text,
      deliveryStatus: deliveryStatus,
    );
  }

  void clearDateFilter() {
    dateCtl.text = '';
  }
}
