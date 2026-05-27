import 'package:apploan/models/customer/model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:apploan/core/core.dart';
import 'package:apploan/models/models.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:apploan/views/views.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomersController extends GetxController {
  static const int _pageSize = 15;

  final RxInt selectedStatusValue = 0.obs;
  final TextEditingController startBillCreateDateCtl = TextEditingController();
  final TextEditingController endBillCreateDateCtl = TextEditingController();
  final TextEditingController startBillFinishDateCtl = TextEditingController();
  final TextEditingController endBillFinishDateCtl = TextEditingController();
  final TextEditingController searchCtl = TextEditingController();

  // Source of truth — never filtered
  final List<ClientModel> _allClients = [];
  // What the view renders
  final RxList<ClientModel> customerModel = <ClientModel>[].obs;
  // How many items are currently visible
  final RxInt visibleCount = _pageSize.obs;

  final RxBool isLoading = false.obs;
  final PaginationModel pagination = PaginationModel(limit: 15);
  final RefreshController refreshCtl = RefreshController(initialRefresh: false);

  final StartController startCtl = Get.find<StartController>();

  @override
  void onInit() {
    fetchClient();
    super.onInit();
  }

  @override
  void onClose() {
    startBillCreateDateCtl.dispose();
    endBillCreateDateCtl.dispose();
    startBillFinishDateCtl.dispose();
    endBillFinishDateCtl.dispose();
    searchCtl.dispose();
    refreshCtl.dispose();
    super.onClose();
  }

  // ── Show more ──
  void showMore() {
    visibleCount.value = (visibleCount.value + _pageSize).clamp(
      0,
      customerModel.length,
    );
  }

  // ── Search ──
  void onSearch(String query) {
    visibleCount.value = _pageSize;
    final trimmed = query.trim().toLowerCase();
    if (trimmed.isEmpty) {
      customerModel.assignAll(_allClients);
      return;
    }
    customerModel.assignAll(
      _allClients.where(
        (item) =>
            item.first_name.toLowerCase().contains(trimmed) ||
            item.last_name.toLowerCase().contains(trimmed) ||
            item.client_code.toLowerCase().contains(trimmed) ||
            item.name.toLowerCase().contains(trimmed),
      ),
    );
  }

  // ── Clear ──
  void onClearSearch() {
    visibleCount.value = _pageSize;
    searchCtl.clear();
    customerModel.assignAll(_allClients);
  }

  void clearFilter({int status = 0}) {
    onClearSearch();
    selectedStatusValue.value = status;
    startBillCreateDateCtl.clear();
    endBillCreateDateCtl.clear();
    startBillFinishDateCtl.clear();
    endBillFinishDateCtl.clear();
  }

  // Keep old name so nothing else breaks
  void clearFitler({int status = 0}) => clearFilter(status: status);

  Future<int?> getbranchId() async =>
      SharedPreferencesManager.getIntValue('branch_id');

  Future<int?> getUserId() async =>
      SharedPreferencesManager.getIntValue('user_id');

  Future<void> fetchClient({
    bool isRefresh = false,
    bool isLoadMore = false,
    bool isFilter = false,
  }) async {
    final int? branchId = await getbranchId();
    final int? userId = await getUserId();

    try {
      if (isRefresh) {
        if (!isFilter) clearFilter();
        pagination.refresh();
      }

      if (pagination.isEndOfPage) return;

      if ((!isRefresh && !isLoadMore) || isFilter) {
        isLoading.value = true;
      }

      final Map<String, dynamic> params = {
        'branch_id': branchId,
        'user_id': userId,
      };

      final String endPoint =
          UserRepository.shared.isDriver
              ? EndPoints.repayment
              : EndPoints.getClientList;

      final res = await Get.find<ApiService>().get(
        endPoint,
        queryParameters: params,
        isShowLoading: false,
      );

      if (startCtl.selectedIndex.value != 3 && isLoadMore) return;

      // API returns paginated: res.data.data.data = the actual list
      final data = getPropertyFromJson(res.data, 'data.data');
      if (data == null || data is! List) return;

      // Check if last page so pull-up load more stops
      final currentPage =
          getPropertyFromJson(res.data, 'data.current_page') ?? 1;
      final lastPage = getPropertyFromJson(res.data, 'data.last_page') ?? 1;
      if (currentPage >= lastPage) pagination.isEndOfPage = true;

      final newClients = List<ClientModel>.from(
        data.map((e) => ClientModel.fromJson(e)),
      );

      if (isRefresh || !isLoadMore) {
        _allClients
          ..clear()
          ..addAll(newClients);
      } else {
        _allClients.addAll(newClients);
      }

      // If user is mid-search, re-apply filter on new data
      final query = searchCtl.text.trim().toLowerCase();
      if (query.isEmpty) {
        customerModel.assignAll(_allClients);
      } else {
        customerModel.assignAll(
          _allClients.where(
            (item) =>
                item.first_name.toLowerCase().contains(query) ||
                item.last_name.toLowerCase().contains(query) ||
                item.client_code.toLowerCase().contains(query) ||
                item.name.toLowerCase().contains(query),
          ),
        );
      }

      // Reset visible window on full reload
      if (isRefresh || !isLoadMore) {
        visibleCount.value = _pageSize;
      }
    } catch (e) {
      if (isClosed) return;
      ExceptionHandler.handleException(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchClientSearch({
    bool isRefresh = false,
    bool isLoadMore = false,
    bool isFilter = false,
  }) async {
    if (isFilter) {
      onSearch(searchCtl.text);
    } else {
      await onRefresh();
    }
  }

  Future<void> onRefresh({bool isFilter = false}) async {
    await fetchClient(isRefresh: true, isFilter: isFilter);
    refreshCtl.refreshCompleted();
  }

  Future<void> onLoading() async {
    await fetchClient(isLoadMore: true);
    refreshCtl.loadComplete();
  }

  void setSearchValue() {
    startBillCreateDateCtl.clear();
    endBillCreateDateCtl.clear();
    startBillFinishDateCtl.clear();
    endBillFinishDateCtl.clear();
    selectedStatusValue.value = 0;
  }

  void setFilterValue({num value = 0}) {
    searchCtl.text = '';
  }

  DatePicker getStartBillCreatePicker(
    TextEditingController startDateCtl,
    TextEditingController endDateCtl,
  ) {
    return DatePicker(
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
  }

  DatePicker getEndBillCreatePicker(
    TextEditingController startDateCtl,
    TextEditingController endDateCtl,
  ) {
    return DatePicker(
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
  }
}
