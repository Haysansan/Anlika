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

class WrittenoffController extends GetxController {
  final RxInt selectedStatusValue = 0.obs;
  final TextEditingController startBillCreateDateCtl = TextEditingController();
  final TextEditingController endBillCreateDateCtl = TextEditingController();
  final TextEditingController startBillFinishDateCtl = TextEditingController();
  final TextEditingController endBillFinishDateCtl = TextEditingController();
  // final TextEditingController searchCtl = TextEditingController();

  final RxList<WrittenOffModel> repaymentModel = <WrittenOffModel>[].obs;
  final RxBool isLoading = false.obs;
  final PaginationModel pagination = PaginationModel(limit: 15);
  final RefreshController refreshCtl = RefreshController(initialRefresh: false);
  final RxBool isToggleOpen = false.obs;
  num total = 0;
  num totalclient = 0;
  final StartController startCtl = Get.find<StartController>();

  // ── Search bar ──
  final TextEditingController searchCtl = TextEditingController();
  // Holds the full unfiltered list loaded from DB
  final RxList<RepaymentModel> _allRepayments = <RepaymentModel>[].obs;
  // The list the view actually renders
  final RxList<RepaymentModel> filteredRepayments = <RepaymentModel>[].obs;
  final RxInt visibleCount = _pageSize.obs;

  // ── Tab state ──
  final RxInt selectedIndex = 0.obs;
  // late Rx<Widget> selectedScreen = screens[0].obs;

  // Static so it survives hot reload (same as StartController)
  // static List<Widget> screens = [const DashboardView()];
  static const int _pageSize = 10;

