import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:apploan/core/core.dart';
import 'package:apploan/models/models.dart';

class RepaymentItemWidget extends StatelessWidget {
  const RepaymentItemWidget({Key? key, required this.delivery})
    : super(key: key);

  final RepaymentModel delivery;

  @override
  Widget build(BuildContext context) {
    return LoanClientCard(
      clientName: delivery.client,
      cycle: delivery.cycle,
      mobile: delivery.mobile,
      overdueDays: delivery.arrea,
      villageName: delivery.villages_name,
      lastPaymentDate: delivery.last_payment_date,
      disbursementAmount: delivery.disburmentAmt,
      bottomLabel: 'ប្រាក់ត្រូវបង់',
      bottomAmount: delivery.total_amount,
      onTap:
          () => BottomSheetManager.custom(
            content: DeliverySheet(delivery: delivery),
          ),
    );
  }

  // String formatCurrency(String amount) {
  //   // ignore: unnecessary_null_comparison
  //   return amount != null
  //       ? '${NumberFormat.currency(locale: 'en_US', symbol: '').format(double.parse(amount))} រៀល'
  //           .replaceAll('.00', '')
  //       : 'N/A';
  // }
  String formatCurrency(String amount) {
    final parsed = double.tryParse(amount);
    if (parsed == null) return 'N/A';
    return 'រៀល ${NumberFormat.currency(locale: 'en_US', symbol: '').format(parsed)}'
        .replaceAll('.00', '');
  }

  Color _customColor(String status) {
    switch (status) {
      case 'កំពុងដឹក':
        return AppColor.blue;
      case 'កំពុងរង់ចាំ':
        return AppColor.blue;
      case 'ជោគជ័យ':
        return AppColor.green;
      case 'មានបញ្ហា':
        return const Color(0xFFF5C815);
      case 'ត្រឡប់':
        return const Color(0xFF4C56AF);
      default:
        return const Color(0xFFDE0CDE);
    }
  }

  String _AssetPath(String status) {
    switch (status) {
      case 'កំពុងដឹក':
        return AssetPath.appprocessing.path;
      case 'ជោគជ័យ':
        return AssetPath.appsuccess.path;
      case 'កំពុងរង់ចាំ':
        return AssetPath.appprocessing.path;
      case 'មានបញ្ហា':
        return AssetPath.apprejects.path;
      case 'ត្រឡប់':
        return AssetPath.apprejects.path;
      default:
        return AssetPath.apprejects.path;
    }
  }
}
