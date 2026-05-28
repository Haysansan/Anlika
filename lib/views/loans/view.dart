import 'package:apploan/routes.dart';
import 'package:apploan/views/loans/widgets/loans.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:apploan/core/core.dart';
import 'package:apploan/views/views.dart';
import 'package:apploan/models/models.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';

final DashboardController loanDashCtl = Get.find<DashboardController>();
final RepaymentController loanRepaymentCtl = Get.find<RepaymentController>();

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
                clientCount: loanRepaymentCtl.customerCount.value,
                totalRepaymentUsd:
                    controller.collectedSum.value +
                    controller.totalRepaymentSum.value,
                collectedUsd: controller.collectedSum.value,
                exchangeRate: 4100,
                totalRepaymentFormatted: controller.totalToCollectUsd,
                totalRepaymentKhrFormatted: controller.totalToCollectKhr,
                onClientsTap: () => Get.toNamed(Routes.customers),
              ),
            ),
            20.height,
            LoansWidget(),
          ],
        ),
      ),
      // ── add from here ──
      bottomNavigationBar: AppBottomNav(
        navKey: const ValueKey('loans-nav'),
        initialActiveIndex: 1,
        activeColor: AppColor.blueGrey,
        // TODO: swap based on role when ready
        // items: UserRepository.shared.isAdmin
        //     ? loanNavItemsAdmin()
        //     : loanNavItemsCO(),
        items: mainNavItems(),
        onTap: (index) {
          Get.offAllNamed(Routes.start);
          Future.delayed(const Duration(milliseconds: 100), () {
            Get.find<StartController>().changeMenu(index);
          });
        },
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
