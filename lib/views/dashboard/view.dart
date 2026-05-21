// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:apploan/core/core.dart';
// import 'package:apploan/models/models.dart';
// import 'package:apploan/views/views.dart';

// class DashboardView extends GetView<DashboardController> {
//   const DashboardView({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       drawer: const DrawerWidget(),
//       body: Stack(
//         children: [
//           // ── Background image ──
//           Positioned.fill(
//             child: Image.asset(
//               'assets/images/dashboardbackground.png',
//               fit: BoxFit.cover,
//             ),
//           ),
//           Obx(() {
//             if (controller.isLoading.value) {
//               return const Center(
//                 child: CircularProgressIndicator(color: AppColor.red),
//               );
//             }

//             final DashboardModel? dashboard = controller.dashboardModel.value;
//             if (dashboard == null) {
//               return DashboardWidget();
//             }

//             return Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [UIConstants.spacing.height, DashboardWidget()],
//             );
//           }),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:apploan/core/core.dart';
import 'package:apploan/models/models.dart';
import 'package:apploan/views/views.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      drawer: const DrawerWidget(),
      body: Stack(
        children: [
          // ── Background fills the whole screen ──
          Positioned.fill(
            child: Image.asset(
              'assets/images/dashboardbackground.png',
              fit: BoxFit.cover,
            ),
          ),

          // ── Content ──
          SafeArea(
            // child: SingleChildScrollView(
            child: ConstrainedBox(
              // Ensures content is at least full screen height
              // so background image never shows as white gap
              constraints: BoxConstraints(minHeight: screenHeight),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),

                  // ── Summary card ──
                  Obx(
                    () => DashboardSummaryCard(
                      amountToCollect: controller.totalToCollect.value,
                      amountCollected: controller.totalCollected.value,
                      amountToCollectKhr: controller.totalToCollectKhr.value,
                      amountCollectedKhr: controller.totalCollectedKhr.value,
                      userName: controller.userName.value,
                    ),
                  ),

                  20.height,

                  // ── Grid menu ──
                  DashboardWidget(),
                ],
              ),
            ),
            // ),
          ),
        ],
      ),
    );
  }
}
