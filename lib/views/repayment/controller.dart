import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:apploan/core/core.dart';
import 'package:apploan/core/offline/database_helper.dart';
import 'package:apploan/flavor/flavor.dart';
import 'package:apploan/models/models.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:apploan/views/views.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RepaymentController extends GetxController {
  final RxInt selectedStatusValue = 0.obs;
  final TextEditingController startBillCreateDateCtl = TextEditingController();
  final TextEditingController endBillCreateDateCtl = TextEditingController();
  final TextEditingController totalClient = TextEditingController();
  final TextEditingController totalAmount = TextEditingController();
  final TextEditingController searchCtl = TextEditingController();

  final RxList<RepaymentModel> repaymentModel = <RepaymentModel>[].obs;
  final RxBool isLoading = false.obs;
  final PaginationModel pagination = PaginationModel(limit: 15);
  final RefreshController refreshCtl = RefreshController(initialRefresh: false);
  final RxBool isToggleOpen = false.obs;
  num total = 0;

  final StartController startCtl = Get.find<StartController>();

  @override
  void onInit() {
    super.onInit();
    fetchRepayment();
  }

  @override
  void onClose() {
    searchCtl.dispose();
    refreshCtl.dispose();
    super.onClose();
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

  Future<void> fetchRepayment({
    bool isRefresh = false,
    bool isLoadMore = false,
    bool isFilter = false,
  }) async {
    try {
      if (isRefresh) {
        if (!isFilter) {
          clearFitler();
        }
        pagination.refresh();
      }

      if (pagination.isEndOfPage) {
        return;
      }

      // Show loading only when first time and filter
      if ((!isRefresh && !isLoadMore) || isFilter) {
        isLoading.value = true;
      }

      // Take care of load more error when while load more user switch the tap
      if (startCtl.selectedIndex.value != 3 && isLoadMore) {
        return;
      }

      // totalClient.text  = getPropertyFromJson(res.data, 'totalClient');
      // totalAmount.text  = getPropertyFromJson(res.data, 'totalAmount');

      // total = getPropertyFromJson(res.data['totalAmount'], 'total') ?? 0;
      // pagination.checkLoadMore((data['data'] as List).length);
      _calculateSum();
      _countCustomers();
      // _calculateCollected();
      if (isRefresh) {
        repaymentModel.value = await DatabaseHelper.instance
            .queryAllRowsRepayments(1);
      } else {
        repaymentModel.addAll(
          await DatabaseHelper.instance.queryAllRowsRepayments(1),
        );
      }
    } catch (e) {
      if (isClosed) {
        return;
      }
      ExceptionHandler.handleException(e);
    } finally {
      isLoading.value = false;
    }
  }

  // // % Repayment
  // double collectedSum = 0;

  // Future<void> _calculateCollected() async {
  //   List<PaymentModel> rows =
  //       await DatabaseHelper.instance.queryAllRowsCollected();
  //   collectedSum = rows.fold(
  //     0.0,
  //     (prev, element) => prev + (double.tryParse(element.total_repayment) ?? 0),
  //   );
  // }

  ///Repayment
  final RxDouble sum = 0.0.obs;

  Future<void> _calculateSum() async {
    List<PaymentModel> rows =
        await DatabaseHelper.instance.queryAllRowsCollectedNotYetSync();
    sum.value = rows.fold(
      0.0,
      (prev, element) => prev + (double.tryParse(element.total_repayment) ?? 0),
    );
  }

  ///Repayment
  final RxInt customerCount = 0.obs;
  Future<void> _countCustomers() async {
    customerCount.value =
        await DatabaseHelper.instance.countCustomersRepayment();
  }

  Future<void> fetchRepaymentSearch({
    bool isRefresh = false,
    bool isLoadMore = false,
    bool isFilter = false,
  }) async {
    if (isFilter == true) {
      String searchText = searchCtl.text.toLowerCase();
      repaymentModel.value = List<RepaymentModel>.from(
        repaymentModel.value.where(
          (item) =>
              item.client.toLowerCase().contains(searchText) ||
              item.client_code.toLowerCase().contains(searchText),
        ),
      );
    } else {
      onRefresh();
    }
  }

  Future<void> onRefresh({bool isFilter = false}) async {
    await fetchRepayment(isRefresh: true, isFilter: isFilter);
    refreshCtl.refreshCompleted();
  }

  Future<void> onLoading() async {
    await fetchRepayment(isLoadMore: true);
    refreshCtl.loadComplete();
  }

  void clearFitler() {
    searchCtl.text = '';
  }

  void setSearchValue() {
    selectedStatusValue.value = 0;
  }

  void setFilterValue({num value = 0}) {
    searchCtl.text = '';
  }

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
}
