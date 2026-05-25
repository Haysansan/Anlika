import 'package:apploan/views/loans/widgets/loans.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:apploan/core/core.dart';
import 'package:apploan/views/views.dart';
import 'package:apploan/models/models.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart'; // ← add this import

final DashboardController dashCtl = Get.find<DashboardController>();
final RepaymentController repaymentCtl = Get.find<RepaymentController>();

class LoansDashboardView extends GetView<LoansDashboardController> {
  const LoansDashboardView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: LocaleKeys.loans.tr,
        onBack: () => Navigator.pop(context, false),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Obx(
              () => CustomSummaryCard(
                clientCount: repaymentCtl.customerCount.value,
                totalRepaymentUsd: repaymentCtl.sum.value,
                collectedUsd: 0,
                exchangeRate: 4100,
                totalRepaymentFormatted: dashCtl.totalToCollect.value,
                totalRepaymentKhrFormatted: dashCtl.totalToCollectKhr.value,
                onClientsTap: () {
                  DialogManager.showDialog(
                    title: 'Coming Soon',
                    subTitle:
                        'Client list will be available in a future update.',
                  );
                },
              ),
            ),
            20.height,
            LoansWidget(),
          ],
        ),
      ),
      // ── add from here ──
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 15),
          ],
        ),
        child: StyleProvider(
          style: _LoansNavStyle(fontSize: 10.0),
          child: ConvexAppBar(
            key: const ValueKey<String>('loans-nav-3'),
            backgroundColor: AppColor.white,
            color: AppColor.grey,
            activeColor: AppColor.primary,
            height: 66,
            style: TabStyle.reactCircle,
            initialActiveIndex: 0,
            onTap: (index) => controller.changeMenu(index),
            shadowColor: const Color(0xFF9DB2CE),
            items: [
              TabItem(icon: Icons.dashboard, title: LocaleKeys.loans.tr),
              TabItem(
                icon: Image.asset(
                  'assets/images/icon/addclient.png',
                  width: 28,
                  height: 28,
                  color: AppColor.grey,
                ),
                activeIcon: Image.asset(
                  'assets/images/icon/addclient.png',
                  width: 28,
                  height: 28,
                  color: AppColor.primary,
                ),
                title: LocaleKeys.addCustomer.tr,
              ),
              TabItem(
                icon: Icons.list_alt,
                title: LocaleKeys.loanDisbursmentsList.tr,
              ),
            ],
          ),
        ),
      ),
      // ── add to here ──
    );
  }
}

// ── add this class at the bottom of the file ──
class _LoansNavStyle extends StyleHook {
  _LoansNavStyle({required this.fontSize});
  final double fontSize;

  @override
  double? get iconSize => 22;

  @override
  double get activeIconMargin => 8;

  @override
  double get activeIconSize => 24;

  @override
  TextStyle textStyle(Color color, String? fontFamily) {
    return TextStyle(
      color: color,
      fontFamily: fontFamily,
      fontSize: fontSize,
      fontWeight: FontWeight.w700,
      height: 1.0,
    );
  }
}
