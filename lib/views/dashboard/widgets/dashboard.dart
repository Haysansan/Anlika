import 'package:apploan/core/core.dart';
import 'package:apploan/core/resources/locales.g.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:apploan/routes.dart';

class DashboardWidget extends StatelessWidget {
  @override
  List catName = [
    // LocaleKeys.loanCalculator.tr,
    // LocaleKeys.loanDisbursments.tr,
    // LocaleKeys.repaymentLoan.tr,
    // LocaleKeys.areaLoan.tr,
    // LocaleKeys.customers.tr,
    // LocaleKeys.writtenoff.tr,
    // LocaleKeys.prepaid.tr,
    // LocaleKeys.payforearchother.tr,
    LocaleKeys.loans.tr,
    LocaleKeys.quickRepay.tr,
    LocaleKeys.reports.tr,
    LocaleKeys.datatransfer.tr,
    LocaleKeys.datasync.tr,
    LocaleKeys.leaves.tr,
  ];
  List<Color> catColors = [
    Color(0xFFF21A3E),
    Color(0xFFF21A3E),
    Color(0xFFF21A3E),
    Color(0xFFF21A3E),
    Color(0xFFF21A3E),
    Color(0xFFF21A3E),
  ];
  List imageList = [
    {"id": 1, "image_path": "assets/images/banner1.png"},
    {"id": 2, "image_path": "assets/images/banner2.png"},
    {"id": 3, "image_path": "assets/images/banner_store.png"},
  ];
  final CarouselController carouselController = CarouselController();
  int currentIndex = 0;

  final List<Widget> catIcons = [
    // Image.asset('assets/images/icon/calculator.png', width: 30, height: 30),
    // Image.asset('assets/images/icon/disburme.png', width: 30, height: 30),
    // Image.asset('assets/images/icon/repayment.png', width: 30, height: 30),
    // Image.asset('assets/images/icon/arrear.png', width: 30, height: 30),
    // Image.asset('assets/images/icon/customer.png', width: 30, height: 30),
    // Image.asset('assets/images/icon/writtenoff.png', width: 30, height: 30),
    // Image.asset('assets/images/icon/prepaid.png', width: 30, height: 30),
    // Image.asset('assets/images/icon/paidofother.png', width: 30, height: 30),
    Image.asset('assets/images/icon/loans.png', width: 38, height: 38),
    Image.asset('assets/images/icon/quickrepay.png', width: 33, height: 33),
    Image.asset('assets/images/icon/reports.png', width: 38, height: 38),
    Image.asset('assets/images/icon/transfer.png', width: 38, height: 38),
    Image.asset('assets/images/icon/sync.png', width: 38, height: 38),
    Image.asset('assets/images/icon/writtenoff.png', width: 48, height: 48),
  ];
  List getReport = ["អតិថិជនបានបង់", "អតិថិជនមិនបានបង់", "អតិថិជនត្រូវប្រមូល"];

  List<Color> getColorsRep = [
    Color(0xFF61BDFD),
    Color(0xFFFC7F7F),
    Color(0xFFCBB4FB),
    // Color(0xFF78E667),
  ];
  List<Icon> getIconsRep = [
    Icon(Icons.paid, color: Colors.white, size: 30),
    Icon(Icons.download_done, color: Colors.white, size: 30),
    Icon(Icons.summarize, color: Colors.white, size: 30),
    // Icon(Icons.approval,color: Colors.white,size: 30),
  ];

  // void RepaymentHandleTap() {
  //   Get.back();
  //   Get.toNamed(Routes.repayment);
  // }

  void SyncDataHandleTap() {
    Get.back();
    Get.toNamed(Routes.syncData);
  }

  void TransferDataHandleTap() {
    Get.back();
    Get.toNamed(Routes.transferData);
  }

  // void LoanCalculatorHandleTap() {
  //   Get.back();
  //   Get.toNamed(Routes.loancalculator);
  // }

  // void LoanDisbursmentsHandleTap() {
  //   Get.back();
  //   Get.toNamed(Routes.loandisbursments);
  // }

  // void AreaLoanHandleTap() {
  //   Get.back();
  //   Get.toNamed(Routes.arealoan);
  // }

  // void WrittenOffHandleTap() {
  //   Get.back();
  //   Get.toNamed(Routes.writtenoff);
  // }

  // void PrePaidHandleTap() {
  //   Get.back();
  //   Get.toNamed(Routes.prepaid);
  // }

  // void PayForEeachOtherHandleTap() {
  //   Get.back();
  //   Get.toNamed(Routes.payforeachother);
  // }

