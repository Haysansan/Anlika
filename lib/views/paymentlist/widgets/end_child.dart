import 'package:apploan/views/paymentlist/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:apploan/core/core.dart';
import 'package:apploan/models/models.dart';
import 'package:intl/intl.dart';

class EndChildsWidget extends StatelessWidget {
  const EndChildsWidget({
    super.key,
    required this.tracking,
    required this.controller,
  });

  final PaymentModel tracking;
  final PaymentListController controller;
  // String formatCurrency(String amount) {
  //   // ignore: unnecessary_null_comparison
  //   return amount != null
  //       ? NumberFormat.currency(
  //         locale: 'en_US',
  //         symbol: '',
  //       ).format(double.parse(amount)).replaceAll('.00', '')
  //       : 'N/A';
  // }
  String formatCurrency(String amount) {
    final parsed = double.tryParse(amount);
    if (parsed == null) return 'N/A';
    return 'រៀល ${NumberFormat.currency(locale: 'en_US', symbol: '').format(parsed)}'
        .replaceAll('.00', '');
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5), // if you need this
        side: BorderSide(color: Colors.grey.withOpacity(0.2), width: 1),
      ),
      child: Container(
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.only(
            left: 10.0,
            top: 10.0,
            right: 0.0,
            bottom: 10.0,
          ), // Add padding here
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ListTile(
                leading: Icon(Icons.payment),
                title: Text(
                  tracking.client,
                  style: AppTextStyle.normalPrimarySemiBold,
                ),
                subtitle: Text(
                  tracking.client_code,
                  style: TextStyle(color: Colors.black.withOpacity(0.6)),
                ),
              ),
              Text(
                'ទឹកទទួលបាន: ${formatCurrency(tracking.total_repayment)}',
                style: AppTextStyle.smallPrimaryRegular,
              ),
              8.height,
              Text(
                'ទឹកប្រាក់ពិន័យ: ${tracking.amount_penalty.isNotEmpty ? formatCurrency(tracking.amount_penalty.replaceAll(',', '')) : 'គ្មាន'}',
                style: AppTextStyle.smallPrimaryRegular,
              ),
              8.height,
              Text(
                '${LocaleKeys.date.tr}: ${tracking.submitted_on} ( ${tracking.status_pay} )',
                style: AppTextStyle.smallPrimaryRegular,
              ),
              8.height,
              Text(
                'លេខបណ្ណទទួលប្រាក់: ',
                style: AppTextStyle.smallPrimaryRegular,
              ),

              // Row(
              //   mainAxisAlignment: MainAxisAlignment.start,
              //   children: <Widget>[
              //     TextButton(
              //       child: Text(
              //         checkIfNotYetSync()
              //             ? LocaleKeys.delete.tr
              //             : checkIfSync()
              //             ? LocaleKeys.reverse.tr
              //             : LocaleKeys.delete.tr,
              //         style:
              //             checkIfSync() || checkIfNotYetSync()
              //                 ? AppTextStyle.smallRedSemibold
              //                 : AppTextStyle.smallGreySemiBold,
              //       ),
              //       onPressed: () {
              //         if (checkIfNotYetSync()) {
              //           controller.deleteRepay(tracking.id);
              //         } else if (checkIfSync()) {
              //           controller.reverseRepay(tracking.id);
              //         } else {
              //           // text();
              //         }
              //       },
              //     ),
              //     // const SizedBox(width: 8),
              //     // TextButton(
              //     //   child: const Text('Print'),
              //     //   onPressed: () {/* ... */},
              //     // ),
              //     const SizedBox(width: 8),
              //   ],
              // ),
            ],
          ),
        ),
      ),
    );
  }

  bool checkIfSync() => tracking.status_pay == "មិនទាន់អនុម័ត";

  bool checkIfNotYetSync() => tracking.status_pay == "មិនទាន់ផ្ទេរ";
}
