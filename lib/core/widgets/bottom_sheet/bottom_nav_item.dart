import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:apploan/core/core.dart';
import 'package:get/get.dart';

// ── Main dashboard nav (used by both roles) ──
List<TabItem> mainNavItems() => [
  TabItem(icon: Icons.dashboard, title: LocaleKeys.dashboard.tr),
  TabItem(icon: Icons.payment, title: LocaleKeys.paymentslist.tr),
  TabItem(icon: Icons.list_alt, title: LocaleKeys.loanDisbursmentsList.tr),
];

// ── Loans screen nav — CO role ──
List<TabItem> loanNavItemsCO() => [
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
  TabItem(icon: Icons.list_alt, title: LocaleKeys.loanDisbursmentsList.tr),
];

// ── Loans screen nav — Admin role ──
// Admin gets an extra Reports tab instead of Add Customer
List<TabItem> loanNavItemsAdmin() => [
  TabItem(icon: Icons.dashboard, title: LocaleKeys.loans.tr),
  TabItem(
    icon: Icons.bar_chart,
    title: 'Reports', // add locale key when ready
  ),
  TabItem(icon: Icons.list_alt, title: LocaleKeys.loanDisbursmentsList.tr),
];
