// import 'package:apploan/core/core.dart';
// import 'package:apploan/views/views.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:convex_bottom_bar/convex_bottom_bar.dart';

// class StartView extends GetView<StartController> {
//   const StartView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return PopScope(
//       canPop: controller.selectedIndex.value == 0 ? true : false,
//       onPopInvoked: (didPop) {
//         controller.handleClickBack();
//       },
//       child: Scaffold(
//         extendBodyBehindAppBar: true, // background layer
//         backgroundColor: Colors.transparent,
//         appBar: appBarWidget(),
//         drawer: const DrawerWidget(),
//         body: Center(child: Obx(() => controller.selectedScreen.value)),
//         floatingActionButtonLocation:
//             FloatingActionButtonLocation.miniCenterDocked,
//         bottomNavigationBar: Container(
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(20),
//             boxShadow: [
//               BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 15),
//             ],
//           ),
//           child: StyleProvider(
//             style: _BottomNavStyle(fontSize: navFontSize),
//             child: ConvexAppBar(
//               key: const ValueKey<String>('nav-4'),
//               backgroundColor: AppColor.white,
//               color: const Color(0xFF7279D3),
//               activeColor: const Color(0xFFF2F3691),
//               height: 66,
//               style: TabStyle.reactCircle,
//               initialActiveIndex: selectedIndex,
//               onTap: controller.changeMenuIndex,
//               shadowColor: const Color(0xFFA4A6C2),
//               items: [
//                 TabItem(icon: Icons.dashboard, title: LocaleKeys.dashboard.tr),
//                 TabItem(
//                   icon: Icons.notifications,
//                   title: LocaleKeys.notification.tr,
//                 ),
//                 if (!isParent)
//                   TabItem(
//                     icon: Icons.qr_code_scanner_sharp,
//                     title: LocaleKeys.scanner.tr,
//                   ),
//                 if (isParent)
//                   TabItem(
//                     icon: Icons.mobile_friendly,
//                     title: LocaleKeys.payments.tr,
//                   ),
//                 TabItem(
//                   icon: Icons.contact_phone,
//                   title: LocaleKeys.contact.tr,
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class _BottomNavStyle extends StyleHook {
//   _BottomNavStyle({required this.fontSize});

//   final double fontSize;

//   @override
//   double? get iconSize => 22;

//   @override
//   double get activeIconMargin => 8;

//   @override
//   double get activeIconSize => 24;

//   @override
//   TextStyle textStyle(Color color, String? fontFamily) {
//     return TextStyle(
//       color: color,
//       fontFamily: fontFamily,
//       fontSize: fontSize,
//       fontWeight: FontWeight.w700,
//       height: 1.0,
//     );
//   }
// }

import 'package:apploan/core/core.dart';
import 'package:apploan/views/views.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';

class StartView extends GetView<StartController> {
  const StartView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final int selectedIndex = controller.selectedIndex.value;

      return PopScope(
        canPop: selectedIndex == 0,
        onPopInvoked: (didPop) {
          controller.handleClickBack();
        },
        child: Scaffold(
          extendBodyBehindAppBar: true, // background layer
          backgroundColor: Colors.transparent,
          appBar: appBarWidget(),
          drawer: const DrawerWidget(),
          body: Center(child: Obx(() => controller.selectedScreen.value)),
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 15),
              ],
            ),
            child: StyleProvider(
              style: _BottomNavStyle(fontSize: 10.0),
              child: ConvexAppBar(
                key: const ValueKey<String>('nav-4'),
                backgroundColor: AppColor.white,
                color: AppColor.blueGrey,
                activeColor: AppColor.primary,
                height: 66,
                style: TabStyle.reactCircle,
                initialActiveIndex: selectedIndex,
                onTap: (index) => controller.changeMenu(index),
                shadowColor: const Color(0xFF9DB2CE),
                items: [
                  TabItem(
                    icon: Icons.dashboard,
                    title: LocaleKeys.dashboard.tr,
                  ),
                  TabItem(
                    icon: Icons.payment,
                    title: LocaleKeys.paymentslist.tr,
                  ),
                  TabItem(
                    icon: Icons.list_alt,
                    title: LocaleKeys.loanDisbursmentsList.tr,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}

class _BottomNavStyle extends StyleHook {
  _BottomNavStyle({required this.fontSize});

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
