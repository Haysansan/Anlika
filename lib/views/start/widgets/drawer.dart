// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:apploan/core/core.dart';
// import 'package:apploan/flavor/app_config.dart';
// import 'package:apploan/routes.dart';

// class DrawerWidget extends StatelessWidget {
//   const DrawerWidget({Key? key}) : super(key: key);

//   void languageHandleTap() {
//     Get.back();
//     Get.toNamed(Routes.language);
//   }

//   void termConditionHandleTap() {
//     Get.back();
//     Get.toNamed(Routes.termCondition);
//   }

//   void contactUsHandleTap() {
//     Get.back();
//     Get.toNamed(Routes.contactUs);
//   }

//   void logOutHandleTap() {
//     Get.back();
//     DialogManager.showCustom(
//       PrimaryDialog(
//         title: LocaleKeys.logout.tr,
//         subTitle: LocaleKeys.areYouSureYourWantToLogout.tr,
//         btnText: LocaleKeys.yes.tr.toUpperCase(),
//         onPressed: () async {
//           Get.back();
//           await UserRepository.shared.logout();
//         },
//       ),
//     );
//   }

//   void _showDeleteDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       barrierDismissible: false, // user must tap a button
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text(LocaleKeys.deleteAccount.tr),
//           content: Text(LocaleKeys.confirm1.tr),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(12),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop(); // close dialog
//               },
//               child: Text(LocaleKeys.cancel.tr),
//             ),
//             ElevatedButton(
//               style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
//               onPressed: () {
//                 Navigator.of(context).pop(); // close dialog first
//                 _showFinalConfirmation(context);
//               },
//               child: Text(LocaleKeys.delete.tr),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   void _showFinalConfirmation(BuildContext context) {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text(LocaleKeys.confirmation.tr),
//           content: Text(LocaleKeys.confirm2.tr),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(12),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.of(context).pop(),
//               child: Text(LocaleKeys.no.tr),
//             ),
//             ElevatedButton(
//               style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
//               onPressed: () async {
//                 Navigator.of(context).pop(); // close dialog
//                 //  _deleteAccount(context);

//                 logOutHandleTap();
//               },
//               child: Text(LocaleKeys.yes.tr),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Drawer(
//       backgroundColor: AppColor.primary,
//       shape: const RoundedRectangleBorder(),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Expanded(
//             child: ListView(
//               physics: const NeverScrollableScrollPhysics(),
//               padding: EdgeInsets.zero,
//               children: [
//                 // Header
//                 DrawerHeader(
//                   padding: 12.padRight,
//                   decoration: const BoxDecoration(color: Colors.white),
//                   child: Image.asset(
//                     AssetPath.appLogo.path,
//                     fit: BoxFit.contain,
//                   ),
//                 ),

//                 // Language
//                 CustomListTile(
//                   text: LocaleKeys.language.tr,
//                   leadingIconData: Icons.language,
//                   trillingIconData: Icons.arrow_forward_ios_rounded,
//                   onTap: languageHandleTap,
//                 ),
//                 16.height,

//                 // Term and condition
//                 // CustomListTile(
//                 //   text: LocaleKeys.termAndCondition.tr,
//                 //   leadingIconData: Icons.book_rounded,
//                 //   trillingIconData: Icons.arrow_forward_ios_rounded,
//                 //   onTap: termConditionHandleTap,
//                 // ),
//                 // 16.height,

//                 // Log out
//                 CustomListTile(
//                   leadingIconData: Icons.delete,
//                   text: LocaleKeys.deleteAccount.tr,
//                   trillingIconData: Icons.arrow_forward_ios_rounded,
//                   onTap: () => _showDeleteDialog(context),
//                 ),
//                 16.height,
//                 // Contact us
//                 CustomListTile(
//                   leadingIconData: Icons.contact_support,
//                   text: LocaleKeys.contactUs.tr,
//                   trillingIconData: Icons.arrow_forward_ios_rounded,
//                   onTap: contactUsHandleTap,
//                 ),
//                 16.height,

//                 // Log out
//                 CustomListTile(
//                   leadingIconData: Icons.logout,
//                   text: LocaleKeys.logout.tr,
//                   trillingIconData: Icons.arrow_forward_ios_rounded,
//                   onTap: logOutHandleTap,
//                 ),
//               ],
//             ),
//           ),
//           SafeArea(top: false, child: versionWidget()),
//           8.height,
//         ],
//       ),
//     );
//   }

