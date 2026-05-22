import 'package:apploan/core/core.dart';
import 'package:apploan/core/resources/locales.g.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:apploan/routes.dart';

class LoansWidget extends StatelessWidget {
  LoansWidget({Key? key}) : super(key: key);

  // ─── Button labels ──────────────────────────────────────────────────────────
  final List<String> catName = [
    'Loan List',
    'Client List',
    'Disbursement',
    'Written Off',
    'Arrears',
    'Pay Other',
  ];

  // ─── Circle background colors (one per button) ───────────────────────────
  final List<Color> catColors = [
    Color(0xFFF21A3E),
    Color(0xFFF21A3E),
    Color(0xFFF21A3E),
    Color(0xFFF21A3E),
    Color(0xFFF21A3E),
    Color(0xFFF21A3E),
  ];

  // ─── Icons (match the order of catName) ────────────────────────────────────
  final List<Widget> catIcons = [
    Image.asset('assets/images/icon/loans.png', width: 38, height: 38),
    Image.asset('assets/images/icon/client.png', width: 38, height: 38),
    Image.asset('assets/images/icon/repayment.png', width: 38, height: 38),
    Image.asset('assets/images/icon/writtenoff.png', width: 38, height: 38),
    Image.asset('assets/images/icon/arrear.png', width: 38, height: 38),
    Image.asset('assets/images/icon/paidofother.png', width: 38, height: 38),
  ];

  // ─── Navigation handlers ────────────────────────────────────────────────────
  // TODO: Replace each Get.toNamed() argument with the real route when ready.
  // Add your route constant in lib/routes.dart first, then paste it here.

  void _goLoanList() => Get.toNamed(Routes.loans); // ← already exists
  void _goClientList() => Get.toNamed(Routes.customers); // ← already exists
  void _goDisbursement() =>
      Get.toNamed(Routes.loandisbursments); // ← already exists
  void _goWrittenOff() => Get.toNamed(Routes.writtenoff); // ← already exists
  void _goArrears() => Get.toNamed(Routes.arealoan); // ← already exists
  void _goPayOther() => Get.toNamed(Routes.payforeachother); // ← already exists

  void _handleTap(int index) {
    switch (index) {
      case 0:
        _goLoanList();
        break;
      case 1:
        _goClientList();
        break;
      case 2:
        _goDisbursement();
        break;
      case 3:
        _goWrittenOff();
        break;
      case 4:
        _goArrears();
        break;
      case 5:
        _goPayOther();
        break;
      default:
        DialogManager.showDialog(
          title: LocaleKeys.commingSoon.tr,
          subTitle: LocaleKeys.futureUpdate.tr,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // ── Same margin as the summary card so edges align ────────────────────
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.65),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColor.grey.withOpacity(0.4), width: 0.5),
        boxShadow: [
          BoxShadow(
            color: AppColor.grey.withOpacity(0.3),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 25, left: 1, right: 1),
        child: GridView.builder(
          itemCount: catName.length,
          shrinkWrap: true,
          // Disable grid's own scrolling — the parent scroll view handles it
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 1.2,
          ),
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () => _handleTap(index),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 65,
                    width: 65,
                    decoration: BoxDecoration(
                      color: catColors[index],
                      shape: BoxShape.circle,
                    ),
                    child: Center(child: catIcons[index]),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    catName[index],
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