  // void CustomersHandleTap() {
  //   Get.back();
  //   Get.toNamed(Routes.customers);
  // }

  // void moneyCount() {
  //   Get.back();
  //   Get.toNamed(Routes.dino);
  // }

  void LoansHandleTap() {
    Get.back();
    Get.toNamed(Routes.loans);
  }

  void QuickRepayHandleTap() {
    Get.back();
    Get.toNamed(Routes.quickRepay);
  }

  void ReportsHandleTap() {
    Get.back();
    Get.toNamed(Routes.reports);
  }

  void LeavesHandleTap() {
    Get.back();
    Get.toNamed(Routes.leaves);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
      ), // ← same as summary card
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.65),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.6), width: 1.5),
      ),
      child: Stack(
        children: [
          Positioned(
            child: Container(
              child: Padding(
                padding: EdgeInsets.only(top: 25, left: 1, right: 1),
                child: Column(
                  children: [
                    GridView.builder(
                      itemCount: catName.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: 1.2,
                      ),
                      itemBuilder: (context, index) {
                        return new InkWell(
                          onTap: () {
                            // if (catName[index] ==
                            //     LocaleKeys.loanCalculator.tr) {
                            //   LoanCalculatorHandleTap();
                            // }
                            // if (catName[index] ==
                            //     LocaleKeys.loanDisbursments.tr) {
                            //   LoanDisbursmentsHandleTap();
                            // }// if (catName[index] == LocaleKeys.areaLoan.tr) {
                            //   AreaLoanHandleTap();
                            // }
                            // if (catName[index] == LocaleKeys.customers.tr) {
                            //   CustomersHandleTap();
                            // }
                            // if (catName[index] == LocaleKeys.writtenoff.tr) {
                            //   WrittenOffHandleTap();
                            // } else
                            // if (catName[index] ==
                            //     LocaleKeys.payforearchother.tr) {
                            //   PayForEeachOtherHandleTap();
                            // } else if (catName[index] ==
                            //     LocaleKeys.repaymentLoan.tr) {
                            //   RepaymentHandleTap();
                            // }
                            if (catName[index] == LocaleKeys.datasync.tr) {
                              SyncDataHandleTap();
                            } else if (catName[index] ==
                                LocaleKeys.datatransfer.tr) {
                              TransferDataHandleTap();
                            }
                            // else if (catName[index] ==
                            //     LocaleKeys.prepaid.tr) {
                            //   PrePaidHandleTap();
                            //   // } else if (catName[index] == 'DENO') {
                            //   //   moneyCount();
                            // } else if (catName[index] ==
                            //     LocaleKeys.writtenoff.tr) {
                            //   WrittenOffHandleTap();
                            // }
                            else if (catName[index] == LocaleKeys.loans.tr) {
                              LoansHandleTap();
                            }
                            // else if (catName[index] ==
                            //     LocaleKeys.quickRepay.tr) {
                            //   QuickRepayHandleTap();
                            // } else if (catName[index] ==
                            //     LocaleKeys.reports.tr) {
                            //   ReportsHandleTap();
                            // } else if (catName[index] ==
                            //     LocaleKeys.leaves.tr) {
                            //   LeavesHandleTap();
                            // }
                            else {
                              DialogManager.showDialog(
                                title: LocaleKeys.commingSoon.tr,
                                subTitle: LocaleKeys.futureUpdate.tr,
                              );
                            }
                          },
                          child: Ink(
                            child: Column(
                              children: [
                                Container(
                                  height: 65,
                                  width: 65,
                                  decoration: BoxDecoration(
                                    color:
                                        [0, 3, 4].contains(index)
                                            ? catColors[index]
                                            : Color(0xFFA88787),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(child: catIcons[index]),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  catName[index],
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     Text("",
                    //       style: TextStyle(
                    //         fontSize: 10,
                    //         fontWeight: FontWeight.bold,
                    //       ),
                    //     ),
                    //     TextButton(
                    //       onPressed: () {},
                    //       style: ButtonStyle(),
                    //       child: Row(
                    //         mainAxisSize: MainAxisSize.min,
                    //         children: [
                    //           Text(LocaleKeys.more.tr,
                    //               style: TextStyle(
                    //                 fontSize: 14,
                    //                 fontWeight: FontWeight.bold,
                    //                 color: Color(0xFF650386),
                    //               )
                    //           ),
                    //           SizedBox(width: 8), // Optional spacing between text and icon
                    //           Icon(Icons.arrow_forward_ios_rounded,color: Color(0xFF650386),size: 14,),
                    //         ],
                    //       ),
                    //     )
                    //   ],
                    // ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