//   Widget versionWidget() {
//     return Padding(
//       padding: 16.padLeft,
//       child: Text(
//         '${LocaleKeys.version.tr} ${AppConfig.shared.version}',
//         style: AppTextStyle.normalWhiteRegular,
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:apploan/core/core.dart';
import 'package:apploan/flavor/app_config.dart';
import 'package:apploan/routes.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({Key? key}) : super(key: key);

  // ── navigation handlers ───

  void _profileHandleTap() {
    Get.back();
    // TODO: navigate to profile page once route is ready
    // Get.toNamed(Routes.profile);
  }

  void _calculatorHandleTap() {
    Get.back();
    Get.toNamed(Routes.loancalculator);
  }

  void _languageHandleTap() {
    Get.back();
    Get.toNamed(Routes.language);
  }

  void _logOutHandleTap() {
    Get.back();
    DialogManager.showCustom(
      PrimaryDialog(
        title: LocaleKeys.logout.tr,
        subTitle: LocaleKeys.areYouSureYourWantToLogout.tr,
        btnText: LocaleKeys.yes.tr.toUpperCase(),
        onPressed: () async {
          Get.back();
          await UserRepository.shared.logout();
        },
      ),
    );
  }

  // ── build ───

  @override
  Widget build(BuildContext context) {
    final double drawerWidth = MediaQuery.of(context).size.width * 0.72;

    return Drawer(
      width: drawerWidth,
      shape: const RoundedRectangleBorder(), // no rounded corners
      child: Column(
        children: [
          // ── white header: logo + company name ───
          _buildHeader(),

          // ── red body: background image + menu items + footer ──
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: AppColor.hardOrange,
                image: DecorationImage(
                  image: AssetImage('assets/images/drawerbackground.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                children: [
                  // menu items
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.only(top: 24),
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        _buildMenuItem(
                          icon: Icons.account_circle_outlined,
                          label: 'Profile',
                          onTap: _profileHandleTap,
                        ),
                        _buildMenuItem(
                          icon: Icons.calculate_outlined,
                          label: LocaleKeys.loanCalculator.tr,
                          showArrow: true,
                          onTap: _calculatorHandleTap,
                        ),
                        _buildLanguageItem(),
                        _buildMenuItem(
                          icon: Icons.logout,
                          label: LocaleKeys.logout.tr,
                          onTap: _logOutHandleTap,
                        ),
                      ],
                    ),
                  ),

                  // footer logo + version
                  _buildFooter(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── header ───

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      color: Colors.white,
      // Extra top padding for status bar + extra bottom padding
      padding: const EdgeInsets.fromLTRB(16, 52, 16, 36),
      child: Column(
        children: [
          Image.asset(
            AssetPath.appLogo.path,
            height: 120,
            width: 120,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 12),
          Text(
            'អរលីកាខូមិលនីតី ANLIKA CO.,Ltd',
            textAlign: TextAlign.center,
            style: AppTextStyle.mediumDrawerHeaderRegular,
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  // ── generic menu item ───

  Widget _buildMenuItem({
    required IconData icon,
    required String label,
    bool showArrow = false,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.white, size: 24),
      title: Text(label, style: AppTextStyle.midWhiteRegular),
      trailing:
          showArrow
              ? const Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.white,
                size: 16,
              )
              : null,
      minLeadingWidth: 10,
      visualDensity: const VisualDensity(vertical: -1),
      onTap: onTap,
    );
  }

  // ── language item (shows current language text beside arrow) ───

  Widget _buildLanguageItem() {
    final String currentLang =
        AppConfig.shared.language == Language.en.key ? 'English' : 'ខ្មែរ';

    return ListTile(
      leading: const Icon(Icons.language, color: Colors.white, size: 24),
      title: Text(LocaleKeys.language.tr, style: AppTextStyle.midWhiteRegular),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(currentLang, style: AppTextStyle.normalWhiteRegular),
          const SizedBox(width: 6),
          const Icon(
            Icons.arrow_forward_ios_rounded,
            color: Colors.white,
            size: 16,
          ),
        ],
      ),
      minLeadingWidth: 10,
      visualDensity: const VisualDensity(vertical: -1),
      onTap: _languageHandleTap,
    );
  }

  // ── footer ───
  Widget _buildFooter() {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logo_ft_text.png',
              height: 55,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 6),
            Text(
              '${LocaleKeys.version.tr} ${AppConfig.shared.version}',
              style: AppTextStyle.smallWhiteRegular,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
