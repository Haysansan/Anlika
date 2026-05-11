import 'package:apploan/core/offline/database_helper.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:apploan/core/core.dart';
import 'package:apploan/models/models.dart';
import 'package:apploan/routes.dart';
import 'package:apploan/views/views.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:apploan/views/repayment/repayment.dart';

class PaidOffSheet extends StatelessWidget {
  PaidOffSheet({Key? key, required this.delivery}) : super(key: key);

  final PaidOffModel delivery;
  final PaidOffController deliveryCtl = Get.find<PaidOffController>();

  final TextEditingController totalRepaymentCtl = TextEditingController();
  final TextEditingController totalPenaltyCtl = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final RxList<PaidOffModel> repaymentModel = <PaidOffModel>[].obs;
  final RxBool isPassVisible = true.obs;
  final RxBool isLogVaiEmail = false.obs;
  bool isButtonEnabled = false;
  final PaidOffController startCtl = Get.find<PaidOffController>();
  // show user_id from login
  Future<int?> getUserId() async {
    int? user_id = await SharedPreferencesManager.getIntValue('user_id');
    return user_id;
  }

  Future<void> submitBooking() async {
    if (totalRepaymentCtl.text == "") {
      DialogManager.showDialog(title: "Waring", subTitle: "សូមបញ្ចូលទឹកប្រាក់");
      return;
    }

    if (totalRepaymentCtl.text.contains('.')) {
      DialogManager.showDialog(
        title: "Waring",
        subTitle: "Please enter a valid amount",
        onPressed: () => Get.back(),
      );
      return;
    }
    try {
      int? user_id = await getUserId();
      try {
        await DatabaseHelper.instance.insertCollected({
          'id': delivery.id,
          'client': delivery.client,
          'loan_officer': user_id,
          'created_by_id': user_id,
          'branch': delivery.branch,
          'client_id': delivery.client_id,
          'loan_id': delivery.loan_id,
          'client_code': delivery.client_code,
          'photo': delivery.photo,
          'total_repayment': double.parse(
            totalRepaymentCtl.text.replaceAll(",", ""),
          ),
          'amount_penalty': totalPenaltyCtl.text,
          'currency_id': 2,
          'description': "Post Repayment",
          'gateway_id': 1,
          "status_pay": "មិនទាន់អនុម័ត",
          'submitted_on': DateFormat('yyyy-MM-dd').format(DateTime.now()),
          'syncedate': DateFormat('yyyy-MM-dd').format(DateTime.now()),
          'synced': "1",
        });
      } catch (e) {
        print("Sync failed: $e");
        DialogManager.showDialog(
          title: LocaleKeys.error.tr,
          subTitle:
              "អតិថិជនមិនផ្ដាច់បានទេ សូមធ្វើការផ្ទេរទិន្នន័យទៅប្រព័ន្ធជាមុនសិន",
        );
        return;
      }

      dio.FormData formData = dio.FormData.fromMap({
        // This static because of feature removed
        'id': delivery.id,
        'client': delivery.client,
        'loan_officer': user_id,
        'created_by_id': user_id,
        'branch': delivery.branch,
        'client_id': delivery.client_id,
        'loan_id': delivery.loan_id,
        'client_code': delivery.client_code,
        'photo': delivery.photo,
        'amount': double.parse(totalRepaymentCtl.text.replaceAll(",", "")),
        'amount_penalty': totalPenaltyCtl.text,
        'currency_id': 2,
        'description': "Post Repayment",
        'gateway_id': 1,
      });
      await Get.find<ApiService>().post(
        EndPoints.repaymentStore,
        formData,
        isShowLoading: true,
      );

      startCtl.fetchRepaymentSearch();
      DialogManager.showDialog(
        title: LocaleKeys.successfully.tr,
        subTitle: LocaleKeys.youHaveSuccessfullyCreated.tr,
        onPressed: () => Get.back(result: true),
      );
    } catch (e) {
      ExceptionHandler.handleException(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            30.height,
            // _buildInfoRowPopUpBoldInput(
            //   "ទឹកប្រាក់ពិន័យ",
            //   totalPenaltyCtl,
            // ),
            _buildInfoRowPopUpBoldInput(
              LocaleKeys.amttoclose.tr,
              totalRepaymentCtl,
            ),
            // 8.height,
            // Row(
            //   crossAxisAlignment: CrossAxisAlignment.center,
            //   children: [
            //     // Logo
            //     CircleAvatar(
            //       radius: 30,
            //       backgroundColor: AppColor.transparent,
            //       child: CustomNetworkImage(imageUrl: delivery.photo),
            //     ),
            //     12.width,
            //     Column(
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       children: [
            //         8.height,
            //
            //         // Delivery name
            //         Text(
            //           '${delivery.client_code} . ${delivery.client}',
            //           style: AppTextStyle.normalPrimarySemiBold,
            //         ),
            //         8.height,
            //
            //         // Delivery status
            //         Text(
            //           '${ formatCurrency(delivery.total_repayment) } ',
            //           style: AppTextStyle.normalRedSemiBold,
            //         ),
            //       ],
            //     ),
            //   ],
            // ),
            15.height,
            const DarkGreyDivider(),
            15.height,
            // Type of service
            // _item(
            //   title: 'វដ្ដទី៖ ${delivery.cycle} | ចំនួនយឺត ${delivery.arrea} ថ្ងៃ',
            //   value: '',
            // ),
            // 10.height,

            // Location
            _item(
              title: LocaleKeys.amttoclose.tr,
              value: formatCurrency(delivery.total_repayment),
            ),
            10.height,
            const DarkGreyDivider(),
            10.height,
            // Total amount
            _item(
              title: LocaleKeys.principals.tr,
              value: '${formatCurrency(delivery.principal)}',
            ),
            10.height,
            // Date
            _item(
              title: LocaleKeys.interast.tr,
              value: '${formatCurrency(delivery.interest)}',
            ),
            10.height,
            // Destination phone number
            _item(
              title: LocaleKeys.fee.tr,
              value: formatCurrency(delivery.monthly_fee),
            ),

            10.height,
            _item(
              title: LocaleKeys.penalty.tr,
              value: formatCurrency(delivery.penalty),
            ),
            10.height,
            // Change
            PrimaryButton(
              text: LocaleKeys.confirmation.tr,
              onPressed: submitBooking,
            ),
            70.height,
          ],
        ),
      ),
    );
  }

  // String formatCurrency(String amount) {
  //   // ignore: unnecessary_null_comparison
  //   return amount != null
  //       ? 'រៀល ${NumberFormat.currency(locale: 'en_US', symbol: '').format(double.parse(amount))}'.replaceAll('.00', '')
  //       : 'N/A';
  // }
  String formatCurrency(String amount) {
    final parsed = double.tryParse(amount);
    if (parsed == null) return 'N/A';
    return 'រៀល ${NumberFormat.currency(locale: 'en_US', symbol: '').format(parsed)}'
        .replaceAll('.00', '');
  }

  Widget _item({
    required String title,
    String value = '',
    bool isTotal = false,
    String phoneNumber = '',
    bool requiredTelegram = false,
  }) {
    return Row(
      children: [
        Text(
          title,
          style:
              isTotal
                  ? AppTextStyle.normalPrimarySemiBold
                  : AppTextStyle.normalPrimaryRegular,
        ),
        const Spacer(),
        if (phoneNumber.isNotEmpty)
          Padding(
            padding: UIConstants.spacing.padHorizontal,
            child: Row(
              children: [
                if (requiredTelegram)
                  Row(
                    children: [
                      CircleIcon(
                        icon: Icons.telegram,
                        onTap:
                            () => UrlLauncherManager.telegram(
                              UserRepository.shared.telegram,
                            ),
                      ),
                      12.width,
                    ],
                  ),
                CircleIcon(
                  icon: Icons.call,
                  onTap: () => UrlLauncherManager.call(phoneNumber),
                ),
                2.width,
              ],
            ),
          ),
        Text(
          value,
          style:
              isTotal
                  ? AppTextStyle.normalRedBold
                  : AppTextStyle.normalPrimaryRegular,
        ),
      ],
    );
  }
}

