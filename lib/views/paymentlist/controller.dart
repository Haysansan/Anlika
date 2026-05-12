import 'dart:convert';

import 'package:apploan/core/offline/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:apploan/core/core.dart';
import 'package:apploan/models/models.dart';
import 'package:apploan/views/views.dart';
import 'package:dio/dio.dart' as dio;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PaymentListController extends GetxController {
  final TextEditingController searchCtl = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final RxList<PaymentModel> repayment = <PaymentModel>[].obs;
  final RxBool isLoading = false.obs;
  final TextEditingController totalClient = TextEditingController();
  final TextEditingController totalAmount = TextEditingController();

  bool isDone = false;
  final StartController startCtl = Get.find<StartController>();

  @override
  void onInit() {
    fetchpaymentList();
    super.onInit();
  }

  // String formatCurrency(String amount) {
  //   // ignore: unnecessary_null_comparison
  //   return amount != null
  //       ? '${NumberFormat.currency(locale: 'en_US', symbol: '').format(double.parse(amount))}'
  //           .replaceAll('.00', ' រៀល')
  //       : 'N/A';
  // }
  String formatCurrency(String amount) {
    final parsed = double.tryParse(amount);
    if (parsed == null) return 'N/A';
    return 'រៀល ${NumberFormat.currency(locale: 'en_US', symbol: '').format(parsed)}'
        .replaceAll('.00', '');
  }

  @override
  void onClose() {
    searchCtl.dispose();
    fetchpaymentList();
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

  // Future<void> fetchpayment() async {
  //   try {
  //     int? branchId = await getbranchId();
  //     int? user_id = await getUserId();
  //     isLoading.value = true;
  //     final Map<String, dynamic> param = {'branch_id': branchId,'user_id':user_id};
  //     final res = await Get.find<ApiService>().get(
  //       EndPoints.payment,
  //       queryParameters: param,
  //       isShowLoading: true,
  //     );
  //     final data = getPropertyFromJson(res.data, 'data');
  //     repayment.value = List.from(
  //       (data as List).map((e) => PaymentModel.fromJson(e)).toList(),
  //     );
  //     totalClient.text  = getPropertyFromJson(res.data, 'totalClient');
  //     totalAmount.text  = formatCurrency(getPropertyFromJson(res.data, 'totalAmount'));
  //     isDone = true;
  //     DialogManager.hideLoading();
  //   } catch (e) {
  //     ExceptionHandler.handleException(e);
  //   }
  //   finally {
  //     isLoading.value = false;
  //   }
  // }

  int customerCount = 0;
  Future<void> _countCustomers() async {
    int count = await DatabaseHelper.instance.countCustomersCollection();
    customerCount = count;
    totalClient.text = customerCount.toString();
  }

  double sum = 0;
  Future<void> _calculateSum() async {
    // Fetch all rows for a specific condition, here assuming `1` is a parameter.
    List<PaymentModel> rows =
        await DatabaseHelper.instance.queryAllRowsCollected();
    // Use fold to accumulate the sum of all total_repayment values
    sum = rows.fold(
      0.0,
      (prev, element) => prev + double.parse(element.total_repayment),
    );
    totalAmount.text = formatCurrency(sum.toString());
  }

  Future<void> fetchpaymentList() async {
    try {
      isLoading.value = true;
      _countCustomers();
      _calculateSum();
      repayment.value = await DatabaseHelper.instance.queryAllRowsCollected();

      isDone = true;
      DialogManager.hideLoading();
    } catch (e) {
      ExceptionHandler.handleException(e);
    } finally {
      isLoading.value = false;
    }
  }

  void deleteRepay(int id) async {
    DatabaseHelper.instance.DeleteCollectedByID(id);
    await fetchpaymentList();
    DialogManager.showDialog(
      title: LocaleKeys.deletedsuccess.tr,
      subTitle: LocaleKeys.yousuccessfuldeletedata.tr,
      onPressed: () async {
        Get.back();
      },
    );
  }

  void reverseRepay(int id) async {
    //delete from sever

    try {
      final Map<String, dynamic> params = {'id': id};
      var response = await Get.find<ApiService>().get(
        EndPoints.reverse,
        queryParameters: params,
        isShowLoading: true,
      );
      if (response.data['message'] == 'Successfully Saved') {
        // delete from local
        await DatabaseHelper.instance.DeleteCollectedByID(id);
        await fetchpaymentList();
        DialogManager.showDialog(
          title: LocaleKeys.reversedsuccess.tr,
          subTitle: LocaleKeys.yousucessfulreversedata.tr,
          onPressed: () async {
            Get.back();
          },
        );
      } else {
        await fetchpaymentList();
        DialogManager.showDialog(
          title: LocaleKeys.failed.tr,
          subTitle: LocaleKeys.youfailedtoreversedata.tr,
          onPressed: () async {
            Get.back();
          },
        );
      }
    } catch (e) {
      await fetchpaymentList();
      DialogManager.showDialog(
        title: LocaleKeys.reversedsuccess.tr,
        subTitle: LocaleKeys.yousucessfulreversedata.tr,
        onPressed: () async {
          Get.back();
        },
      );
    }
  }
}