  @override
  void onInit() {
    fetchDelivery();
    super.onInit();
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

  @override
  void onClose() {
    startBillCreateDateCtl.dispose();
    endBillCreateDateCtl.dispose();
    startBillFinishDateCtl.dispose();
    endBillCreateDateCtl.dispose();
    searchCtl.dispose();
    refreshCtl.dispose();
    super.onClose();
  }

  // ── Search logic ──

  // void onSearch(String value) {
  //   visibleCount.value = _pageSize;
  //   if (value.trim().isEmpty) {
  //     filteredRepayments.assignAll(_allRepayments);
  //     return;
  //   }
  //   final query = value.trim().toLowerCase();
  //   filteredRepayments.assignAll(
  //     _allRepayments.where(
  //       (item) =>
  //           item.client.toLowerCase().contains(query) ||
  //           item.client_code.toLowerCase().contains(query),
  //     ),
  //   );
  // }

  // void onClearSearch() {
  //   visibleCount.value = _pageSize;
  //   searchCtl.clear();
  //   filteredRepayments.assignAll(_allRepayments);
  // }

  void clearFilter({int status = 0}) {
    // onClearSearch();
    selectedStatusValue.value = status;
    startBillCreateDateCtl.clear();
    endBillCreateDateCtl.clear();
    startBillFinishDateCtl.clear();
    endBillFinishDateCtl.clear();
  }

  // void showMore() {
  //   final int remaining = filteredRepayments.length - visibleCount.value;
  //   // use min() instead of clamp to keep the type as int
  //   visibleCount.value += remaining < _pageSize ? remaining : _pageSize;
  // }

  Future<void> fetchDelivery({
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
      int? branchId = await getbranchId();
      int? userId = await getUserId();
      // Show loading only when first time and filter
      if ((!isRefresh && !isLoadMore) || isFilter) {
        isLoading.value = true;
      }

      final Map<String, dynamic> params = {
        'branch_id': branchId,
        'user_id': userId,
      };

      String endPoint = EndPoints.getWrittenOffList;

      // if (UserRepository.shared.isDriver) {
      // endPoint = EndPoints.getWrittenOffList;
      // }

      final res = await Get.find<ApiService>().get(
        endPoint,
        queryParameters: params,
        isShowLoading: false,
      );

      // final data = getPropertyFromJson(DatabaseHelper.instance.queryAllRowsRepayments(1),"data");
      // print(data);
      final data = getPropertyFromJson(res.data, 'data');
      // total = num.parse(getPropertyFromJson(res.data, 'totalAmount'));
      // totalclient = num.parse(getPropertyFromJson(res.data, 'totalClient'));
      total =
          num.tryParse(
            getPropertyFromJson(res.data, 'totalAmount')?.toString() ?? '0',
          ) ??
          0;

      totalclient =
          num.tryParse(
            getPropertyFromJson(res.data, 'totalClient')?.toString() ?? '0',
          ) ??
          0;
      // pagination.checkLoadMore((data as List).length);

      if (isRefresh) {
        repaymentModel.value = List<WrittenOffModel>.from(
          (data as List).map((e) => WrittenOffModel.fromJson(e)).toList(),
        );
      } else {
        repaymentModel.addAll(
          List<WrittenOffModel>.from(
            (data as List).map((e) => WrittenOffModel.fromJson(e)).toList(),
          ),
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

  Future<void> onRefresh({bool isFilter = false}) async {
    await fetchDelivery(isRefresh: true, isFilter: isFilter);
    refreshCtl.refreshCompleted();
  }

  // Future<void> onLoading() async {
  //   await fetchDelivery(isLoadMore: true);
  //   refreshCtl.loadComplete();
  // }

  DatePicker getStartBillCreatePicker(
    TextEditingController startDateCtl,
    TextEditingController endDateCtl,
  ) {
    final DatePicker startPicker = DatePicker(
      controller: startDateCtl,
      initialDate:
          startDateCtl.text.isEmpty
              ? DateTime.parse(
                '${DateFormat("yyyy-MM-dd").format(DateTime.now())} 00:00:00',
              )
              : DateTime.parse(startDateCtl.text),
      minDate: DateTime(DateTime.now().year - 200),
      maxDate:
          endDateCtl.text.isEmpty
              ? DateTime(DateTime.now().year + 200)
              : DateTime.parse(
                endDateCtl.text,
              ).subtract(const Duration(days: 1)),
      minYear: DateTime.now().year - 200,
      maxYear: DateTime.now().year + 200,
    );
    return startPicker;
  }

  DatePicker getEndBillCreatePicker(
    TextEditingController startDateCtl,
    TextEditingController endDateCtl,
  ) {
    final DatePicker startPicker = DatePicker(
      controller: endDateCtl,
      initialDate:
          endDateCtl.text.isNotEmpty
              ? DateTime.parse(endDateCtl.text)
              : startDateCtl.text.isNotEmpty
              ? DateTime.parse(startDateCtl.text)
              : DateTime.parse(
                '${DateFormat("yyyy-MM-dd").format(DateTime.now())} 00:00:00',
              ),
      minDate:
          startDateCtl.text.isNotEmpty
              ? DateTime.parse(startDateCtl.text)
              : endDateCtl.text.isNotEmpty
              ? DateTime.parse(endDateCtl.text)
              : DateTime(DateTime.now().year - 200),
      maxDate: DateTime(DateTime.now().year + 200),
      minYear:
          startDateCtl.text.isEmpty
              ? DateTime.now().year - 200
              : DateTime.parse(startDateCtl.text).year,
      maxYear: DateTime.now().year + 200,
    );
    return startPicker;
  }

  List<IdNameModel> getStatus() {
    final List<IdNameModel> status = [
      IdNameModel(id: 0, name: '--- ${LocaleKeys.chooseDeliveyStatus.tr} ---'),
      IdNameModel(id: 1, name: LocaleKeys.inStock.tr),
      IdNameModel(id: 2, name: LocaleKeys.inprogress.tr),
      IdNameModel(id: 3, name: LocaleKeys.complete.tr),
      IdNameModel(id: 4, name: LocaleKeys.returned.tr),
    ];
    return status;
  }

  void setSearchValue() {
    startBillCreateDateCtl.clear();
    endBillCreateDateCtl.clear();
    startBillFinishDateCtl.clear();
    endBillCreateDateCtl.clear();
    selectedStatusValue.value = 0;
  }

  void setFilterValue({num value = 0}) {
    searchCtl.text = '';
  }

  void clearFitler({int status = 0}) {
    searchCtl.text = '';
    selectedStatusValue.value = status;
    startBillCreateDateCtl.clear();
    endBillCreateDateCtl.clear();
    startBillFinishDateCtl.clear();
    endBillCreateDateCtl.clear();
  }
}