Widget _buildInfoRowPopUpBoldInput(
  String label,
  TextEditingController controller,
) {
  final totalPaid = controller;
  final NumberFormat numberFormat = NumberFormat('#,###');

  // Adding a listener to the controller to format the input
  totalPaid.addListener(() {
    String text = totalPaid.text.replaceAll(',', ''); // Remove existing commas
    if (text.isNotEmpty) {
      String formattedText = numberFormat.format(int.parse(text));
      totalPaid.value = totalPaid.value.copyWith(
        text: formattedText,
        selection: TextSelection.collapsed(offset: formattedText.length),
      );
    }
  });

  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 2.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 2.0),
          child: Text(
            "$label:",
            style: const TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 10, 10, 10),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 2.0),
            child: TextFormField(
              keyboardType: TextInputType.number,
              controller: totalPaid,
              style: const TextStyle(fontSize: 18.0, color: Colors.black),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 4.0),
                filled: true,
                fillColor: const Color.fromARGB(255, 223, 222, 222),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                disabledBorder: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                prefixIcon: SizedBox(
                  width: 20.0,
                  height: 20.0,
                  child: Image.asset('assets/images/moneyx.png'),
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

// Widget _buildInfoRowPopUpBoldInput(String label, TextEditingController controller) {
//   final totalPaid = controller;
//
//   return Padding(
//     padding: const EdgeInsets.symmetric(vertical: 2.0),
//     child: Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: <Widget>[
//         Padding(
//           padding: const EdgeInsets.only(left: 2.0),
//           child: Text(
//             "$label:",
//             style: const TextStyle(
//               fontSize: 18.0,
//               fontWeight: FontWeight.bold,
//               color: Color.fromARGB(255, 10, 10, 10),
//             ),
//           ),
//         ),
//         Expanded(
//           child: Padding(
//             padding: const EdgeInsets.only(right: 2.0),
//             child: TextFormField(
//               keyboardType: const TextInputType.numberWithOptions(decimal: true), // Use TextInputType.text for general text input
//               controller: totalPaid,
//
//               style: const TextStyle(fontSize: 18.0, color: Colors.black),
//               decoration: InputDecoration(
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(10.0),
//                 ),
//                 contentPadding: const EdgeInsets.symmetric(vertical: 4.0),
//                 filled: true,
//                 fillColor: const Color.fromARGB(255, 223, 222, 222),
//                 focusedBorder: OutlineInputBorder(
//                   borderSide: BorderSide.none,
//                   borderRadius: BorderRadius.circular(10.0),
//                 ),
//                 enabledBorder: OutlineInputBorder(
//                   borderSide: BorderSide.none,
//                   borderRadius: BorderRadius.circular(10.0),
//                 ),
//                 errorBorder: OutlineInputBorder(
//                   borderSide: BorderSide.none,
//                   borderRadius: BorderRadius.circular(10.0),
//                 ),
//                 disabledBorder: OutlineInputBorder(
//                   borderSide: BorderSide.none,
//                   borderRadius: BorderRadius.circular(10.0),
//                 ),
//                 prefixIcon: SizedBox(
//                   width: 20.0, // Set the desired width
//                   height: 20.0, // Set the desired height
//                   child: Image.asset('assets/images/moneyx.png'),
//
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ],
//     ),
//   );
// }
