import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:apploan/core/core.dart';
import 'package:apploan/models/models.dart';
import 'package:apploan/views/views.dart';

class WrittenoffWidget extends StatelessWidget {
  const WrittenoffWidget({Key? key, required this.WOLoan}) : super(key: key);

  final WrittenOffModel WOLoan;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap:
          () => BottomSheetManager.custom(
            content: WrittenoffSheet(WOLoan: WOLoan),
          ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: UIConstants.radius.radiusAll,
              border: Border.all(width: 1, color: const Color(0xFF171617)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(
                    radius: 30,
                    backgroundColor: AppColor.white,
                    child: Image.asset(
                      AssetPath.appsuccess.path,
                      height: 50,
                      width: 50,
                      fit: BoxFit.contain,
                    ),
                  ),
                  title: Text(
                    '${WOLoan.client} (វដ្គទី ${WOLoan.cycle})',
                    style: AppTextStyle.normalPrimarySemiBold.copyWith(
                      color: const Color(0xFF171617),
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(WOLoan.mobile, style: AppTextStyle.smallGreyRegular),
                      SizedBox(
                        width: Get.width * 0.4,
                        child: Text(
                          WOLoan.villages_name,
                          style: AppTextStyle.smallGreyRegular,
                        ),
                      ),
                      Text(
                        WOLoan.last_payment_date,
                        style: AppTextStyle.smallGreyRegular,
                      ),
                      Text(
                        'ប្រាក់កម្ចី៖ ${formatCurrency(WOLoan.principal.toString())}',
                        style: AppTextStyle.smallPrimaryRegular,
                      ),
                    ],
                  ),
                  isThreeLine: true,
                ),
                const DarkGreyDivider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        'ប្រាក់ត្រូវបង់ផ្ដាច់៖ ${formatCurrency(WOLoan.total_repayment.toString())}',
                        style: AppTextStyle.smallPrimaryRegular,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String formatCurrency(String amount) {
    final parsed = double.tryParse(amount);
    if (parsed == null) return 'N/A';
    return 'រៀល ${NumberFormat.currency(locale: 'en_US', symbol: '').format(parsed)}'
        .replaceAll('.00', '');
  }
}
